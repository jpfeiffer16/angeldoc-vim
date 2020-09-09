

$response = Invoke-RestMethod -Uri "https://api.github.com/repos/jpfeiffer16/AngelDoc/releases/latest"
$version = $response.tag_name
$location = "$($Env:USERPROFILE)\.angeldoc\bin"

if (Test-Path -Path $location) {
    Remove-Item $location -Force -Recurse
}

New-Item -ItemType Directory -Force -Path $location | Out-Null

$url = "https://github.com/jpfeiffer16/AngelDoc/releases/download/$($version)/AngelDoc.zip"
$out = "$($location)\AngelDoc.zip"

Invoke-WebRequest -Uri $url -OutFile $out

Expand-Archive $out $location -Force