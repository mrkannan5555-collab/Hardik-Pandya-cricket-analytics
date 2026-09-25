$wc = [System.Net.HttpWebRequest]::Create("https://commons.wikimedia.org/w/api.php?action=query&titles=File:Hardik_Pandya_(cropped).jpg&prop=imageinfo&iiprop=url&format=json")
$wc.UserAgent = "HardikDashboard/1.0 (portfolio@example.com)"
$resp = $wc.GetResponse()
$sr = [System.IO.StreamReader]::new($resp.GetResponseStream())
$text = $sr.ReadToEnd()
Write-Host $text
