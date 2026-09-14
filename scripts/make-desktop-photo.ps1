Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\david_fhdjjol\Desktop\096matics\public\tarjeta\conductor-francisco\foto.jpg"
$outPath = "C:\Users\david_fhdjjol\Desktop\096matics\public\tarjeta\conductor-francisco\foto-desktop.jpg"

$src = [System.Drawing.Image]::FromFile($srcPath)
$srcW = $src.Width
$srcH = $src.Height

$canvasW = 2200
$canvasH = $srcH
$pad = [int](($canvasW - $srcW) / 2)
$featherPx = 160

Write-Output "source: $srcW x $srcH, canvas: $canvasW x $canvasH, pad: $pad"

# --- 1. blurred backdrop: shrink way down (forces blur), then blow back up to cover the canvas ---
$thumbW = 70
$thumbH = [int]($srcH * ($thumbW / $srcW))
$thumb = New-Object System.Drawing.Bitmap($thumbW, $thumbH)
$gThumb = [System.Drawing.Graphics]::FromImage($thumb)
$gThumb.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gThumb.DrawImage($src, 0, 0, $thumbW, $thumbH)
$gThumb.Dispose()

$backdrop = New-Object System.Drawing.Bitmap($canvasW, $canvasH)
$gBackdrop = [System.Drawing.Graphics]::FromImage($backdrop)
$gBackdrop.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
# cover-fit the thumb into the canvas (thumb aspect == src aspect)
$scaleCover = [Math]::Max($canvasW / $thumbW, $canvasH / $thumbH)
$coverW = $thumbW * $scaleCover
$coverH = $thumbH * $scaleCover
$offX = ($canvasW - $coverW) / 2
$offY = ($canvasH - $coverH) / 2
$gBackdrop.DrawImage($thumb, $offX, $offY, $coverW, $coverH)
# darken
$darkBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(150, 10, 10, 10))
$gBackdrop.FillRectangle($darkBrush, 0, 0, $canvasW, $canvasH)
$gBackdrop.Dispose()
$thumb.Dispose()

# --- 2. feather the sharp source's left/right edges (alpha ramp) ---
$sharp = New-Object System.Drawing.Bitmap($srcW, $srcH, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$gSharp = [System.Drawing.Graphics]::FromImage($sharp)
$gSharp.DrawImage($src, 0, 0, $srcW, $srcH)
$gSharp.Dispose()

$rectFull = New-Object System.Drawing.Rectangle(0, 0, $srcW, $srcH)
$bmpData = $sharp.LockBits($rectFull, [System.Drawing.Imaging.ImageLockMode]::ReadWrite, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$stride = $bmpData.Stride
$bytes = $stride * $srcH
$buffer = New-Object byte[] $bytes
[System.Runtime.InteropServices.Marshal]::Copy($bmpData.Scan0, $buffer, 0, $bytes)

for ($y = 0; $y -lt $srcH; $y++) {
	$rowStart = $y * $stride
	for ($x = 0; $x -lt $featherPx; $x++) {
		$factor = $x / $featherPx
		# left edge
		$idxL = $rowStart + ($x * 4) + 3
		$buffer[$idxL] = [byte]([Math]::Min(255, $buffer[$idxL] * $factor))
		# right edge (mirrored)
		$xr = $srcW - 1 - $x
		$idxR = $rowStart + ($xr * 4) + 3
		$buffer[$idxR] = [byte]([Math]::Min(255, $buffer[$idxR] * $factor))
	}
}

[System.Runtime.InteropServices.Marshal]::Copy($buffer, 0, $bmpData.Scan0, $bytes)
$sharp.UnlockBits($bmpData)

# --- 3. composite: backdrop + feathered sharp centered on top ---
$gFinal = [System.Drawing.Graphics]::FromImage($backdrop)
$gFinal.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
$gFinal.DrawImage($sharp, $pad, 0, $srcW, $srcH)
$gFinal.Dispose()

# --- 4. save as jpeg (flatten, no alpha) ---
$jpgEncoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
$encParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [int64]90)
$backdrop.Save($outPath, $jpgEncoder, $encParams)

$backdrop.Dispose()
$sharp.Dispose()
$src.Dispose()

Write-Output "saved: $outPath"
