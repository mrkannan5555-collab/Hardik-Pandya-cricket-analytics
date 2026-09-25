$imgUrl = "https://upload.wikimedia.org/wikipedia/commons/5/5b/Hardik_Pandya_%28cropped%29.jpg"
$out = "c:\Users\mrkan\OneDrive\Desktop\KANNAN\HARDIK\hardik_photo.jpg"

$wc = [System.Net.HttpWebRequest]::Create($imgUrl)
$wc.UserAgent = "HardikDashboard/1.0 (portfolio@example.com)"
$resp = $wc.GetResponse()
$fs = [System.IO.File]::Create($out)
$resp.GetResponseStream().CopyTo($fs)
$fs.Close()
$resp.Close()

Write-Host "Success! File saved at $out, Size:" (Get-Item $out).Length "bytes"
