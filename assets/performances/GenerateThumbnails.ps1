get-childitem *.jpg -Recurse | ForEach-Object {
    if ($_.BaseName -ne "header" -and -not $_.FullName.EndsWith(".small.jpg") )
    {
        $smallName = $_.BaseName + ".small.jpg"
        $smallPath = join-path $_.DirectoryName  $smallName

        $fullImage = [System.Drawing.Image]::FromFile($_);
        $aspectRatio = $fullImage.height / $fullImage.width;
        $smallWidth = 350;
        $smallHeight = $smallWidth*$aspectRatio;

        if ($smallHeight -lt $fullImage.height -and $smallWidth -lt $fullImage.width) {
            $smallImage = $fullImage.GetThumbnailImage($smallWidth, $smallHeight, $null, [intptr]::Zero);
            $smallImage.Save($smallPath );
            $smallImage.Dispose();
        } else {
            $fullImage.Save($smallPath );
        }
        
        $fullImage.Dispose();
    }
}