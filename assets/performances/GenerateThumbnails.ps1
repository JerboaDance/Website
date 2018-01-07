param(
    [switch]$force
)
function Resize-Image {
    param(
        $originalImagePath,
        $smallImageWidth,
        $force
    )
    
    $smallImageName = $originalImagePath.BaseName + ".small.jpg"
    $smallImagePath = join-path $originalImagePath.DirectoryName  $smallImageName

    $originalImage = [System.Drawing.Image]::FromFile($originalImagePath)
    $aspectRatio = $originalImage.height / $originalImage.width
    $smallImageHeight = $smallImageWidth*$aspectRatio

    if ($force -or ($smallImageHeight -lt $originalImage.height -and $smallImageWidth -lt $originalImage.width)) {
        $smallImage = New-Object System.Drawing.Bitmap($smallImageWidth, $smallImageHeight)
        $smallImageCanvas = [System.Drawing.Graphics]::FromImage($smallImage)
        $smallImageCanvas.DrawImage($originalImage, 0, 0, $smallImageWidth, $smallImageHeight)
        $smallImage.Save($smallImagePath)
        $smallImage.Dispose()
    } else {
        $originalImage.Save($smallImagePath)
    }
    
    $originalImage.Dispose()
}

get-childitem *.jpg -Recurse | ForEach-Object {
    if (-not $_.FullName.EndsWith(".small.jpg")) {
        if ($_.BaseName -eq "header" ) {
            $smallImageWidth = 900
        }
        else {
            $smallImageWidth = 270
        }

        Resize-Image $_ $smallImageWidth -force:$force
    }
}