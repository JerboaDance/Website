get-childitem *.jpg -Recurse | ForEach-Object {
    if ($_.BaseName -ne "header" -and -not $_.FullName.EndsWith(".small.jpg") )
    {
        $fullImage = [System.Drawing.Image]::FromFile($_);
        $aspectRatio = $fullImage.height / $fullImage.width;
        $smallImage = $fullImage.GetThumbnailImage(350, 350*$aspectRatio, $null, [intptr]::Zero);

        $smallName = $_.BaseName + ".small.jpg"
        $smallPath = join-path $_.DirectoryName  $smallName
        $smallImage.Save($smallPath );
        $fullImage.Dispose();
        $smallImage.Dispose();
    }
}