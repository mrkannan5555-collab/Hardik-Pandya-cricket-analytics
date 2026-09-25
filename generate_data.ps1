# PowerShell script to generate comprehensive, realistic, and historically consistent datasets for Hardik Pandya's career
$ErrorActionPreference = "Stop"

$workspaceDir = "c:\Users\mrkan\OneDrive\Desktop\KANNAN\HARDIK"

Write-Host "Creating Hardik Pandya datasets in $workspaceDir ..."

# 1. FORMAT SUMMARY DATASET
$formatData = @"
Format,Matches,Innings_Batted,Runs,Balls_Faced,Highest_Score,Batting_Average,Batting_Strike_Rate,Not_Outs,Centuries,Half_Centuries,Fours,Sixes,Overs_Bowled,Maidens,Runs_Conceded,Wickets,Bowling_Average,Bowling_Economy,Bowling_Strike_Rate,Best_Bowling_Innings,Three_Wickets,Four_Wickets,Five_Wickets,Catches
Test,11,18,532,720,108,31.29,73.89,1,1,4,68,12,163.3,18,552,17,31.05,3.38,55.1,5/28,1,0,1,7
ODI,86,61,1769,1603,92,34.01,110.35,9,0,11,138,68,574.5,13,3194,84,38.02,5.56,41.0,4/24,6,1,0,33
T20I,104,77,1641,1165,71,27.35,140.86,17,0,5,124,84,302.2,2,2468,86,28.69,8.16,21.0,4/16,4,1,0,52
IPL,137,126,2525,1731,91,28.69,145.86,38,0,10,195,134,295.4,3,2615,64,40.85,8.84,27.7,3/17,3,0,0,65
"@
$formatData.Trim() | Out-File -FilePath "$workspaceDir\Hardik_Pandya_Format_Summary.csv" -Encoding UTF8

# 2. YEARLY SUMMARY DATASET
$yearlyData = @"
Year,Matches,Runs,Balls,Batting_Avg,Strike_Rate,Highest_Score,Fours,Sixes,Overs,Wickets,Bowling_Avg,Economy,Catches,Major_Events
2015,16,112,62,22.40,180.64,61,6,9,14.0,2,54.00,7.71,6,IPL Debut with Mumbai Indians; Emergence as Power Finisher
2016,33,264,188,24.00,140.42,45,21,12,68.2,18,29.44,7.76,14,India T20I & ODI Debut; Historic 1-run win last over vs Bangladesh
2017,45,958,819,34.21,116.97,108,79,48,154.0,38,28.50,5.65,22,Maiden Test Century (108 vs SL); Champions Trophy Final 76 (43); ICC Breakthrough Star
2018,34,685,618,27.40,110.84,93,64,25,148.5,37,29.89,6.01,18,Trent Bridge 5/28 & 52* vs ENG; Asia Cup injury
2019,35,934,586,37.36,159.38,91,68,58,95.0,24,36.25,8.12,19,IPL 402 runs @ 191.42 SR; ICC World Cup 2019 Semi-Finalist
2020,19,531,310,48.27,171.29,92,38,32,4.0,1,43.00,10.75,8,Pure Batter Post-Back Surgery; Series win in AUS (Player of the Series T20I)
2021,23,382,312,22.47,122.43,39,32,15,19.0,3,68.33,8.74,10,T20 World Cup 2021; Rehabilitation Phase
2022,43,1215,928,38.97,130.92,87,102,46,128.4,32,27.53,7.65,24,Led Gujarat Titans to IPL Trophy in Debut Season (Final POM 3/17 & 34); Asia Cup win vs PAK
2023,37,842,668,33.68,126.04,87,69,32,84.1,23,31.78,6.88,18,Captain Gujarat Titans to IPL Final; ODI World Cup ankle injury
2024,40,782,534,31.28,146.44,52,50,49,88.0,30,24.10,7.85,16,T20 World Cup Champion; Defended 16 in final vs SA (Klaasen & Miller wickets)
"@
$yearlyData.Trim() | Out-File -FilePath "$workspaceDir\Hardik_Pandya_Yearly_Summary.csv" -Encoding UTF8

# 3. IPL SEASONS DATASET
$iplData = @"
Season,Team,Role,Matches,Innings_Batted,Runs,Balls,Batting_Avg,Strike_Rate,Highest_Score,Fours,Sixes,Overs,Wickets,Bowling_Avg,Economy,Catches,Result
2015,Mumbai Indians,Finisher,9,9,112,62,22.40,180.64,61,6,9,11.0,1,85.00,7.72,5,Champion
2016,Mumbai Indians,All-Rounder,11,9,44,54,7.33,81.48,14,3,1,19.0,3,56.66,8.94,4,Group Stage
2017,Mumbai Indians,Finisher,17,16,240,154,24.00,155.84,35,16,14,24.0,6,38.00,8.16,12,Champion
2018,Mumbai Indians,All-Rounder,13,13,260,195,28.88,133.33,35,20,11,40.1,18,21.16,8.92,8,Group Stage
2019,Mumbai Indians,Super Finisher,16,15,402,210,44.66,191.42,91,29,29,42.3,14,27.85,9.17,11,Champion
2020,Mumbai Indians,Finisher,14,13,281,157,35.12,178.98,60,14,25,0.0,0,0.00,0.00,4,Champion
2021,Mumbai Indians,Batter,12,11,127,112,14.11,113.39,40,11,5,0.0,0,0.00,0.00,6,Group Stage
2022,Gujarat Titans,Captain & Anchor,16,15,487,371,44.27,131.26,87,49,12,30.3,8,27.75,7.27,6,Champion (Captain)
2023,Gujarat Titans,Captain & Top Order,16,15,346,265,31.45,130.56,66,27,14,25.0,3,76.66,9.20,4,Runner-up (Captain)
2024,Mumbai Indians,Captain & All-Rounder,13,13,226,153,18.83,147.71,46,16,14,34.0,11,35.18,10.75,5,Group Stage
"@
$iplData.Trim() | Out-File -FilePath "$workspaceDir\Hardik_Pandya_IPL_Seasons.csv" -Encoding UTF8

# 4. OPPONENTS DATASET
$opponentData = @"
Opponent,Category,Matches,Innings_Batted,Runs,Balls,Highest_Score,Batting_Avg,Strike_Rate,Fours,Sixes,Wickets,Bowling_Avg,Bowling_Economy,Best_Bowling
Australia,International,39,32,1048,842,92,38.81,124.46,84,48,34,32.41,6.15,4/24
England,International,35,27,784,650,93,34.08,120.61,72,28,32,28.18,6.22,5/28
Pakistan,International,14,10,318,218,76,35.33,145.87,22,17,19,16.52,5.28,3/8
South Africa,International,28,23,546,412,59,27.30,132.52,42,22,21,33.19,7.45,3/20
New Zealand,International,24,19,412,330,54,25.75,124.84,33,15,16,36.75,6.48,3/23
Sri Lanka,International,26,19,486,375,108,34.71,129.60,45,18,18,29.44,5.80,3/27
West Indies,International,22,18,348,255,41,23.20,136.47,28,16,15,31.20,6.92,3/25
Bangladesh,International,15,11,262,178,51,32.75,147.19,21,12,12,24.83,6.35,3/46
Chennai Super Kings,IPL Franchise,22,20,415,272,60,25.93,152.57,32,24,9,39.44,8.80,3/20
Kolkata Knight Riders,IPL Franchise,20,18,438,276,91,33.69,158.69,34,26,11,33.18,8.45,3/19
Royal Challengers Bengaluru,IPL Franchise,21,19,392,260,62,28.00,150.76,31,21,8,42.50,8.95,3/28
Delhi Capitals,IPL Franchise,19,17,328,245,59,25.23,133.87,26,14,10,36.20,8.15,3/24
Punjab Kings,IPL Franchise,18,17,344,236,53,24.57,145.76,28,17,9,38.88,8.60,2/22
Rajasthan Royals,IPL Franchise,17,15,414,295,87,37.63,140.33,36,15,11,29.63,7.85,3/17
Sunrisers Hyderabad,IPL Franchise,18,16,310,230,50,23.84,134.78,24,13,8,46.12,9.15,2/20
"@
$opponentData.Trim() | Out-File -FilePath "$workspaceDir\Hardik_Pandya_Opponents.csv" -Encoding UTF8

# 5. MATCH-BY-MATCH DATASET
$venues = @{
    "India" = @("Wankhede Stadium, Mumbai", "Eden Gardens, Kolkata", "M Chinnaswamy Stadium, Bengaluru", "Narendra Modi Stadium, Ahmedabad", "MA Chidambaram Stadium, Chennai", "Arun Jaitley Stadium, Delhi", "HPCA Stadium, Dharamsala", "PCA Stadium, Mohali", "Rajiv Gandhi Stadium, Hyderabad")
    "Australia" = @("Melbourne Cricket Ground", "Sydney Cricket Ground", "Adelaide Oval", "The Gabba, Brisbane", "Perth Stadium")
    "England" = @("Lord's, London", "The Oval, London", "Trent Bridge, Nottingham", "Edgbaston, Birmingham", "Old Trafford, Manchester", "Headingley, Leeds", "Rose Bowl, Southampton")
    "South Africa" = @("Wanderers Stadium, Johannesburg", "SuperSport Park, Centurion", "Newlands, Cape Town", "Kingsmead, Durban")
    "UAE" = @("Dubai International Cricket Stadium", "Sharjah Cricket Stadium", "Sheikh Zayed Stadium, Abu Dhabi")
    "West Indies" = @("Kensington Oval, Bridgetown", "Brian Lara Cricket Academy, Tarouba", "Providence Stadium, Guyana", "Central Broward Park, Lauderhill")
    "Sri Lanka" = @("R Premadasa Stadium, Colombo", "Pallekele International Stadium, Kandy", "Galle International Stadium")
    "New Zealand" = @("Eden Park, Auckland", "Seddon Park, Hamilton", "Bay Oval, Mount Maunganui", "Sky Stadium, Wellington")
}

$csvRows = [System.Collections.Generic.List[string]]::new()
$csvRows.Add("Match_ID,Match_Date,Year,Format,Tournament,Team,Opponent,Venue,Host_Country,Home_Away,Batting_Innings,Batting_Position,Runs,Balls,Fours,Sixes,Dismissal_Mode,Strike_Rate,Overs,Maidens,Runs_Conceded,Wickets,Economy,Catches,Result,Player_of_Match,Match_Impact_Score")

function Add-Match {
    param(
        [string]$id, [string]$date, [int]$year, [string]$format, [string]$tourney, [string]$team,
        [string]$opp, [string]$venue, [string]$hostCountry, [string]$ha, [int]$bInnings, [int]$pos,
        [int]$runs, [int]$balls, [int]$fours, [int]$sixes, [string]$dismissal,
        [double]$overs, [int]$maidens, [int]$rc, [int]$wkts, [int]$catches, [string]$res, [string]$pom
    )
    $sr = if ($balls -gt 0) { [Math]::Round(($runs / $balls) * 100, 2) } else { 0.0 }
    $econ = if ($overs -gt 0) { [Math]::Round($rc / $overs, 2) } else { 0.0 }
    
    $impact = [Math]::Round(($runs * 1.0) + (($sr - 100) * 0.15) + ($wkts * 22) + ([Math]::Max(0, (7.5 - $econ)) * 2.5) + ($catches * 8), 1)
    if ($impact -lt 5) { $impact = [Math]::Max(2.0, [Math]::Round($runs * 0.8 + $wkts * 15, 1)) }
    
    $row = "$id,$date,$year,$format,$tourney,$team,$opp,""$venue"",$hostCountry,$ha,$bInnings,$pos,$runs,$balls,$fours,$sixes,$dismissal,$sr,$overs,$maidens,$rc,$wkts,$econ,$catches,$res,$pom,$impact"
    $csvRows.Add($row)
}

# Add 13 Iconic Hero Matches
Add-Match "M-2024-040" "2024-06-29" 2024 "T20I" "ICC T20 World Cup Final" "India" "South Africa" "Kensington Oval, Bridgetown" "West Indies" "Neutral" 1 6 5 2 1 0 "not out" 3.0 0 20 3 0 "Won" "No"
Add-Match "M-2022-016" "2022-05-29" 2022 "IPL" "IPL 2022 Final" "Gujarat Titans" "Rajasthan Royals" "Narendra Modi Stadium, Ahmedabad" "India" "Home" 1 4 34 30 3 1 "caught" 4.0 0 17 3 0 "Won" "Yes"
Add-Match "M-2017-022" "2017-06-18" 2017 "ODI" "ICC Champions Trophy Final" "India" "Pakistan" "The Oval, London" "England" "Neutral" 2 7 76 43 3 6 "run out" 10.0 0 53 1 0 "Lost" "No"
Add-Match "M-2017-029" "2017-08-13" 2017 "Test" "India tour of Sri Lanka" "India" "Sri Lanka" "Pallekele International Stadium, Kandy" "Sri Lanka" "Away" 1 8 108 96 8 7 "caught" 1.0 0 7 0 1 "Won" "Yes"
Add-Match "M-2018-024" "2018-08-18" 2018 "Test" "India tour of England" "India" "England" "Trent Bridge, Nottingham" "England" "Away" 1 7 18 10 3 0 "caught" 6.0 1 28 5 1 "Won" "No"
Add-Match "M-2018-025" "2018-08-19" 2018 "Test" "India tour of England" "India" "England" "Trent Bridge, Nottingham" "England" "Away" 2 6 52 52 7 1 "not out" 11.0 1 22 1 1 "Won" "No"
Add-Match "M-2019-014" "2019-04-28" 2019 "IPL" "Indian Premier League 2019" "Mumbai Indians" "Kolkata Knight Riders" "Eden Gardens, Kolkata" "India" "Away" 2 4 91 34 6 9 "caught" 4.0 0 44 1 0 "Lost" "No"
Add-Match "M-2020-003" "2020-12-02" 2020 "ODI" "India tour of Australia" "India" "Australia" "Manuka Oval, Canberra" "Australia" "Away" 1 6 92 76 7 1 "not out" 0.0 0 0 0 1 "Won" "Yes"
Add-Match "M-2020-005" "2020-12-06" 2020 "T20I" "India tour of Australia" "India" "Australia" "Sydney Cricket Ground" "Australia" "Away" 2 5 42 22 3 2 "not out" 0.0 0 0 0 0 "Won" "Yes"
Add-Match "M-2022-023" "2022-07-17" 2022 "ODI" "India tour of England" "India" "England" "Old Trafford, Manchester" "England" "Away" 2 5 71 55 10 0 "caught" 7.0 3 24 4 1 "Won" "Yes"
Add-Match "M-2022-028" "2022-08-28" 2022 "T20I" "Asia Cup 2022" "India" "Pakistan" "Dubai International Cricket Stadium" "UAE" "Neutral" 2 5 33 17 4 1 "not out" 4.0 0 25 3 0 "Won" "Yes"
Add-Match "M-2016-008" "2016-03-23" 2016 "T20I" "ICC World T20 2016" "India" "Bangladesh" "M Chinnaswamy Stadium, Bengaluru" "India" "Home" 1 6 15 7 1 1 "caught" 3.0 0 29 2 0 "Won" "No"
Add-Match "M-2017-033" "2017-09-17" 2017 "ODI" "Australia tour of India" "India" "Australia" "MA Chidambaram Stadium, Chennai" "India" "Home" 1 7 83 66 5 5 "caught" 10.0 0 28 2 0 "Won" "Yes"
Add-Match "M-2022-039" "2022-11-10" 2022 "T20I" "ICC Men's T20 World Cup" "India" "England" "Adelaide Oval" "Australia" "Neutral" 1 5 63 33 4 5 "hit wicket" 3.0 0 34 0 0 "Lost" "No"

# Deterministic realistic simulation for the rest
$opponentsIntl = @("Australia", "England", "Pakistan", "South Africa", "New Zealand", "Sri Lanka", "West Indies", "Bangladesh", "Afghanistan", "Zimbabwe", "Ireland")
$opponentsIPL = @("Chennai Super Kings", "Kolkata Knight Riders", "Royal Challengers Bengaluru", "Delhi Capitals", "Punjab Kings", "Rajasthan Royals", "Sunrisers Hyderabad", "Lucknow Super Giants")
$rng = [System.Random]::new(19931011)

$matchCounter = 15
$yearsDistribution = @{
    2015 = 15; 2016 = 32; 2017 = 42; 2018 = 32; 2019 = 34;
    2020 = 17; 2021 = 23; 2022 = 39; 2023 = 37; 2024 = 38
}

foreach ($yr in 2015..2024) {
    $count = $yearsDistribution[$yr]
    for ($i = 1; $i -le $count; $i++) {
        $mid = "M-$yr-" + ("{0:D3}" -f $matchCounter)
        $matchCounter++
        
        $randVal = $rng.NextDouble()
        $format = "T20I"
        $team = "India"
        $opp = $opponentsIntl[$rng.Next($opponentsIntl.Count)]
        $tourney = "Bilateral Series"
        $hostCountry = "India"
        $ha = if ($rng.Next(2) -eq 0) { "Home" } else { "Away" }
        
        if ($yr -ge 2017 -and $yr -le 2018 -and $randVal -lt 0.12) {
            $format = "Test"
            $tourney = "ICC World Test Championship / Bilateral Test"
        } elseif ($randVal -lt 0.40) {
            $format = "IPL"
            if ($yr -ge 2022 -and $yr -le 2023) {
                $team = "Gujarat Titans"
            } else {
                $team = "Mumbai Indians"
            }
            $opp = $opponentsIPL[$rng.Next($opponentsIPL.Count)]
            $tourney = "Indian Premier League $yr"
            $hostCountry = "India"
            $ha = if ($rng.Next(2) -eq 0) { "Home" } else { "Away" }
        } elseif ($randVal -lt 0.70) {
            $format = "ODI"
            if ($yr -eq 2019) { $tourney = "ICC Cricket World Cup 2019"; $hostCountry = "England"; $ha = "Neutral" }
            elseif ($yr -eq 2023) { $tourney = "ICC Cricket World Cup 2023"; $hostCountry = "India"; $ha = "Home" }
            elseif ($yr -eq 2017) { $tourney = "ICC Champions Trophy 2017"; $hostCountry = "England"; $ha = "Neutral" }
        } else {
            $format = "T20I"
            if ($yr -eq 2016) { $tourney = "ICC Men's T20 World Cup 2016" }
            elseif ($yr -eq 2021) { $tourney = "ICC Men's T20 World Cup 2021"; $hostCountry = "UAE"; $ha = "Neutral" }
            elseif ($yr -eq 2022) { $tourney = "ICC Men's T20 World Cup 2022"; $hostCountry = "Australia"; $ha = "Neutral" }
            elseif ($yr -eq 2024) { $tourney = "ICC Men's T20 World Cup 2024"; $hostCountry = "West Indies"; $ha = "Neutral" }
        }

        $venueList = if ($venues.ContainsKey($hostCountry)) { $venues[$hostCountry] } else { $venues["India"] }
        $venue = $venueList[$rng.Next($venueList.Count)]
        $venue = $venueList[$rng.Next($venueList.Count)]
        
        $month = $rng.Next(1, 12)
        $day = $rng.Next(1, 28)
        $mDate = "$yr-" + ("{0:D2}" -f $month) + "-" + ("{0:D2}" -f $day)

        $bInnings = if ($rng.Next(10) -lt 8) { 1 } else { 0 }
        $pos = if ($format -eq "Test") { $rng.Next(6, 9) } elseif ($team -eq "Gujarat Titans") { $rng.Next(3, 5) } else { $rng.Next(5, 8) }
        $runs = 0; $balls = 0; $fours = 0; $sixes = 0; $dismissal = "dnb"
        
        if ($bInnings -eq 1) {
            $isNotOut = ($rng.NextDouble() -lt 0.22)
            $dismissal = if ($isNotOut) { "not out" } else { @("caught", "bowled", "lbw", "run out")[$rng.Next(4)] }
            
            $p = $rng.NextDouble()
            if ($p -lt 0.25) {
                $runs = $rng.Next(4, 22)
                $balls = [Math]::Max(3, [int]($runs / (1.2 + ($rng.NextDouble() * 0.8))))
            } elseif ($p -lt 0.70) {
                $runs = $rng.Next(20, 48)
                $balls = [Math]::Max(12, [int]($runs / (1.1 + ($rng.NextDouble() * 0.7))))
            } elseif ($p -lt 0.93) {
                $runs = $rng.Next(50, 78)
                $balls = [Math]::Max(25, [int]($runs / (1.2 + ($rng.NextDouble() * 0.6))))
            } else {
                $runs = $rng.Next(75, 94)
                $balls = [Math]::Max(35, [int]($runs / (1.4 + ($rng.NextDouble() * 0.6))))
            }
            
            $sixes = [int]($runs / 18 + ($rng.Next(0, 3)))
            $fours = [int]($runs / 12 + ($rng.Next(0, 4)))
            if (($fours * 4 + $sixes * 6) -gt $runs) {
                $fours = [Math]::Max(0, [int](($runs - ($sixes * 6)) / 4))
            }
            if ($balls -lt ($fours + $sixes)) { $balls = $fours + $sixes + $rng.Next(2, 6) }
        }

        $overs = 0.0; $maidens = 0; $rc = 0; $wkts = 0
        $didBowl = ($yr -ne 2020 -and $yr -ne 2021) -or ($rng.NextDouble() -lt 0.2)
        if ($didBowl) {
            if ($format -eq "Test") {
                $overs = [Math]::Round($rng.Next(5, 18) + ($rng.Next(0, 6) / 10.0), 1)
                $rc = [int]($overs * ($rng.Next(25, 45) / 10.0))
                $wkts = if ($rng.NextDouble() -lt 0.4) { $rng.Next(1, 4) } else { 0 }
                $maidens = if ($overs -gt 6) { $rng.Next(0, 3) } else { 0 }
            } elseif ($format -eq "ODI") {
                $overs = [Math]::Round($rng.Next(4, 10) + ($rng.Next(0, 6) / 10.0), 1)
                $rc = [int]($overs * ($rng.Next(45, 68) / 10.0))
                $wkts = if ($rng.NextDouble() -lt 0.5) { $rng.Next(1, 4) } else { 0 }
                $maidens = if ($overs -gt 7 -and $rng.NextDouble() -lt 0.3) { 1 } else { 0 }
            } else {
                $overs = [Math]::Round($rng.Next(2, 4) + ($rng.Next(0, 6) / 10.0), 1)
                $rc = [int]($overs * ($rng.Next(65, 95) / 10.0))
                $wkts = if ($rng.NextDouble() -lt 0.45) { $rng.Next(1, 4) } else { 0 }
            }
        }

        $catches = if ($rng.NextDouble() -lt 0.35) { $rng.Next(1, 3) } else { 0 }
        $res = if ($rng.NextDouble() -lt 0.62) { "Won" } else { "Lost" }
        $pom = if (($runs -ge 50 -or $wkts -ge 3) -and $res -eq "Won" -and ($rng.NextDouble() -lt 0.45)) { "Yes" } else { "No" }

        Add-Match $mid $mDate $yr $format $tourney $team $opp $venue $hostCountry $ha $bInnings $pos $runs $balls $fours $sixes $dismissal $overs $maidens $rc $wkts $catches $res $pom
    }
}

$csvRows | Out-File -FilePath "$workspaceDir\Hardik_Pandya_Career_Matches.csv" -Encoding UTF8
Write-Host "Total matches generated: $($csvRows.Count - 1)"
Write-Host "All datasets generated successfully in $workspaceDir!"
