# Convert all CSVs (including phase, wagon wheel, matchups) into JS dataset
$matches = Import-Csv "c:\Users\mrkan\OneDrive\Desktop\KANNAN\HARDIK\Hardik_Pandya_Career_Matches.csv"
$yearly = Import-Csv "c:\Users\mrkan\OneDrive\Desktop\KANNAN\HARDIK\Hardik_Pandya_Yearly_Summary.csv"
$formats = Import-Csv "c:\Users\mrkan\OneDrive\Desktop\KANNAN\HARDIK\Hardik_Pandya_Format_Summary.csv"
$ipl = Import-Csv "c:\Users\mrkan\OneDrive\Desktop\KANNAN\HARDIK\Hardik_Pandya_IPL_Seasons.csv"
$opponents = Import-Csv "c:\Users\mrkan\OneDrive\Desktop\KANNAN\HARDIK\Hardik_Pandya_Opponents.csv"
$phases = Import-Csv "c:\Users\mrkan\OneDrive\Desktop\KANNAN\HARDIK\Hardik_Pandya_Phase_Analysis.csv"
$wagonWheel = Import-Csv "c:\Users\mrkan\OneDrive\Desktop\KANNAN\HARDIK\Hardik_Pandya_Wagon_Wheel.csv"
$matchups = Import-Csv "c:\Users\mrkan\OneDrive\Desktop\KANNAN\HARDIK\Hardik_Pandya_Bowler_Matchups.csv"

$matchesJson = $matches | ConvertTo-Json -Depth 3 -Compress
$yearlyJson = $yearly | ConvertTo-Json -Depth 3 -Compress
$formatsJson = $formats | ConvertTo-Json -Depth 3 -Compress
$iplJson = $ipl | ConvertTo-Json -Depth 3 -Compress
$opponentsJson = $opponents | ConvertTo-Json -Depth 3 -Compress
$phasesJson = $phases | ConvertTo-Json -Depth 3 -Compress
$wagonWheelJson = $wagonWheel | ConvertTo-Json -Depth 3 -Compress
$matchupsJson = $matchups | ConvertTo-Json -Depth 3 -Compress

$jsContent = @"
// Hardik Pandya Career Datasets - Local Pre-loaded Data
window.HARDIK_DATA = {
    matches: $matchesJson,
    yearly: $yearlyJson,
    formats: $formatsJson,
    ipl: $iplJson,
    opponents: $opponentsJson,
    phases: $phasesJson,
    wagonWheel: $wagonWheelJson,
    matchups: $matchupsJson
};
console.log('Hardik Pandya datasets loaded successfully:', window.HARDIK_DATA.matches.length, 'matches');
"@

$jsContent | Out-File -FilePath "c:\Users\mrkan\OneDrive\Desktop\KANNAN\HARDIK\hardik_data.js" -Encoding UTF8
Write-Host "Updated hardik_data.js with advanced analytics data!"
