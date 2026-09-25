# Hardik Pandya — Career Performance Analytics
## Power BI Professional Sports Dashboard Implementation & Architecture Guide

> **Theme**: Professional Dark Sports Theme (Deep Navy `#070B14`, Card Surface `#0F172A`, Electric Cyan `#00D2FF`, Aggressive Orange `#FF6B00`, Emerald Green `#10B981`)  
> **Standard**: ESPN Cricinfo / ICC Analytics / CricViz Broadcast Grade  
> **Layout**: 16:9 Aspect Ratio (1920 × 1080 px or 1280 × 720 px)  
> **Data Range**: 2015 – 2024 (Test, ODI, T20I, IPL)

---

## 1. Project Files Directory

| File Name | Purpose |
| :--- | :--- |
| `index.html` | **Interactive Live Dashboard**: Full web application with real-time Chart.js visuals, filters, and drill-down modal |
| `styles.css` | Glassmorphism, glow styling, dark theme, and 16:9 responsive layout |
| `app.js` | Interactive calculation engine, filter logic, and dynamic KPI updating |
| `hardik_data.js` | Embedded JSON dataset for local zero-CORS browser execution |
| `Hardik_Pandya_Career_Matches.csv` | Granular match-by-match fact table (320+ matches) |
| `Hardik_Pandya_Yearly_Summary.csv` | Annual aggregated metrics (2015–2024) |
| `Hardik_Pandya_Format_Summary.csv` | Test, ODI, T20I, IPL career aggregates |
| `Hardik_Pandya_IPL_Seasons.csv` | IPL season-by-season records (MI vs GT) |
| `Hardik_Pandya_Opponents.csv` | Head-to-head records against international teams and IPL franchises |
| `Hardik_Pandya_Dark_Sports_Theme.json` | Power BI custom theme palette, typography, and card styles |
| `Hardik_Pandya_DAX_Measures.dax` | Production DAX measures library (40+ measures) |

---

## 2. Power BI Setup & Data Modeling (Star Schema)

### Step 1: Import Datasets into Power BI Desktop
1. Open **Power BI Desktop**.
2. Click **Get Data** > **Text/CSV**.
3. Import the primary table: `Hardik_Pandya_Career_Matches.csv` (Rename table to `Fact_Matches`).
4. Ensure data types are set correctly:
   - `Match_Date`: Date (`yyyy-mm-dd`)
   - `Year`: Whole Number (`Int64`)
   - `Runs`, `Balls`, `Fours`, `Sixes`: Whole Number
   - `Strike_Rate`, `Overs`, `Runs_Conceded`, `Economy`: Decimal Number
   - `Wickets`, `Catches`, `Maidens`: Whole Number
   - `Match_Impact_Score`: Decimal Number

### Step 2: Apply the Custom Theme JSON
1. Go to the **View** ribbon in Power BI.
2. In the **Themes** dropdown, click **Browse for themes**.
3. Select `Hardik_Pandya_Dark_Sports_Theme.json`.
4. The canvas, font styles (Segoe UI Bold), borders, and dark palettes will automatically apply across all visuals.

### Step 3: Create the Date Dimension (DAX)
Under **Modeling** > **New Table**, paste:
```dax
Dim_Date = 
VAR _MinYear = 2015
VAR _MaxYear = 2024
RETURN
ADDCOLUMNS(
    CALENDAR(DATE(_MinYear, 1, 1), DATE(_MaxYear, 12, 31)),
    "Year", YEAR([Date]),
    "Year Month", FORMAT([Date], "yyyy-mm"),
    "Month Name", FORMAT([Date], "mmm"),
    "Month Number", MONTH([Date])
)
```
Connect `Fact_Matches[Match_Date]` (Many) $\rightarrow$ `Dim_Date[Date]` (One).

---

## 3. Key DAX Measures (Highlights from `Hardik_Pandya_DAX_Measures.dax`)

Create a dedicated measure table called `_Measures` and add:

```dax
// 1. Total Career Matches
Total Matches = COUNTROWS('Fact_Matches')

// 2. Batting Average
Batting Average = 
VAR _Dismissals = CALCULATE(
    COUNTROWS('Fact_Matches'),
    'Fact_Matches'[Batting_Innings] = 1,
    'Fact_Matches'[Dismissal_Mode] <> "not out",
    'Fact_Matches'[Dismissal_Mode] <> "dnb"
)
VAR _Runs = SUM('Fact_Matches'[Runs])
RETURN
IF(_Dismissals = 0, BLANK(), ROUND(DIVIDE(_Runs, _Dismissals), 2))

// 3. Batting Strike Rate
Batting Strike Rate = 
VAR _Balls = SUM('Fact_Matches'[Balls])
VAR _Runs = SUM('Fact_Matches'[Runs])
RETURN
IF(_Balls = 0, 0.0, ROUND(DIVIDE(_Runs, _Balls) * 100, 2))

// 4. Bowling Economy Rate
Bowling Economy Rate = 
VAR _Overs = SUM('Fact_Matches'[Overs])
VAR _RunsConceded = SUM('Fact_Matches'[Runs_Conceded])
RETURN
IF(_Overs = 0, BLANK(), ROUND(DIVIDE(_RunsConceded, _Overs), 2))

// 5. Best Bowling Figures
Best Bowling Figures = 
VAR _MaxWkts = CALCULATE(MAX('Fact_Matches'[Wickets]), ALLSELECTED('Fact_Matches'))
VAR _MinRuns = CALCULATE(
    MIN('Fact_Matches'[Runs_Conceded]),
    'Fact_Matches'[Wickets] = _MaxWkts,
    ALLSELECTED('Fact_Matches')
)
RETURN
FORMAT(_MaxWkts, "0") & "/" & FORMAT(_MinRuns, "0")

// 6. Dynamic Header Title
Dynamic Header Title = 
VAR _Format = SELECTEDVALUE('Fact_Matches'[Format], "All Formats")
VAR _MinYear = MIN('Fact_Matches'[Year])
VAR _MaxYear = MAX('Fact_Matches'[Year])
RETURN
"HARDIK PANDYA • " & UPPER(_Format) & " CAREER PERFORMANCE (" & _MinYear & " - " & _MaxYear & ")"
```

---

## 4. Multi-Page Dashboard Architecture

### Page 01 — Career Overview
* **Header**: "HARDIK PANDYA • Career Performance Analytics" with Indian jersey #33 cutout and glow visual.
* **KPI Row (9 Cards)**: Matches, Innings, Runs, Wickets, Batting Avg, Strike Rate, Best Score, Sixes, Economy.
* **Visual 1 (Top Left - Line Chart)**: `Runs by Year`  
  - *X-axis*: `Dim_Date[Year]`
  - *Y-axis*: `[Total Runs]`
  - *Color*: Neon Cyan (`#00D2FF`) with area gradient shading.
* **Visual 2 (Top Right - Combo Chart)**: `Wickets & Economy by Year`  
  - *X-axis*: `Dim_Date[Year]`
  - *Column Y-axis*: `[Total Wickets]` (Fiery Orange `#FF6B00`)
  - *Line Y-axis*: `[Bowling Economy Rate]` (Pitch Emerald `#10B981`)
* **Visual 3 (Bottom Left - Donut Chart)**: `Format Share Distribution`  
  - *Legend*: `Fact_Matches[Format]`
  - *Values*: `[Total Runs]`
* **Visual 4 (Bottom Right - Radar Chart or Card Cluster)**: `All-Rounder Impact Matrix`  
  - Benchmarks Hardik's metrics across Boundary %, Strike Rate in death overs, and Economy in wins.

---

### Page 02 — Batting Analytics
* **Visual 1 (Clustered Column Chart)**: `Batting Performance by Format`  
  - *X-axis*: `Fact_Matches[Format]`
  - *Y-axis*: `[Batting Average]` and `[Batting Strike Rate]`
* **Visual 2 (Scatter Chart)**: `Runs vs Strike Rate (Innings Impact)`  
  - *X-axis*: `Fact_Matches[Runs]`
  - *Y-axis*: `Fact_Matches[Strike_Rate]`
  - *Details*: `Fact_Matches[Match_ID]`
  - *Legend*: `Fact_Matches[Format]`
  - *Quadrant Lines*: Constant line at $X = 30$ and $Y = 140$ to segment "Super-Finisher Knocks".
* **Visual 3 (Stacked Column Chart)**: `Sixes & Fours by Year`  
  - *X-axis*: `Fact_Matches[Year]`
  - *Values*: `[Total Sixes]` (Orange) and `[Total Fours]` (Sky Blue)
* **Visual 4 (Donut Chart)**: `Dismissal Modes Breakdown`  
  - *Legend*: `Fact_Matches[Dismissal_Mode]`
  - *Values*: `[Total Matches]`

---

### Page 03 — Bowling Analytics
* **Visual 1 (Clustered Column & Line)**: `Bowling Performance by Format`  
  - *X-axis*: `Fact_Matches[Format]`
  - *Columns*: `[Total Wickets]`
  - *Line*: `[Bowling Economy Rate]`
* **Visual 2 (Line Chart)**: `Annual Economy Rate Trend`  
  - Shows how Hardik gained tighter line and length control from 2016 to 2024.
* **Visual 3 (Horizontal Bar Chart)**: `Performance Against Opponents`  
  - *Y-axis*: `Fact_Matches[Opponent]` (Filtered to Top 10)
  - *X-axis*: `[Total Wickets]` & `[Total Runs]`

---

### Page 04 — IPL Analytics
* **Visual 1 (Combo Chart)**: `IPL Season-wise Runs & Strike Rate (2015–2024)`  
  - Highlights his peak 2019 season (402 runs @ 191.42 SR) and 2022 championship season (487 runs).
* **Visual 2 (Combo Chart)**: `IPL Wickets & Economy Rate by Season`
* **Visual 3 (Multi-Row Card / Comparison Matrix)**: `Mumbai Indians vs Gujarat Titans`  
  - Compares Hardik as a lower-order finisher (MI) vs top-order anchor & captain (GT).

---

### Page 05 — Match-by-Match Analysis (Drill-Through Target)
* **Search Slicer**: Text search by Opponent or Venue.
* **Detailed Grid Table**:
  - Columns: `Match_Date`, `Format`, `Opponent`, `Tournament`, `Runs`, `Balls`, `Strike_Rate`, `Wickets`, `Runs_Conceded`, `Result`, `Player_of_Match`, `Match_Impact_Score`.
  - Conditional Formatting:
    - `Result`: Green pill for "Won", Red pill for "Lost".
    - `Runs`: Data bar with cyan gradient for scores $\ge 50$.
    - `Player_of_Match`: Gold highlight badge.

---

### Page 06 — Advanced Insights (Match Phases, Wagon Wheel & Matchups)
* **Visual 1 (Multi-Row Card or Clustered Bar)**: `Match Phase Strike Rates & Economy`
  - *Source Table*: `Hardik_Pandya_Phase_Analysis.csv`
  - *Categories*: Powerplay (Overs 1–6), Middle Overs (Overs 7–15), Death Overs (Overs 16–20)
  - *Metrics*: `Batting_Strike_Rate` ($125 \rightarrow 128 \rightarrow 188.95$), `Batting_Boundary_Pct` ($52.4\% \rightarrow 56.8\% \rightarrow 78.2\%$), and `Bowling_Economy` ($7.12 \rightarrow 7.45 \rightarrow 8.96$).
* **Visual 2 (Synoptic Panel / Polar Chart / Donut)**: `Wagon Wheel Shot Distribution (360°)`
  - *Source Table*: `Hardik_Pandya_Wagon_Wheel.csv`
  - *Category*: `Display_Name` (Fine Leg, Deep Mid-Wicket, Long On, Point, etc.)
  - *Values*: `Runs` & `Percentage_Runs`
  - Highlights the **47.5% Cow Corner Arc dominance** (Mid-Wicket + Long On = 3,068 runs, 178 sixes).
* **Visual 3 (Matrix / Card Grid)**: `Head-to-Head Bowler Matchup Matrix`
  - *Source Table*: `Hardik_Pandya_Bowler_Matchups.csv`
  - *Rows*: `Bowler` (Shaheen Afridi, Haris Rauf, Pat Cummins, Mitchell Starc, Mark Wood, etc.)
  - *Values*: `Runs_Scored`, `Balls_Faced`, `Strike_Rate`, `Dismissals`, `Batting_Average`.

---

## 5. Advanced Power BI Features Setup

### A. Bookmark Navigation
1. Create 5 transparent shape buttons corresponding to Pages 01–05.
2. In the **Selection** and **Bookmarks** panes, create 5 bookmarks (`View_Overview`, `View_Batting`, `View_Bowling`, `View_IPL`, `View_Matches`).
3. Assign each button an Action $\rightarrow$ **Bookmark** $\rightarrow$ respective page.

### B. Dynamic Visual Titles
1. Select any visual > **Format visual** > **General** > **Title**.
2. Click the Conditional Formatting button (**fx**).
3. Set **Format style** = *Field value*, and choose `[Dynamic Header Title]` or `[Dynamic Runs Visual Title]`.

### C. Drill-Through Configuration
1. On **Page 05 — Match-by-Match**, go to **Page settings** > **Drill-through**.
2. Drag `Fact_Matches[Opponent]` and `Fact_Matches[Year]` into the Drill-through fields bucket.
3. Users can right-click any bar on Page 01, 02, or 03 and select **Drill through $\rightarrow$ Match-by-Match** to inspect the exact matches.

### D. Tooltip Page Design
1. Create a small page (e.g. 320 × 240 px) named `TT_Player_Insight`.
2. Set **Page type** = *Tooltip*.
3. Add a mini card with `[Highest Score]`, `[Best Bowling Figures]`, and `[Centuries (100s)]`.
4. Link this tooltip to the main visuals on Page 01.

---

## 6. Cricket Analytical Storytelling

1. **How has Hardik's batting performance changed over the years?**
   - **2015–2018**: Raw pinch-hitter and late-innings aggressor at No. 7.
   - **2019–2020**: Peak hitting lethality (159–191 SR), mastering the helicopter and deep-crease swat.
   - **2022–2024**: Tactical maturity; assumed No. 3/4 responsibility at Gujarat Titans, stabilizing middle-overs before accelerating.

2. **Which format produces his strongest batting numbers?**
   - **ODI**: Highest consistency (34.01 average, 110.35 SR), providing stability with rare counter-attacking depth.
   - **IPL/T20I**: Highest impact (140–146 SR), finishing matches from impossible run-rate equations.

3. **How has his bowling contribution changed?**
   - Early career relied on raw pace (138–142 km/h) but leaked runs (8+ econ).
   - Post-back rehabilitation (2022 onwards), developed heavy cross-seam bouncers, wobble seam, and intelligent pace-off deliveries, becoming India's designated death-over closer in the 2024 T20 World Cup final.

4. **Against which opponents has he performed best?**
   - **Australia**: 1,048+ runs @ 38.81 Avg, 124.46 SR, and 34 wickets.
   - **Pakistan**: Highest bowling clutch factor (19 wickets @ 16.52 Avg, 5.28 Econ, with 3/8 and 3/25 in marquee thrillers).
   - **England**: 784 runs and career-best Test figures (5/28 at Trent Bridge) and ODI 4/24 at Old Trafford.
