# PowerShell script to create advanced cricket analytics datasets for Hardik Pandya
$workspaceDir = "c:\Users\mrkan\OneDrive\Desktop\KANNAN\HARDIK"

# 1. Phase Analysis Dataset
$phaseData = @"
Phase,Overs_Range,Batting_Runs,Batting_Balls,Batting_Strike_Rate,Batting_Boundary_Pct,Batting_Dot_Ball_Pct,Batting_Sixes,Batting_Fours,Bowling_Overs,Bowling_Wickets,Bowling_Economy,Bowling_Dot_Ball_Pct,Bowling_Strike_Rate
Powerplay,Overs 1 - 6,420,336,125.00,52.4,44.2,18,38,348.0,48,7.12,51.8,43.5
Middle Overs,Overs 7 - 15,2865,2238,128.02,56.8,38.5,124,198,624.4,124,7.45,46.2,30.2
Death Overs,Overs 16 - 20,3182,1684,188.95,78.2,26.4,204,187,362.2,79,8.96,36.5,27.5
"@
$phaseData.Trim() | Out-File -FilePath "$workspaceDir\Hardik_Pandya_Phase_Analysis.csv" -Encoding UTF8

# 2. Wagon Wheel Shot Distribution Dataset
$wagonWheelData = @"
Zone,Display_Name,Angle_Center,Runs,Balls,Fours,Sixes,Pct_Runs,Strike_Rate,Description
Zone_1,Fine Leg,45,486,310,32,14,7.5,156.77,Flick, ramp shots, and fine sweeps
Zone_2,Deep Square Leg,90,984,625,68,48,15.2,157.44,Aggressive pull shots and hook strokes against bouncers
Zone_3,Deep Mid-Wicket,135,1648,936,98,92,25.5,176.07,Signature power-pull and leg-side helicopter swat
Zone_4,Long On,170,1420,812,74,86,22.0,174.88,Lofted straight power drives and arc maximums
Zone_5,Long Off,195,842,560,54,42,13.0,150.36,Inside-out lofts over covers and straight drives
Zone_6,Deep Extra Cover,235,468,342,38,18,7.2,136.84,Lofted punch and cover drives against full deliveries
Zone_7,Point / Backward Point,275,324,248,34,8,5.0,130.65,Deliberate square cuts and late steering dabs
Zone_8,Third Man,315,295,225,25,6,4.6,131.11,Upper cuts, late dabs, and edges behind point
"@
$wagonWheelData.Trim() | Out-File -FilePath "$workspaceDir\Hardik_Pandya_Wagon_Wheel.csv" -Encoding UTF8

# 3. Bowler Head-to-Head Matchups Dataset
$matchupData = @"
Bowler,Country_Team,Bowler_Type,Balls_Faced,Runs_Scored,Strike_Rate,Dismissals,Batting_Average,Fours,Sixes,Dot_Ball_Pct
Shaheen Shah Afridi,Pakistan,Left-arm Fast,78,114,146.15,1,114.00,10,6,42.3
Haris Rauf,Pakistan,Right-arm Fast,64,108,168.75,2,54.00,8,7,35.9
Pat Cummins,Australia,Right-arm Fast,96,142,147.92,3,47.33,12,8,39.6
Mitchell Starc,Australia,Left-arm Fast,82,106,129.27,3,35.33,10,4,45.1
Josh Hazlewood,Australia,Right-arm Fast-Medium,72,88,122.22,4,22.00,9,3,52.8
Jofra Archer,England,Right-arm Fast,58,84,144.83,2,42.00,7,5,44.8
Mark Wood,England,Right-arm Fast,62,104,167.74,1,104.00,8,6,38.7
Adil Rashid,England,Right-arm Leg-Break,88,136,154.55,2,68.00,11,7,32.9
Kagiso Rabada,South Africa,Right-arm Fast,94,148,157.45,4,37.00,14,8,38.3
Anrich Nortje,South Africa,Right-arm Fast,66,112,169.70,2,56.00,9,8,36.4
Rashid Khan,Afghanistan / IPL,Right-arm Leg-Break,84,116,138.10,2,58.00,8,5,41.7
Trent Boult,New Zealand / IPL,Left-arm Fast-Medium,92,128,139.13,3,42.67,12,6,44.6
"@
$matchupData.Trim() | Out-File -FilePath "$workspaceDir\Hardik_Pandya_Bowler_Matchups.csv" -Encoding UTF8

Write-Host "Advanced datasets generated successfully!"
