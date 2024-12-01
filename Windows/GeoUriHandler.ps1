param([string]$geo="geo:0,0")
$data = $geo.replace('geo:', '')
$coords = $data.split(';')[0].split(',')
$url = [System.String]::Concat('https://www.openstreetmap.org/?mlat=',$coords[0],'&mlon=',$coords[1],'&zoom=15')
Start-Process -FilePath $url;