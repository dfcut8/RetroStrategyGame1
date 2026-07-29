param(
    [Parameter(Mandatory = $true)]
    [string]$InputPath,

    [Parameter(Mandatory = $true)]
    [string]$OutputPath,

    [Parameter(Mandatory = $true)]
    [ValidateRange(1, 4096)]
    [int]$Width,

    [Parameter(Mandatory = $true)]
    [ValidateRange(1, 4096)]
    [int]$Height,

    [Parameter(Mandatory = $true)]
    [ValidateSet('sprite', 'opaque')]
    [string]$Mode,

    [ValidateRange(0, 256)]
    [int]$Padding = 2
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

function Test-ChromaKey {
    param([System.Drawing.Color]$Color)

    return $Color.A -eq 0 -or
        ($Color.R -gt 190 -and $Color.B -gt 150 -and $Color.G -lt 115)
}

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
    for ($y = 0; $y -lt $Bitmap.Height; $y++) {
        for ($x = 0; $x -lt $Bitmap.Width; $x++) {
            if (-not (Test-ChromaKey -Color $Bitmap.GetPixel($x, $y))) {
                $minX = [Math]::Min($minX, $x)
                $minY = [Math]::Min($minY, $y)
                $maxX = [Math]::Max($maxX, $x)
                $maxY = [Math]::Max($maxY, $y)
            }
        }
    }
    if ($maxX -lt 0) {
        throw 'No non-key pixels found in sprite source.'
    }
    return [System.Drawing.Rectangle]::FromLTRB($minX, $minY, $maxX + 1, $maxY + 1)
}

function Set-QuantizedPixels {
    param(
        [System.Drawing.Bitmap]$Bitmap,
        [bool]$UseTransparency
    )

    $opaqueColors = New-Object 'System.Collections.Generic.HashSet[string]'
    $transparentPixels = 0
    for ($y = 0; $y -lt $Bitmap.Height; $y++) {
        for ($x = 0; $x -lt $Bitmap.Width; $x++) {
            $pixel = $Bitmap.GetPixel($x, $y)
            if ($UseTransparency -and (Test-ChromaKey -Color $pixel)) {
                $Bitmap.SetPixel($x, $y, [System.Drawing.Color]::Transparent)
                $transparentPixels++
                continue
            }

            $nearest = Get-NearestPaletteColor -Color $pixel
            $Bitmap.SetPixel(
                $x,
                $y,
                [System.Drawing.Color]::FromArgb(255, $nearest.R, $nearest.G, $nearest.B)
            )
            $null = $opaqueColors.Add("$($nearest.R),$($nearest.G),$($nearest.B)")
        }
    }
    return [PSCustomObject]@{
        OpaqueColors = $opaqueColors.Count
        TransparentPixels = $transparentPixels
    }
}

$resolvedInput = (Resolve-Path -LiteralPath $InputPath).Path
$resolvedOutput = [System.IO.Path]::GetFullPath($OutputPath)
$outputDirectory = Split-Path -Parent $resolvedOutput
if ($outputDirectory) {
    New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null
}

$source = [System.Drawing.Bitmap]::FromFile($resolvedInput)
try {
    if ($Mode -eq 'sprite') {
        if (($Padding * 2) -ge $Width -or ($Padding * 2) -ge $Height) {
            throw 'Padding leaves no drawable area.'
        }

        $sourceBounds = Get-KeyedBounds -Bitmap $source
        $availableWidth = $Width - ($Padding * 2)
        $availableHeight = $Height - ($Padding * 2)
        $scale = [Math]::Min(
            $availableWidth / $sourceBounds.Width,
            $availableHeight / $sourceBounds.Height
        )
        $drawWidth = [Math]::Max(1, [int][Math]::Floor($sourceBounds.Width * $scale))
        $drawHeight = [Math]::Max(1, [int][Math]::Floor($sourceBounds.Height * $scale))
        $pixelFormat = [System.Drawing.Imaging.PixelFormat]::Format32bppArgb
        $output = New-Object System.Drawing.Bitmap $Width, $Height, $pixelFormat
        try {
            $graphics = [System.Drawing.Graphics]::FromImage($output)
            try {
                $graphics.Clear([System.Drawing.Color]::Transparent)
                $graphics.InterpolationMode =
                    [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
                $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
                $destination = New-Object System.Drawing.Rectangle(
                    [int](($Width - $drawWidth) / 2),
                    [int](($Height - $drawHeight) / 2),
                    $drawWidth,
                    $drawHeight
                )
                $graphics.DrawImage(
                    $source,
                    $destination,
                    $sourceBounds.X,
                    $sourceBounds.Y,
                    $sourceBounds.Width,
                    $sourceBounds.Height,
                    [System.Drawing.GraphicsUnit]::Pixel
                )
            }
            finally {
                $graphics.Dispose()
            }

            $metrics = Set-QuantizedPixels -Bitmap $output -UseTransparency $true
            if ($metrics.TransparentPixels -eq 0) {
                throw 'Sprite output has no transparent pixels.'
            }
            $output.Save($resolvedOutput, [System.Drawing.Imaging.ImageFormat]::Png)
        }
        finally {
            $output.Dispose()
        }
    }
    else {
        $pixelFormat = [System.Drawing.Imaging.PixelFormat]::Format24bppRgb
        $output = New-Object System.Drawing.Bitmap $Width, $Height, $pixelFormat
        try {
            $graphics = [System.Drawing.Graphics]::FromImage($output)
            try {
                $graphics.InterpolationMode =
                    [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
                $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
                $destination = New-Object System.Drawing.Rectangle(0, 0, $Width, $Height)
                $graphics.DrawImage($source, $destination)
            }
            finally {
                $graphics.Dispose()
            }

            $metrics = Set-QuantizedPixels -Bitmap $output -UseTransparency $false
            $output.Save($resolvedOutput, [System.Drawing.Imaging.ImageFormat]::Png)
        }
        finally {
            $output.Dispose()
        }
    }
}
finally {
    $source.Dispose()
}

Write-Output ([PSCustomObject]@{
    Path = $resolvedOutput
    Width = $Width
    Height = $Height
    Mode = $Mode
    OpaqueColors = $metrics.OpaqueColors
    TransparentPixels = $metrics.TransparentPixels
} | ConvertTo-Json -Compress)
