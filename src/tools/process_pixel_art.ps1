param(
    [string]$GeneratedSourceDirectory = '',

    [Parameter(Mandatory = $true)]
    [string]$ProjectDirectory
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Drawing

$palette = @(
    [System.Drawing.Color]::FromArgb(9, 8, 13),
    [System.Drawing.Color]::FromArgb(23, 20, 31),
    [System.Drawing.Color]::FromArgb(36, 32, 45),
    [System.Drawing.Color]::FromArgb(48, 42, 58),
    [System.Drawing.Color]::FromArgb(93, 83, 107),
    [System.Drawing.Color]::FromArgb(170, 162, 178),
    [System.Drawing.Color]::FromArgb(228, 221, 204),
    [System.Drawing.Color]::FromArgb(244, 239, 226),
    [System.Drawing.Color]::FromArgb(138, 127, 200),
    [System.Drawing.Color]::FromArgb(197, 139, 50),
    [System.Drawing.Color]::FromArgb(181, 87, 55),
    [System.Drawing.Color]::FromArgb(101, 198, 189),
    [System.Drawing.Color]::FromArgb(141, 150, 82),
    [System.Drawing.Color]::FromArgb(111, 77, 46),
    [System.Drawing.Color]::FromArgb(122, 116, 107),
    [System.Drawing.Color]::FromArgb(217, 182, 95)
)

function Get-NearestPaletteColor {
    param([System.Drawing.Color]$Color)

    $best = $palette[0]
    $bestDistance = [double]::MaxValue
    foreach ($candidate in $palette) {
        $red = [int]$Color.R - [int]$candidate.R
        $green = [int]$Color.G - [int]$candidate.G
        $blue = [int]$Color.B - [int]$candidate.B
        $distance = (2 * $red * $red) + (4 * $green * $green) + (3 * $blue * $blue)
        if ($distance -lt $bestDistance) {
            $bestDistance = $distance
            $best = $candidate
        }
    }
    return $best
}

function Get-KeyedBounds {
    param([System.Drawing.Bitmap]$Bitmap)

    $minX = $Bitmap.Width
    $minY = $Bitmap.Height
    $maxX = -1
    $maxY = -1
    for ($y = 0; $y -lt $Bitmap.Height; $y += 2) {
        for ($x = 0; $x -lt $Bitmap.Width; $x += 2) {
            $pixel = $Bitmap.GetPixel($x, $y)
            $isKey = $pixel.R -gt 220 -and $pixel.B -gt 180 -and $pixel.G -lt 80
            if (-not $isKey) {
                $minX = [Math]::Min($minX, $x)
                $minY = [Math]::Min($minY, $y)
                $maxX = [Math]::Max($maxX, $x)
                $maxY = [Math]::Max($maxY, $y)
            }
        }
    }
    if ($maxX -lt 0) {
        throw 'No non-key pixels found.'
    }
    return [System.Drawing.Rectangle]::FromLTRB(
        [Math]::Max(0, $minX - 8),
        [Math]::Max(0, $minY - 8),
        [Math]::Min($Bitmap.Width, $maxX + 10),
        [Math]::Min($Bitmap.Height, $maxY + 10)
    )
}

function Convert-Sprite {
    param(
        [string]$InputPath,
        [string]$OutputPath,
        [int]$TargetWidth,
        [int]$TargetHeight
    )

    $source = [System.Drawing.Bitmap]::FromFile($InputPath)
    try {
        $bounds = Get-KeyedBounds -Bitmap $source
        $scale = [Math]::Min($TargetWidth / $bounds.Width, $TargetHeight / $bounds.Height)
        $width = [Math]::Max(1, [int][Math]::Floor($bounds.Width * $scale))
        $height = [Math]::Max(1, [int][Math]::Floor($bounds.Height * $scale))
        $output = New-Object System.Drawing.Bitmap $TargetWidth, $TargetHeight,
            ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
        try {
            $graphics = [System.Drawing.Graphics]::FromImage($output)
            try {
                $graphics.Clear([System.Drawing.Color]::Transparent)
                $graphics.InterpolationMode =
                    [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
                $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
                $destination = New-Object System.Drawing.Rectangle(
                    [int](($TargetWidth - $width) / 2),
                    [int](($TargetHeight - $height) / 2),
                    $width,
                    $height
                )
                $graphics.DrawImage(
                    $source,
                    $destination,
                    $bounds.X,
                    $bounds.Y,
                    $bounds.Width,
                    $bounds.Height,
                    [System.Drawing.GraphicsUnit]::Pixel
                )
            }
            finally {
                $graphics.Dispose()
            }

            for ($y = 0; $y -lt $output.Height; $y++) {
                for ($x = 0; $x -lt $output.Width; $x++) {
                    $pixel = $output.GetPixel($x, $y)
                    if ($pixel.A -eq 0 -or
                        ($pixel.R -gt 190 -and $pixel.B -gt 150 -and $pixel.G -lt 115)) {
                        $output.SetPixel($x, $y, [System.Drawing.Color]::Transparent)
                    }
                    else {
                        $nearest = Get-NearestPaletteColor -Color $pixel
                        $output.SetPixel(
                            $x,
                            $y,
                            [System.Drawing.Color]::FromArgb(
                                255,
                                $nearest.R,
                                $nearest.G,
                                $nearest.B
                            )
                        )
                    }
                }
            }
            $output.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
        }
        finally {
            $output.Dispose()
        }
    }
    finally {
        $source.Dispose()
    }
}

function Convert-Ground {
    param([string]$InputPath, [string]$OutputPath)

    $source = [System.Drawing.Bitmap]::FromFile($InputPath)
    try {
        $output = New-Object System.Drawing.Bitmap 640, 360,
            ([System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
        try {
            $graphics = [System.Drawing.Graphics]::FromImage($output)
            try {
                $graphics.InterpolationMode =
                    [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
                $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
                $graphics.DrawImage($source, (New-Object System.Drawing.Rectangle(0, 0, 640, 360)))
            }
            finally {
                $graphics.Dispose()
            }
            for ($y = 0; $y -lt $output.Height; $y++) {
                for ($x = 0; $x -lt $output.Width; $x++) {
                    $nearest = Get-NearestPaletteColor -Color $output.GetPixel($x, $y)
                    $output.SetPixel($x, $y, $nearest)
                }
            }
            $output.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
        }
        finally {
            $output.Dispose()
        }
    }
    finally {
        $source.Dispose()
    }
}

$rawDirectory = Join-Path $ProjectDirectory 'assets\source\imagegen'
$spriteDirectory = Join-Path $ProjectDirectory 'assets\sprites\camp'
$textureDirectory = Join-Path $ProjectDirectory 'assets\textures'

New-Item -ItemType Directory -Force -Path $rawDirectory | Out-Null
New-Item -ItemType Directory -Force -Path $spriteDirectory | Out-Null
New-Item -ItemType Directory -Force -Path $textureDirectory | Out-Null

$sources = @{
    'ground-source.png' = 'exec-cb89c23c-8268-4647-a4e0-7a54608bfb67.png'
    'tarp-shelter-source.png' = 'exec-05e7d3dc-6ae9-45d2-b654-80b1f015326c.png'
    'water-collector-source.png' = 'exec-151afdba-1b55-47b5-90fc-cf8f47e93741.png'
    'scrap-cache-source.png' = 'exec-7dc9ca84-2ee9-4299-99a4-d97baa993949.png'
    'permanent-hub-source.png' = 'exec-244a6fdd-7ed4-43f5-8b83-74c488fef088.png'
}

if ($GeneratedSourceDirectory) {
    foreach ($entry in $sources.GetEnumerator()) {
        Copy-Item -LiteralPath (Join-Path $GeneratedSourceDirectory $entry.Value) `
            -Destination (Join-Path $rawDirectory $entry.Key) -Force
    }
}
else {
    foreach ($sourceName in $sources.Keys) {
        $stableSourcePath = Join-Path $rawDirectory $sourceName
        if (-not (Test-Path -LiteralPath $stableSourcePath)) {
            throw "Missing retained source asset: $stableSourcePath"
        }
    }
}

Convert-Ground `
    -InputPath (Join-Path $rawDirectory 'ground-source.png') `
    -OutputPath (Join-Path $textureDirectory 'camp_ground.png')
Convert-Sprite `
    -InputPath (Join-Path $rawDirectory 'tarp-shelter-source.png') `
    -OutputPath (Join-Path $spriteDirectory 'tarp_shelter.png') `
    -TargetWidth 96 -TargetHeight 80
Convert-Sprite `
    -InputPath (Join-Path $rawDirectory 'water-collector-source.png') `
    -OutputPath (Join-Path $spriteDirectory 'water_collector.png') `
    -TargetWidth 96 -TargetHeight 80
Convert-Sprite `
    -InputPath (Join-Path $rawDirectory 'scrap-cache-source.png') `
    -OutputPath (Join-Path $spriteDirectory 'scrap_cache.png') `
    -TargetWidth 96 -TargetHeight 80
Convert-Sprite `
    -InputPath (Join-Path $rawDirectory 'permanent-hub-source.png') `
    -OutputPath (Join-Path $spriteDirectory 'permanent_hub.png') `
    -TargetWidth 112 -TargetHeight 96

Write-Output "Processed Ashfall Camp assets into $ProjectDirectory"
