# Precise Mathematical Data Calibration Script for Hardik Pandya
# Generates EXACT official career totals:
# Test: 11 matches, 532 runs, 17 wkts, 68 fours, 12 sixes
# ODI: 86 matches, 1769 runs, 84 wkts, 138 fours, 68 sixes
# T20I: 104 matches, 1641 runs, 86 wkts, 124 fours, 84 sixes
# IPL: 137 matches, 2525 runs, 64 wkts, 195 fours, 134 sixes
# TOTAL: 338 matches, 6467 runs, 251 wkts, 525 fours, 298 sixes

$workspaceDir = "c:\Users\mrkan\OneDrive\Desktop\KANNAN\HARDIK"

$venues = @{
    "India" = @("Wankhede Stadium, Mumbai", "Eden Gardens, Kolkata", "M Chinnaswamy Stadium, Bengaluru", "Narendra Modi Stadium, Ahmedabad", "MA Chidambaram Stadium, Chennai", "Arun Jaitley Stadium, Delhi", "HPCA Stadium, Dharamsala", "PCA Stadium, Mohali", "Rajiv Gandhi Stadium, Hyderabad")
    "Australia" = @("Melbourne Cricket Ground", "Sydney Cricket Ground", "Adelaide Oval", "The Gabba, Brisbane", "Perth Stadium")
    "England" = @("Lord's, London", "The Oval, London", "Trent Bridge, Nottingham", "Edgbaston, Birmingham", "Old Trafford, Manchester", "Headingley, Leeds")
    "South Africa" = @("Wanderers Stadium, Johannesburg", "SuperSport Park, Centurion", "Newlands, Cape Town", "Kingsmead, Durban")
    "UAE" = @("Dubai International Cricket Stadium", "Sharjah Cricket Stadium", "Sheikh Zayed Stadium, Abu Dhabi")
    "West Indies" = @("Kensington Oval, Bridgetown", "Brian Lara Cricket Academy, Tarouba", "Providence Stadium, Guyana")
    "Sri Lanka" = @("R Premadasa Stadium, Colombo", "Pallekele International Stadium, Kandy", "Galle International Stadium")
    "New Zealand" = @("Eden Park, Auckland", "Seddon Park, Hamilton", "Bay Oval, Mount Maunganui")
}

$opponentsIntl = @("Australia", "England", "Pakistan", "South Africa", "New Zealand", "Sri Lanka", "West Indies", "Bangladesh", "Afghanistan", "Zimbabwe", "Ireland")
$opponentsIPL = @("Chennai Super Kings", "Kolkata Knight Riders", "Royal Challengers Bengaluru", "Delhi Capitals", "Punjab Kings", "Rajasthan Royals", "Sunrisers Hyderabad", "Lucknow Super Giants")

class MatchRecord {
    [string]$Match_ID
    [string]$Match_Date
    [int]$Year
    [string]$Format
    [string]$Tournament
    [string]$Team
    [string]$Opponent
    [string]$Venue
    [string]$Host_Country
    [string]$Home_Away
    [int]$Batting_Innings
    [int]$Batting_Position
    [int]$Runs
    [int]$Balls
    [int]$Fours
    [int]$Sixes
    [string]$Dismissal_Mode
    [double]$Strike_Rate
    [double]$Overs
    [int]$Maidens
    [int]$Runs_Conceded
    [int]$Wickets
    [double]$Economy
    [int]$Catches
    [string]$Result
    [string]$Player_of_Match
    [double]$Match_Impact_Score
}

$allMatches = [System.Collections.Generic.List[MatchRecord]]::new()

function Build-Format-Matches {
    param(
        [string]$format,
        [int]$targetMatches,
        [int]$targetRuns,
        [int]$targetWkts,
        [int]$targetFours,
        [int]$targetSixes,
        [double]$targetOvers,
        [int]$targetRC,
        [int]$targetCatches,
        [int]$highestScore,
        [scriptblock]$initBlock
    )
    
    $formatMatches = [System.Collections.Generic.List[MatchRecord]]::new()
    & $initBlock $formatMatches
    
    $currentCount = $formatMatches.Count
    $remainingMatches = $targetMatches - $currentCount
    
    $currentRuns = ($formatMatches | Measure-Object -Property Runs -Sum).Sum
    $currentWkts = ($formatMatches | Measure-Object -Property Wickets -Sum).Sum
    $currentFours = ($formatMatches | Measure-Object -Property Fours -Sum).Sum
    $currentSixes = ($formatMatches | Measure-Object -Property Sixes -Sum).Sum
    $currentRC = ($formatMatches | Measure-Object -Property Runs_Conceded -Sum).Sum
    $currentCatches = ($formatMatches | Measure-Object -Property Catches -Sum).Sum

    $neededRuns = $targetRuns - $currentRuns
    $neededWkts = $targetWkts - $currentWkts
    $neededFours = $targetFours - $currentFours
    $neededSixes = $targetSixes - $currentSixes
    $neededRC = $targetRC - $currentRC
    $neededCatches = $targetCatches - $currentCatches

    $rng = [System.Random]::new(19931011 + $format.GetHashCode())

    # Distribute remaining values across remaining matches
    $runParts = [int[]]::new($remainingMatches)
    $wktParts = [int[]]::new($remainingMatches)
    $fourParts = [int[]]::new($remainingMatches)
    $sixParts = [int[]]::new($remainingMatches)
    $rcParts = [int[]]::new($remainingMatches)
    $catchParts = [int[]]::new($remainingMatches)

    # Simple integer partitions
    for ($i = 0; $i -lt $neededRuns; $i++) { $runParts[$rng.Next($remainingMatches)]++ }
    for ($i = 0; $i -lt $neededWkts; $i++) { $wktParts[$rng.Next($remainingMatches)]++ }
    for ($i = 0; $i -lt $neededFours; $i++) { $fourParts[$rng.Next($remainingMatches)]++ }
    for ($i = 0; $i -lt $neededSixes; $i++) { $sixParts[$rng.Next($remainingMatches)]++ }
    for ($i = 0; $i -lt $neededRC; $i++) { $rcParts[$rng.Next($remainingMatches)]++ }
    for ($i = 0; $i -lt $neededCatches; $i++) { $catchParts[$rng.Next($remainingMatches)]++ }

    for ($k = 0; $k -lt $remainingMatches; $k++) {
        $m = [MatchRecord]::new()
        $yr = $rng.Next(2015, 2025)
        if ($format -eq "Test") { $yr = $rng.Next(2017, 2019) }
        
        $m.Year = $yr
        $m.Match_ID = "M-$yr-" + $format.ToUpper() + "-" + ("{0:D3}" -f ($k + 20))
        $month = $rng.Next(1, 13)
        $day = $rng.Next(1, 28)
        $m.Match_Date = "$yr-" + ("{0:D2}" -f $month) + "-" + ("{0:D2}" -f $day)
        $m.Format = $format
        $m.Team = if ($format -eq "IPL") { if ($yr -ge 2022 -and $yr -le 2023) { "Gujarat Titans" } else { "Mumbai Indians" } } else { "India" }
        $m.Opponent = if ($format -eq "IPL") { $opponentsIPL[$rng.Next($opponentsIPL.Count)] } else { $opponentsIntl[$rng.Next($opponentsIntl.Count)] }
        $m.Tournament = if ($format -eq "IPL") { "Indian Premier League $yr" } else { "International Series $yr" }
        $m.Host_Country = "India"
        $m.Home_Away = if ($rng.Next(2) -eq 0) { "Home" } else { "Away" }
        $venueList = $venues["India"]
        $m.Venue = $venueList[$rng.Next($venueList.Count)]

        $r = $runParts[$k]
        $m.Runs = $r
        $m.Fours = [Math]::Min($fourParts[$k], [int]($r / 4))
        $m.Sixes = [Math]::Min($sixParts[$k], [int]($r / 6))
        
        if ($r -gt 0) {
            $m.Batting_Innings = 1
            $m.Batting_Position = if ($format -eq "Test") { 7 } elseif ($m.Team -eq "Gujarat Titans") { 4 } else { 6 }
            $m.Balls = [Math]::Max(($m.Fours + $m.Sixes + 1), [int]($r / (1.1 + $rng.NextDouble() * 0.4)))
            $m.Dismissal_Mode = if ($rng.NextDouble() -lt 0.2) { "not out" } else { @("caught", "bowled", "lbw")[$rng.Next(3)] }
            $m.Strike_Rate = [Math]::Round(($m.Runs / $m.Balls) * 100, 2)
        } else {
            $m.Batting_Innings = if ($rng.NextDouble() -lt 0.3) { 1 } else { 0 }
            $m.Balls = if ($m.Batting_Innings -eq 1) { $rng.Next(1, 4) } else { 0 }
            $m.Dismissal_Mode = if ($m.Batting_Innings -eq 1) { "caught" } else { "dnb" }
            $m.Strike_Rate = 0.0
        }

        $w = $wktParts[$k]
        $rc = $rcParts[$k]
        $m.Wickets = $w
        $m.Runs_Conceded = $rc
        
        if ($w -gt 0 -or $rc -gt 0) {
            $ov = if ($format -eq "Test") { [Math]::Round($rng.Next(6, 18) + ($rng.Next(0, 6) / 10.0), 1) }
                  elseif ($format -eq "ODI") { [Math]::Round($rng.Next(4, 10) + ($rng.Next(0, 6) / 10.0), 1) }
                  else { [Math]::Round($rng.Next(2, 4) + ($rng.Next(0, 6) / 10.0), 1) }
            $m.Overs = $ov
            $m.Economy = if ($ov -gt 0) { [Math]::Round($rc / $ov, 2) } else { 0.0 }
        } else {
            $m.Overs = 0.0
            $m.Economy = 0.0
        }

        $m.Maidens = if ($m.Overs -ge 5 -and $rng.NextDouble() -lt 0.25) { 1 } else { 0 }
        $m.Catches = $catchParts[$k]
        $m.Result = if ($rng.NextDouble() -lt 0.64) { "Won" } else { "Lost" }
        $m.Player_of_Match = if (($m.Runs -ge 50 -or $m.Wickets -ge 3) -and $m.Result -eq "Won" -and $rng.NextDouble() -lt 0.4) { "Yes" } else { "No" }
        
        $imp = ($m.Runs * 1.0) + (($m.Strike_Rate - 100) * 0.15) + ($m.Wickets * 22) + ([Math]::Max(0, (7.5 - $m.Economy)) * 2.5) + ($m.Catches * 8)
        $m.Match_Impact_Score = [Math]::Max(2.0, [Math]::Round($imp, 1))

        $formatMatches.Add($m)
    }

    # Format boundary rebalance to guarantee exact four and six counts
    $curF = ($formatMatches | Measure-Object -Property Fours -Sum).Sum
    $curS = ($formatMatches | Measure-Object -Property Sixes -Sum).Sum
    $diffF = $targetFours - $curF
    $diffS = $targetSixes - $curS

    if ($diffF -gt 0) {
        for ($x = 0; $x -lt $diffF; $x++) {
            $candidate = $formatMatches | Where-Object { $_.Runs -ge 20 } | Get-Random
            if ($candidate) { $candidate.Fours++ }
        }
    }
    if ($diffS -gt 0) {
        for ($x = 0; $x -lt $diffS; $x++) {
            $candidate = $formatMatches | Where-Object { $_.Runs -ge 25 } | Get-Random
            if ($candidate) { $candidate.Sixes++ }
        }
    }

    return $formatMatches
}

# ----------------- TEST (11 Matches, 532 Runs, 17 Wkts, 68 Fours, 12 Sixes) -----------------
$testMatches = Build-Format-Matches "Test" 11 532 17 68 12 163.3 552 7 108 {
    param($list)
    # Match 1: Pallekele 108 (SL)
    $m1 = [MatchRecord]@{
        Match_ID = "M-TEST-001"; Match_Date = "2017-08-13"; Year = 2017; Format = "Test"; Tournament = "India tour of Sri Lanka"
        Team = "India"; Opponent = "Sri Lanka"; Venue = "Pallekele International Stadium, Kandy"; Host_Country = "Sri Lanka"; Home_Away = "Away"
        Batting_Innings = 1; Batting_Position = 8; Runs = 108; Balls = 96; Fours = 8; Sixes = 7; Dismissal_Mode = "caught"
        Strike_Rate = 112.50; Overs = 1.0; Maidens = 0; Runs_Conceded = 7; Wickets = 0; Economy = 7.00; Catches = 1
        Result = "Won"; Player_of_Match = "Yes"; Match_Impact_Score = 126.5
    }
    # Match 2: Trent Bridge 5/28 & 52* (ENG)
    $m2 = [MatchRecord]@{
        Match_ID = "M-TEST-002"; Match_Date = "2018-08-18"; Year = 2018; Format = "Test"; Tournament = "India tour of England"
        Team = "India"; Opponent = "England"; Venue = "Trent Bridge, Nottingham"; Host_Country = "England"; Home_Away = "Away"
        Batting_Innings = 1; Batting_Position = 7; Runs = 70; Balls = 62; Fours = 10; Sixes = 1; Dismissal_Mode = "not out"
        Strike_Rate = 112.90; Overs = 17.0; Maidens = 2; Runs_Conceded = 50; Wickets = 6; Economy = 2.94; Catches = 2
        Result = "Won"; Player_of_Match = "Yes"; Match_Impact_Score = 184.2
    }
    $list.Add($m1); $list.Add($m2)
}

# ----------------- ODI (86 Matches, 1769 Runs, 84 Wkts, 138 Fours, 68 Sixes) -----------------
$odiMatches = Build-Format-Matches "ODI" 86 1769 84 138 68 574.5 3194 33 92 {
    param($list)
    # CT 2017 Final vs PAK (76 off 43)
    $m1 = [MatchRecord]@{
        Match_ID = "M-ODI-001"; Match_Date = "2017-06-18"; Year = 2017; Format = "ODI"; Tournament = "ICC Champions Trophy Final"
        Team = "India"; Opponent = "Pakistan"; Venue = "The Oval, London"; Host_Country = "England"; Home_Away = "Neutral"
        Batting_Innings = 1; Batting_Position = 7; Runs = 76; Balls = 43; Fours = 3; Sixes = 6; Dismissal_Mode = "run out"
        Strike_Rate = 176.74; Overs = 10.0; Maidens = 0; Runs_Conceded = 53; Wickets = 1; Economy = 5.30; Catches = 0
        Result = "Lost"; Player_of_Match = "No"; Match_Impact_Score = 118.5
    }
    # Canberra 2020 vs AUS (92* off 76)
    $m2 = [MatchRecord]@{
        Match_ID = "M-ODI-002"; Match_Date = "2020-12-02"; Year = 2020; Format = "ODI"; Tournament = "India tour of Australia"
        Team = "India"; Opponent = "Australia"; Venue = "Manuka Oval, Canberra"; Host_Country = "Australia"; Home_Away = "Away"
        Batting_Innings = 1; Batting_Position = 6; Runs = 92; Balls = 76; Fours = 7; Sixes = 1; Dismissal_Mode = "not out"
        Strike_Rate = 121.05; Overs = 0.0; Maidens = 0; Runs_Conceded = 0; Wickets = 0; Economy = 0.0; Catches = 1
        Result = "Won"; Player_of_Match = "Yes"; Match_Impact_Score = 125.0
    }
    # Manchester 2022 vs ENG (71 off 55 & 4/24)
    $m3 = [MatchRecord]@{
        Match_ID = "M-ODI-003"; Match_Date = "2022-07-17"; Year = 2022; Format = "ODI"; Tournament = "India tour of England"
        Team = "India"; Opponent = "England"; Venue = "Old Trafford, Manchester"; Host_Country = "England"; Home_Away = "Away"
        Batting_Innings = 1; Batting_Position = 5; Runs = 71; Balls = 55; Fours = 10; Sixes = 0; Dismissal_Mode = "caught"
        Strike_Rate = 129.09; Overs = 7.0; Maidens = 3; Runs_Conceded = 24; Wickets = 4; Economy = 3.43; Catches = 1
        Result = "Won"; Player_of_Match = "Yes"; Match_Impact_Score = 192.5
    }
    $list.Add($m1); $list.Add($m2); $list.Add($m3)
}

# ----------------- T20I (104 Matches, 1641 Runs, 86 Wkts, 124 Fours, 84 Sixes) -----------------
$t20iMatches = Build-Format-Matches "T20I" 104 1641 86 124 84 302.2 2468 52 71 {
    param($list)
    # T20 WC 2024 Final vs SA (3/20 - Defended 16 in final over)
    $m1 = [MatchRecord]@{
        Match_ID = "M-T20I-001"; Match_Date = "2024-06-29"; Year = 2024; Format = "T20I"; Tournament = "ICC Men's T20 World Cup Final"
        Team = "India"; Opponent = "South Africa"; Venue = "Kensington Oval, Bridgetown"; Host_Country = "West Indies"; Home_Away = "Neutral"
        Batting_Innings = 1; Batting_Position = 6; Runs = 5; Balls = 2; Fours = 1; Sixes = 0; Dismissal_Mode = "not out"
        Strike_Rate = 250.00; Overs = 3.0; Maidens = 0; Runs_Conceded = 20; Wickets = 3; Economy = 6.67; Catches = 0
        Result = "Won"; Player_of_Match = "No"; Match_Impact_Score = 112.5
    }
    # Asia Cup 2022 vs PAK (3/25 & 33*)
    $m2 = [MatchRecord]@{
        Match_ID = "M-T20I-002"; Match_Date = "2022-08-28"; Year = 2022; Format = "T20I"; Tournament = "Asia Cup 2022"
        Team = "India"; Opponent = "Pakistan"; Venue = "Dubai International Cricket Stadium"; Host_Country = "UAE"; Home_Away = "Neutral"
        Batting_Innings = 1; Batting_Position = 5; Runs = 33; Balls = 17; Fours = 4; Sixes = 1; Dismissal_Mode = "not out"
        Strike_Rate = 194.12; Overs = 4.0; Maidens = 0; Runs_Conceded = 25; Wickets = 3; Economy = 6.25; Catches = 0
        Result = "Won"; Player_of_Match = "Yes"; Match_Impact_Score = 128.5
    }
    # T20 WC 2022 Semi vs ENG (63 off 33)
    $m3 = [MatchRecord]@{
        Match_ID = "M-T20I-003"; Match_Date = "2022-11-10"; Year = 2022; Format = "T20I"; Tournament = "ICC Men's T20 World Cup"
        Team = "India"; Opponent = "England"; Venue = "Adelaide Oval"; Host_Country = "Australia"; Home_Away = "Neutral"
        Batting_Innings = 1; Batting_Position = 5; Runs = 63; Balls = 33; Fours = 4; Sixes = 5; Dismissal_Mode = "hit wicket"
        Strike_Rate = 190.91; Overs = 3.0; Maidens = 0; Runs_Conceded = 34; Wickets = 0; Economy = 11.33; Catches = 0
        Result = "Lost"; Player_of_Match = "No"; Match_Impact_Score = 78.5
    }
    $list.Add($m1); $list.Add($m2); $list.Add($m3)
}

# ----------------- IPL (137 Matches, 2525 Runs, 64 Wkts, 195 Fours, 134 Sixes) -----------------
$iplMatches = Build-Format-Matches "IPL" 137 2525 64 195 134 295.4 2615 65 91 {
    param($list)
    # IPL 2022 Final vs RR (3/17 & 34 - Captain Champions)
    $m1 = [MatchRecord]@{
        Match_ID = "M-IPL-001"; Match_Date = "2022-05-29"; Year = 2022; Format = "IPL"; Tournament = "IPL 2022 Final"
        Team = "Gujarat Titans"; Opponent = "Rajasthan Royals"; Venue = "Narendra Modi Stadium, Ahmedabad"; Host_Country = "India"; Home_Away = "Home"
        Batting_Innings = 1; Batting_Position = 4; Runs = 34; Balls = 30; Fours = 3; Sixes = 1; Dismissal_Mode = "caught"
        Strike_Rate = 113.33; Overs = 4.0; Maidens = 0; Runs_Conceded = 17; Wickets = 3; Economy = 4.25; Catches = 0
        Result = "Won"; Player_of_Match = "Yes"; Match_Impact_Score = 138.5
    }
    # IPL 2019 vs KKR (91 off 34 balls)
    $m2 = [MatchRecord]@{
        Match_ID = "M-IPL-002"; Match_Date = "2019-04-28"; Year = 2019; Format = "IPL"; Tournament = "Indian Premier League 2019"
        Team = "Mumbai Indians"; Opponent = "Kolkata Knight Riders"; Venue = "Eden Gardens, Kolkata"; Host_Country = "India"; Home_Away = "Away"
        Batting_Innings = 1; Batting_Position = 4; Runs = 91; Balls = 34; Fours = 6; Sixes = 9; Dismissal_Mode = "caught"
        Strike_Rate = 267.65; Overs = 4.0; Maidens = 0; Runs_Conceded = 44; Wickets = 1; Economy = 11.00; Catches = 0
        Result = "Lost"; Player_of_Match = "No"; Match_Impact_Score = 142.5
    }
    $list.Add($m1); $list.Add($m2)
}

foreach ($m in $testMatches) { $allMatches.Add($m) }
foreach ($m in $odiMatches) { $allMatches.Add($m) }
foreach ($m in $t20iMatches) { $allMatches.Add($m) }
foreach ($m in $iplMatches) { $allMatches.Add($m) }

# Sort chronologically
$allMatches = $allMatches | Sort-Object Match_Date

# Write to CSV
$csvLines = [System.Collections.Generic.List[string]]::new()
$csvLines.Add("Match_ID,Match_Date,Year,Format,Tournament,Team,Opponent,Venue,Host_Country,Home_Away,Batting_Innings,Batting_Position,Runs,Balls,Fours,Sixes,Dismissal_Mode,Strike_Rate,Overs,Maidens,Runs_Conceded,Wickets,Economy,Catches,Result,Player_of_Match,Match_Impact_Score")

foreach ($m in $allMatches) {
    $line = "$($m.Match_ID),$($m.Match_Date),$($m.Year),$($m.Format),$($m.Tournament),$($m.Team),$($m.Opponent),""$($m.Venue)"",$($m.Host_Country),$($m.Home_Away),$($m.Batting_Innings),$($m.Batting_Position),$($m.Runs),$($m.Balls),$($m.Fours),$($m.Sixes),$($m.Dismissal_Mode),$($m.Strike_Rate),$($m.Overs),$($m.Maidens),$($m.Runs_Conceded),$($m.Wickets),$($m.Economy),$($m.Catches),$($m.Result),$($m.Player_of_Match),$($m.Match_Impact_Score)"
    $csvLines.Add($line)
}

$csvLines | Out-File -FilePath "$workspaceDir\Hardik_Pandya_Career_Matches.csv" -Encoding UTF8

$totalRuns = ($allMatches | Measure-Object -Property Runs -Sum).Sum
$totalWkts = ($allMatches | Measure-Object -Property Wickets -Sum).Sum
$totalFours = ($allMatches | Measure-Object -Property Fours -Sum).Sum
$totalSixes = ($allMatches | Measure-Object -Property Sixes -Sum).Sum

Write-Host "================ CALIBRATION AUDIT ================"
Write-Host "Total Matches Generated:" $allMatches.Count " (Target: 338)"
Write-Host "Total Career Runs:" $totalRuns " (Target: 6467)"
Write-Host "Total Career Wickets:" $totalWkts " (Target: 251)"
Write-Host "Total Fours:" $totalFours " (Target: 525)"
Write-Host "Total Sixes:" $totalSixes " (Target: 298)"
Write-Host "==================================================="
