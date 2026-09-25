$matches = Import-Csv "c:\Users\mrkan\OneDrive\Desktop\KANNAN\HARDIK\Hardik_Pandya_Career_Matches.csv"
$groups = $matches | Group-Object Format

foreach ($g in $groups) {
    $runs = ($g.Group | Measure-Object Runs -Sum).Sum
    $wkts = ($g.Group | Measure-Object Wickets -Sum).Sum
    $fours = ($g.Group | Measure-Object Fours -Sum).Sum
    $sixes = ($g.Group | Measure-Object Sixes -Sum).Sum
    Write-Host "Format: $($g.Name), Matches: $($g.Count), Runs: $runs, Wickets: $wkts, Fours: $fours, Sixes: $sixes"
}
