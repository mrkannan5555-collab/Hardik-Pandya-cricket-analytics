/**
 * Hardik Pandya Career Performance Analytics - Interactive Engine
 * Dark Sports Theme - ESPN Cricinfo & ICC Analytics Standard
 */

// Global state
let currentFilters = {
  format: 'All',
  year: 'All',
  team: 'All',
  opponent: 'All',
  venue: 'All',
  searchQuery: ''
};

let activePage = 'page-overview';
let charts = {};

document.addEventListener('DOMContentLoaded', () => {
  initSlicers();
  bindEvents();
  applyFiltersAndRender();
});

// Initialize slicer dropdowns from data
function initSlicers() {
  const matches = window.HARDIK_DATA?.matches || [];
  if (!matches.length) return;

  const years = [...new Set(matches.map(m => m.Year))].sort((a, b) => b - a);
  const teams = [...new Set(matches.map(m => m.Team))].sort();
  const opponents = [...new Set(matches.map(m => m.Opponent))].sort();

  populateDropdown('slicer-year', years);
  populateDropdown('slicer-team', teams);
  populateDropdown('slicer-opponent', opponents);
}

function populateDropdown(id, items) {
  const select = document.getElementById(id);
  if (!select) return;
  items.forEach(item => {
    const opt = document.createElement('option');
    opt.value = item;
    opt.textContent = item;
    select.appendChild(opt);
  });
}

function bindEvents() {
  // Slicers
  ['slicer-format', 'slicer-year', 'slicer-team', 'slicer-opponent', 'slicer-venue'].forEach(id => {
    const el = document.getElementById(id);
    if (el) {
      el.addEventListener('change', () => {
        const filterKey = id.replace('slicer-', '');
        currentFilters[filterKey] = el.value;
        applyFiltersAndRender();
      });
    }
  });

  // Reset Filters
  const resetBtn = document.getElementById('btn-reset-filters');
  if (resetBtn) {
    resetBtn.addEventListener('click', resetAllFilters);
  }

  // Navigation Tabs
  document.querySelectorAll('.nav-tab-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('.nav-tab-btn').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      const targetPage = btn.getAttribute('data-target');
      switchPage(targetPage);
    });
  });

  // Table Search
  const searchInput = document.getElementById('table-search-input');
  if (searchInput) {
    searchInput.addEventListener('input', (e) => {
      currentFilters.searchQuery = e.target.value.toLowerCase().trim();
      renderMatchTable();
    });
  }

  // Modal Close
  const modalClose = document.getElementById('modal-close-btn');
  const modalOverlay = document.getElementById('drill-modal-overlay');
  if (modalClose && modalOverlay) {
    modalClose.addEventListener('click', () => modalOverlay.classList.remove('active'));
    modalOverlay.addEventListener('click', (e) => {
      if (e.target === modalOverlay) modalOverlay.classList.remove('active');
    });
  }
}

function resetAllFilters() {
  currentFilters = {
    format: 'All',
    year: 'All',
    team: 'All',
    opponent: 'All',
    venue: 'All',
    searchQuery: ''
  };

  document.getElementById('slicer-format').value = 'All';
  document.getElementById('slicer-year').value = 'All';
  document.getElementById('slicer-team').value = 'All';
  document.getElementById('slicer-opponent').value = 'All';
  document.getElementById('slicer-venue').value = 'All';
  const sInput = document.getElementById('table-search-input');
  if (sInput) sInput.value = '';

  applyFiltersAndRender();
}

function switchPage(pageId) {
  activePage = pageId;
  document.querySelectorAll('.page-container').forEach(p => p.classList.remove('active'));
  const target = document.getElementById(pageId);
  if (target) {
    target.classList.add('active');
  }
  renderActivePageCharts();
}

// Filter dataset based on current slicers
function getFilteredMatches() {
  const matches = window.HARDIK_DATA?.matches || [];
  return matches.filter(m => {
    if (currentFilters.format !== 'All' && m.Format !== currentFilters.format) return false;
    if (currentFilters.year !== 'All' && m.Year !== currentFilters.year) return false;
    if (currentFilters.team !== 'All' && m.Team !== currentFilters.team) return false;
    if (currentFilters.opponent !== 'All' && m.Opponent !== currentFilters.opponent) return false;
    if (currentFilters.venue !== 'All' && m.Home_Away !== currentFilters.venue) return false;
    return true;
  });
}

function applyFiltersAndRender() {
  updateDynamicTitles();
  updateKPIs();
  renderActivePageCharts();
  renderMatchTable();
}

function updateDynamicTitles() {
  const formatText = currentFilters.format === 'All' ? 'Career (All Formats)' : currentFilters.format;
  const yearText = currentFilters.year === 'All' ? '2015 – 2024' : currentFilters.year;
  const oppText = currentFilters.opponent === 'All' ? 'All Opponents' : 'vs ' + currentFilters.opponent;
  
  const titleEl = document.getElementById('dynamic-header-status');
  if (titleEl) {
    titleEl.textContent = `${formatText} • ${yearText} • ${oppText}`;
  }
}

function updateKPIs() {
  const data = getFilteredMatches();
  
  const totalMatches = data.length;
  let inningsBatted = 0;
  let totalRuns = 0;
  let totalBalls = 0;
  let totalSixes = 0;
  let totalFours = 0;
  let dismissals = 0;
  let highestScore = 0;

  let totalWickets = 0;
  let totalOvers = 0;
  let totalRunsConceded = 0;
  let bestWkts = 0;
  let bestRunsConceded = 999;

  data.forEach(m => {
    const runs = parseInt(m.Runs) || 0;
    const balls = parseInt(m.Balls) || 0;
    const sixes = parseInt(m.Sixes) || 0;
    const fours = parseInt(m.Fours) || 0;
    const overs = parseFloat(m.Overs) || 0;
    const wkts = parseInt(m.Wickets) || 0;
    const rc = parseInt(m.Runs_Conceded) || 0;
    const dismissal = (m.Dismissal_Mode || '').toLowerCase();

    if (m.Batting_Innings === '1' || runs > 0 || balls > 0) {
      inningsBatted++;
      totalRuns += runs;
      totalBalls += balls;
      totalSixes += sixes;
      totalFours += fours;
      if (runs > highestScore) highestScore = runs;
      if (dismissal !== 'not out' && dismissal !== 'dnb' && dismissal !== 'retired hurt') {
        dismissals++;
      }
    }

    if (overs > 0) {
      totalOvers += overs;
      totalWickets += wkts;
      totalRunsConceded += rc;
      if (wkts > bestWkts || (wkts === bestWkts && rc < bestRunsConceded && wkts > 0)) {
        bestWkts = wkts;
        bestRunsConceded = rc;
      }
    }
  });

  const battingAvg = dismissals > 0 ? (totalRuns / dismissals).toFixed(2) : (totalRuns > 0 ? totalRuns.toFixed(2) : '—');
  const strikeRate = totalBalls > 0 ? ((totalRuns / totalBalls) * 100).toFixed(2) : '—';
  const economy = totalOvers > 0 ? (totalRunsConceded / totalOvers).toFixed(2) : '—';
  const bestBowlingStr = bestWkts > 0 ? `${bestWkts}/${bestRunsConceded}` : '—';

  // Animate / Set Values
  setKPIValue('kpi-matches', totalMatches);
  setKPIValue('kpi-innings', inningsBatted);
  setKPIValue('kpi-runs', totalRuns.toLocaleString());
  setKPIValue('kpi-wickets', totalWickets);
  setKPIValue('kpi-avg', battingAvg);
  setKPIValue('kpi-sr', strikeRate);
  setKPIValue('kpi-hs', highestScore);
  setKPIValue('kpi-sixes', totalSixes);
  setKPIValue('kpi-economy', economy);
}

function setKPIValue(elementId, value) {
  const el = document.getElementById(elementId);
  if (el) el.textContent = value;
}

// Chart rendering dispatcher based on active page
function renderActivePageCharts() {
  const filtered = getFilteredMatches();
  
  if (activePage === 'page-overview') {
    renderOverviewCharts(filtered);
  } else if (activePage === 'page-batting') {
    renderBattingCharts(filtered);
  } else if (activePage === 'page-bowling') {
    renderBowlingCharts(filtered);
  } else if (activePage === 'page-ipl') {
    renderIPLCharts(filtered);
  } else if (activePage === 'page-advanced') {
    renderAdvancedInsights();
  }
}

// Chart Helper - Destroy if existing
function prepareCanvas(canvasId) {
  if (charts[canvasId]) {
    charts[canvasId].destroy();
  }
  const canvas = document.getElementById(canvasId);
  return canvas ? canvas.getContext('2d') : null;
}

// Common Chart Colors & Options
const chartTheme = {
  cyan: '#00D2FF',
  orange: '#FF6B00',
  emerald: '#10B981',
  sky: '#38BDF8',
  amber: '#F59E0B',
  purple: '#8B5CF6',
  gridColor: 'rgba(255, 255, 255, 0.06)',
  textColor: '#94A3B8'
};

const commonChartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      labels: { color: chartTheme.textColor, font: { family: 'Outfit', size: 12 } }
    },
    tooltip: {
      backgroundColor: '#0F172A',
      titleColor: '#F8FAFC',
      bodyColor: '#38BDF8',
      borderColor: 'rgba(0, 210, 255, 0.4)',
      borderWidth: 1,
      padding: 12,
      displayColors: true,
      boxPadding: 4
    }
  },
  scales: {
    x: {
      grid: { color: chartTheme.gridColor },
      ticks: { color: chartTheme.textColor, font: { family: 'Inter', size: 11 } }
    },
    y: {
      grid: { color: chartTheme.gridColor },
      ticks: { color: chartTheme.textColor, font: { family: 'Inter', size: 11 } }
    }
  }
};

/* ==========================================================
   PAGE 01: CAREER OVERVIEW CHARTS
   ========================================================== */
function renderOverviewCharts(data) {
  // 1. Runs by Year Chart
  const ctxRuns = prepareCanvas('chart-runs-year');
  if (ctxRuns) {
    const yearsMap = {};
    for (let yr = 2015; yr <= 2024; yr++) yearsMap[yr] = 0;
    data.forEach(m => {
      const yr = m.Year;
      if (yearsMap[yr] !== undefined) {
        yearsMap[yr] += (parseInt(m.Runs) || 0);
      }
    });

    const labels = Object.keys(yearsMap);
    const runValues = Object.values(yearsMap);

    const gradient = ctxRuns.createLinearGradient(0, 0, 0, 300);
    gradient.addColorStop(0, 'rgba(0, 210, 255, 0.45)');
    gradient.addColorStop(1, 'rgba(0, 210, 255, 0.01)');

    charts['chart-runs-year'] = new Chart(ctxRuns, {
      type: 'line',
      data: {
        labels: labels,
        datasets: [{
          label: 'Total Runs',
          data: runValues,
          borderColor: chartTheme.cyan,
          borderWidth: 3,
          backgroundColor: gradient,
          fill: true,
          tension: 0.35,
          pointBackgroundColor: chartTheme.orange,
          pointBorderColor: '#FFFFFF',
          pointBorderWidth: 2,
          pointRadius: 5,
          pointHoverRadius: 8
        }]
      },
      options: {
        ...commonChartOptions,
        interaction: { mode: 'index', intersect: false }
      }
    });
  }

  // 2. Wickets by Year Chart (Combo Chart)
  const ctxWkts = prepareCanvas('chart-wickets-year');
  if (ctxWkts) {
    const yearsMap = {};
    const econMap = {};
    for (let yr = 2015; yr <= 2024; yr++) {
      yearsMap[yr] = 0;
      econMap[yr] = { overs: 0, rc: 0 };
    }

    data.forEach(m => {
      const yr = m.Year;
      const overs = parseFloat(m.Overs) || 0;
      const wkts = parseInt(m.Wickets) || 0;
      const rc = parseInt(m.Runs_Conceded) || 0;
      if (yearsMap[yr] !== undefined) {
        yearsMap[yr] += wkts;
        econMap[yr].overs += overs;
        econMap[yr].rc += rc;
      }
    });

    const labels = Object.keys(yearsMap);
    const wktValues = Object.values(yearsMap);
    const econValues = labels.map(yr => {
      const o = econMap[yr].overs;
      return o > 0 ? (econMap[yr].rc / o).toFixed(2) : 0;
    });

    charts['chart-wickets-year'] = new Chart(ctxWkts, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [
          {
            type: 'bar',
            label: 'Wickets',
            data: wktValues,
            backgroundColor: 'rgba(255, 107, 0, 0.75)',
            borderColor: chartTheme.orange,
            borderWidth: 1,
            borderRadius: 6,
            yAxisID: 'y'
          },
          {
            type: 'line',
            label: 'Economy Rate',
            data: econValues,
            borderColor: chartTheme.emerald,
            borderWidth: 2.5,
            pointBackgroundColor: chartTheme.emerald,
            tension: 0.3,
            yAxisID: 'y1'
          }
        ]
      },
      options: {
        ...commonChartOptions,
        scales: {
          x: commonChartOptions.scales.x,
          y: {
            ...commonChartOptions.scales.y,
            title: { display: true, text: 'Wickets', color: chartTheme.textColor }
          },
          y1: {
            position: 'right',
            grid: { drawOnChartArea: false },
            ticks: { color: chartTheme.emerald },
            title: { display: true, text: 'Economy', color: chartTheme.emerald }
          }
        }
      }
    });
  }

  // 3. Format Share Donut
  const ctxFormat = prepareCanvas('chart-format-share');
  if (ctxFormat) {
    const formatRuns = { Test: 0, ODI: 0, T20I: 0, IPL: 0 };
    data.forEach(m => {
      if (formatRuns[m.Format] !== undefined) {
        formatRuns[m.Format] += (parseInt(m.Runs) || 0);
      }
    });

    charts['chart-format-share'] = new Chart(ctxFormat, {
      type: 'doughnut',
      data: {
        labels: ['Test', 'ODI', 'T20I', 'IPL'],
        datasets: [{
          data: Object.values(formatRuns),
          backgroundColor: ['#38BDF8', '#0284C7', '#00D2FF', '#FF6B00'],
          borderColor: '#0F172A',
          borderWidth: 3,
          hoverOffset: 10
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { position: 'bottom', labels: { color: chartTheme.textColor } },
          tooltip: {
            callbacks: {
              label: (ctx) => ` ${ctx.label}: ${ctx.raw} Runs (${((ctx.raw / (Object.values(formatRuns).reduce((a,b)=>a+b,0)||1))*100).toFixed(1)}%)`
            }
          }
        },
        cutout: '68%'
      }
    });
  }

  // 4. Impact Radar Chart
  const ctxRadar = prepareCanvas('chart-impact-radar');
  if (ctxRadar) {
    charts['chart-impact-radar'] = new Chart(ctxRadar, {
      type: 'radar',
      data: {
        labels: ['Power Hitting (SR)', 'Consistency (Avg)', 'Wicket Striking', 'Economy Control', 'Clutch Finals', 'Fielding (Catches)'],
        datasets: [{
          label: 'Hardik Pandya Percentile Rating',
          data: [95, 82, 88, 76, 98, 92],
          backgroundColor: 'rgba(0, 210, 255, 0.25)',
          borderColor: chartTheme.cyan,
          pointBackgroundColor: chartTheme.orange,
          pointBorderColor: '#FFFFFF',
          pointHoverRadius: 7
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
          r: {
            angleLines: { color: chartTheme.gridColor },
            grid: { color: chartTheme.gridColor },
            pointLabels: { color: '#E2E8F0', font: { size: 11, family: 'Outfit' } },
            ticks: { display: false, max: 100, min: 0 }
          }
        },
        plugins: {
          legend: { display: false }
        }
      }
    });
  }
}

/* ==========================================================
   PAGE 02: BATTING ANALYTICS CHARTS
   ========================================================== */
function renderBattingCharts(data) {
  // 1. Batting by Format (Runs, Avg, SR)
  const ctxFormatBat = prepareCanvas('chart-batting-by-format');
  if (ctxFormatBat) {
    const fStats = {
      Test: { runs: 0, balls: 0, outs: 0 },
      ODI: { runs: 0, balls: 0, outs: 0 },
      T20I: { runs: 0, balls: 0, outs: 0 },
      IPL: { runs: 0, balls: 0, outs: 0 }
    };

    data.forEach(m => {
      const f = m.Format;
      if (fStats[f]) {
        const r = parseInt(m.Runs) || 0;
        const b = parseInt(m.Balls) || 0;
        const d = (m.Dismissal_Mode || '').toLowerCase();
        fStats[f].runs += r;
        fStats[f].balls += b;
        if (d !== 'not out' && d !== 'dnb') fStats[f].outs++;
      }
    });

    const formats = ['Test', 'ODI', 'T20I', 'IPL'];
    const avgs = formats.map(f => fStats[f].outs > 0 ? (fStats[f].runs / fStats[f].outs).toFixed(1) : 0);
    const srs = formats.map(f => fStats[f].balls > 0 ? ((fStats[f].runs / fStats[f].balls) * 100).toFixed(1) : 0);

    charts['chart-batting-by-format'] = new Chart(ctxFormatBat, {
      type: 'bar',
      data: {
        labels: formats,
        datasets: [
          {
            label: 'Batting Average',
            data: avgs,
            backgroundColor: 'rgba(0, 210, 255, 0.75)',
            borderColor: chartTheme.cyan,
            borderRadius: 6
          },
          {
            label: 'Strike Rate',
            data: srs,
            backgroundColor: 'rgba(255, 107, 0, 0.75)',
            borderColor: chartTheme.orange,
            borderRadius: 6
          }
        ]
      },
      options: {
        ...commonChartOptions
      }
    });
  }

  // 2. Runs vs Strike Rate Scatter Chart
  const ctxScatter = prepareCanvas('chart-runs-vs-sr');
  if (ctxScatter) {
    const points = [];
    data.forEach(m => {
      const runs = parseInt(m.Runs) || 0;
      const sr = parseFloat(m.Strike_Rate) || 0;
      const balls = parseInt(m.Balls) || 0;
      if (balls >= 8) {
        points.push({
          x: runs,
          y: sr,
          match: `${m.Tournament} vs ${m.Opponent} (${m.Year}): ${runs} (${balls}b)`
        });
      }
    });

    charts['chart-runs-vs-sr'] = new Chart(ctxScatter, {
      type: 'scatter',
      data: {
        datasets: [{
          label: 'Innings (Runs vs SR)',
          data: points,
          backgroundColor: 'rgba(0, 210, 255, 0.65)',
          borderColor: chartTheme.cyan,
          pointRadius: 5,
          pointHoverRadius: 8
        }]
      },
      options: {
        ...commonChartOptions,
        scales: {
          x: {
            ...commonChartOptions.scales.x,
            title: { display: true, text: 'Runs Scored', color: chartTheme.textColor }
          },
          y: {
            ...commonChartOptions.scales.y,
            title: { display: true, text: 'Strike Rate', color: chartTheme.textColor }
          }
        },
        plugins: {
          ...commonChartOptions.plugins,
          tooltip: {
            callbacks: {
              label: (ctx) => ctx.raw.match + ` | SR: ${ctx.raw.y}`
            }
          }
        }
      }
    });
  }

  // 3. Sixes & Fours by Year
  const ctxBoundaries = prepareCanvas('chart-boundaries-year');
  if (ctxBoundaries) {
    const yrSixes = {};
    const yrFours = {};
    for (let yr = 2015; yr <= 2024; yr++) {
      yrSixes[yr] = 0;
      yrFours[yr] = 0;
    }

    data.forEach(m => {
      const yr = m.Year;
      if (yrSixes[yr] !== undefined) {
        yrSixes[yr] += (parseInt(m.Sixes) || 0);
        yrFours[yr] += (parseInt(m.Fours) || 0);
      }
    });

    const labels = Object.keys(yrSixes);
    charts['chart-boundaries-year'] = new Chart(ctxBoundaries, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [
          {
            label: 'Sixes',
            data: Object.values(yrSixes),
            backgroundColor: 'rgba(255, 107, 0, 0.85)',
            borderColor: chartTheme.orange,
            borderRadius: 6
          },
          {
            label: 'Fours',
            data: Object.values(yrFours),
            backgroundColor: 'rgba(56, 189, 248, 0.75)',
            borderColor: chartTheme.sky,
            borderRadius: 6
          }
        ]
      },
      options: {
        ...commonChartOptions,
        scales: {
          x: { ...commonChartOptions.scales.x, stacked: true },
          y: { ...commonChartOptions.scales.y, stacked: true }
        }
      }
    });
  }

  // 4. Dismissal Modes Breakdown
  const ctxDismissal = prepareCanvas('chart-dismissal-modes');
  if (ctxDismissal) {
    const dCounts = { 'Caught': 0, 'Bowled': 0, 'LBW': 0, 'Run Out': 0, 'Not Out': 0 };
    data.forEach(m => {
      const d = (m.Dismissal_Mode || '').toLowerCase();
      if (d === 'caught') dCounts['Caught']++;
      else if (d === 'bowled') dCounts['Bowled']++;
      else if (d === 'lbw') dCounts['LBW']++;
      else if (d === 'run out') dCounts['Run Out']++;
      else if (d === 'not out') dCounts['Not Out']++;
    });

    charts['chart-dismissal-modes'] = new Chart(ctxDismissal, {
      type: 'pie',
      data: {
        labels: Object.keys(dCounts),
        datasets: [{
          data: Object.values(dCounts),
          backgroundColor: ['#00D2FF', '#FF6B00', '#F59E0B', '#F43F5E', '#10B981'],
          borderColor: '#0F172A',
          borderWidth: 2
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { position: 'right', labels: { color: chartTheme.textColor } }
        }
      }
    });
  }
}

/* ==========================================================
   PAGE 03: BOWLING ANALYTICS CHARTS
   ========================================================== */
function renderBowlingCharts(data) {
  // 1. Bowling by Format (Wickets, Economy)
  const ctxBowlFormat = prepareCanvas('chart-bowling-by-format');
  if (ctxBowlFormat) {
    const fStats = {
      Test: { wkts: 0, overs: 0, rc: 0 },
      ODI: { wkts: 0, overs: 0, rc: 0 },
      T20I: { wkts: 0, overs: 0, rc: 0 },
      IPL: { wkts: 0, overs: 0, rc: 0 }
    };

    data.forEach(m => {
      const f = m.Format;
      if (fStats[f]) {
        fStats[f].wkts += (parseInt(m.Wickets) || 0);
        fStats[f].overs += (parseFloat(m.Overs) || 0);
        fStats[f].rc += (parseInt(m.Runs_Conceded) || 0);
      }
    });

    const formats = ['Test', 'ODI', 'T20I', 'IPL'];
    const wkts = formats.map(f => fStats[f].wkts);
    const econs = formats.map(f => fStats[f].overs > 0 ? (fStats[f].rc / fStats[f].overs).toFixed(2) : 0);

    charts['chart-bowling-by-format'] = new Chart(ctxBowlFormat, {
      type: 'bar',
      data: {
        labels: formats,
        datasets: [
          {
            type: 'bar',
            label: 'Total Wickets',
            data: wkts,
            backgroundColor: 'rgba(255, 107, 0, 0.8)',
            borderColor: chartTheme.orange,
            borderRadius: 6,
            yAxisID: 'y'
          },
          {
            type: 'line',
            label: 'Economy Rate',
            data: econs,
            borderColor: chartTheme.cyan,
            borderWidth: 3,
            pointBackgroundColor: chartTheme.cyan,
            yAxisID: 'y1'
          }
        ]
      },
      options: {
        ...commonChartOptions,
        scales: {
          x: commonChartOptions.scales.x,
          y: { ...commonChartOptions.scales.y, title: { display: true, text: 'Wickets', color: chartTheme.textColor } },
          y1: { position: 'right', grid: { drawOnChartArea: false }, ticks: { color: chartTheme.cyan }, title: { display: true, text: 'Economy', color: chartTheme.cyan } }
        }
      }
    });
  }

  // 2. Bowling Economy Trend over Years
  const ctxEconYear = prepareCanvas('chart-economy-year');
  if (ctxEconYear) {
    const yrMap = {};
    for (let yr = 2015; yr <= 2024; yr++) yrMap[yr] = { overs: 0, rc: 0 };
    data.forEach(m => {
      const yr = m.Year;
      if (yrMap[yr]) {
        yrMap[yr].overs += (parseFloat(m.Overs) || 0);
        yrMap[yr].rc += (parseInt(m.Runs_Conceded) || 0);
      }
    });

    const labels = Object.keys(yrMap);
    const econVals = labels.map(yr => yrMap[yr].overs > 0 ? (yrMap[yr].rc / yrMap[yr].overs).toFixed(2) : 0);

    charts['chart-economy-year'] = new Chart(ctxEconYear, {
      type: 'line',
      data: {
        labels: labels,
        datasets: [{
          label: 'Annual Economy Rate',
          data: econVals,
          borderColor: chartTheme.emerald,
          backgroundColor: 'rgba(16, 185, 129, 0.1)',
          fill: true,
          tension: 0.35,
          borderWidth: 3,
          pointBackgroundColor: chartTheme.emerald,
          pointRadius: 5
        }]
      },
      options: commonChartOptions
    });
  }

  // 3. Performance Against Opponents (Horizontal Bar)
  const ctxOpponents = prepareCanvas('chart-wickets-opponents');
  if (ctxOpponents) {
    const oppMap = {};
    data.forEach(m => {
      const opp = m.Opponent;
      if (!oppMap[opp]) oppMap[opp] = { wkts: 0, runs: 0 };
      oppMap[opp].wkts += (parseInt(m.Wickets) || 0);
      oppMap[opp].runs += (parseInt(m.Runs) || 0);
    });

    // Top 8 opponents by wickets
    const sorted = Object.entries(oppMap).sort((a, b) => b[1].wkts - a[1].wkts).slice(0, 8);
    const labels = sorted.map(s => s[0]);
    const wkts = sorted.map(s => s[1].wkts);
    const runs = sorted.map(s => s[1].runs);

    charts['chart-wickets-opponents'] = new Chart(ctxOpponents, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [
          {
            label: 'Wickets',
            data: wkts,
            backgroundColor: 'rgba(255, 107, 0, 0.8)',
            borderColor: chartTheme.orange,
            borderRadius: 6
          },
          {
            label: 'Runs Scored',
            data: runs,
            backgroundColor: 'rgba(0, 210, 255, 0.8)',
            borderColor: chartTheme.cyan,
            borderRadius: 6
          }
        ]
      },
      options: {
        ...commonChartOptions,
        indexAxis: 'y'
      }
    });
  }
}

/* ==========================================================
   PAGE 04: IPL ANALYTICS CHARTS
   ========================================================== */
function renderIPLCharts(data) {
  const iplData = window.HARDIK_DATA?.ipl || [];
  if (!iplData.length) return;

  // 1. IPL Runs & Strike Rate
  const ctxIPLRuns = prepareCanvas('chart-ipl-runs-sr');
  if (ctxIPLRuns) {
    const seasons = iplData.map(d => d.Season);
    const runs = iplData.map(d => parseInt(d.Runs));
    const srs = iplData.map(d => parseFloat(d.Strike_Rate));

    charts['chart-ipl-runs-sr'] = new Chart(ctxIPLRuns, {
      type: 'bar',
      data: {
        labels: seasons,
        datasets: [
          {
            type: 'bar',
            label: 'IPL Runs',
            data: runs,
            backgroundColor: iplData.map(d => d.Team === 'Gujarat Titans' ? 'rgba(0, 210, 255, 0.75)' : 'rgba(2, 132, 199, 0.75)'),
            borderColor: chartTheme.cyan,
            borderRadius: 6,
            yAxisID: 'y'
          },
          {
            type: 'line',
            label: 'Strike Rate',
            data: srs,
            borderColor: chartTheme.orange,
            borderWidth: 3,
            pointBackgroundColor: chartTheme.orange,
            pointRadius: 5,
            yAxisID: 'y1'
          }
        ]
      },
      options: {
        ...commonChartOptions,
        scales: {
          x: commonChartOptions.scales.x,
          y: { ...commonChartOptions.scales.y, title: { display: true, text: 'Runs', color: chartTheme.textColor } },
          y1: { position: 'right', grid: { drawOnChartArea: false }, ticks: { color: chartTheme.orange }, title: { display: true, text: 'Strike Rate', color: chartTheme.orange } }
        }
      }
    });
  }

  // 2. IPL Wickets & Economy
  const ctxIPLBowl = prepareCanvas('chart-ipl-wickets-econ');
  if (ctxIPLBowl) {
    const seasons = iplData.map(d => d.Season);
    const wkts = iplData.map(d => parseInt(d.Wickets));
    const econ = iplData.map(d => parseFloat(d.Economy));

    charts['chart-ipl-wickets-econ'] = new Chart(ctxIPLBowl, {
      type: 'bar',
      data: {
        labels: seasons,
        datasets: [
          {
            label: 'Wickets',
            data: wkts,
            backgroundColor: 'rgba(255, 107, 0, 0.8)',
            borderColor: chartTheme.orange,
            borderRadius: 6,
            yAxisID: 'y'
          },
          {
            type: 'line',
            label: 'Economy Rate',
            data: econ,
            borderColor: chartTheme.emerald,
            borderWidth: 2.5,
            pointBackgroundColor: chartTheme.emerald,
            pointRadius: 5,
            yAxisID: 'y1'
          }
        ]
      },
      options: {
        ...commonChartOptions,
        scales: {
          x: commonChartOptions.scales.x,
          y: { ...commonChartOptions.scales.y, title: { display: true, text: 'Wickets', color: chartTheme.textColor } },
          y1: { position: 'right', grid: { drawOnChartArea: false }, ticks: { color: chartTheme.emerald }, title: { display: true, text: 'Economy Rate', color: chartTheme.emerald } }
        }
      }
    });
  }
}

/* ==========================================================
   PAGE 05: MATCH-BY-MATCH TABLE & DRILL-DOWN
   ========================================================== */
function renderMatchTable() {
  const tbody = document.getElementById('match-table-body');
  if (!tbody) return;

  const data = getFilteredMatches();
  const query = currentFilters.searchQuery;

  const filtered = query ? data.filter(m => 
    (m.Opponent && m.Opponent.toLowerCase().includes(query)) ||
    (m.Tournament && m.Tournament.toLowerCase().includes(query)) ||
    (m.Venue && m.Venue.toLowerCase().includes(query)) ||
    (m.Format && m.Format.toLowerCase().includes(query)) ||
    (m.Result && m.Result.toLowerCase().includes(query))
  ) : data;

  // Show top 35 matches for performance and pagination feel
  const displaySlice = filtered.slice(0, 35);
  tbody.innerHTML = '';

  const countBadge = document.getElementById('table-count-badge');
  if (countBadge) {
    countBadge.textContent = `Showing ${displaySlice.length} of ${filtered.length} matches`;
  }

  if (displaySlice.length === 0) {
    tbody.innerHTML = `<tr><td colspan="10" style="text-align:center; padding: 24px; color: var(--text-muted);">No matches match the selected filters.</td></tr>`;
    return;
  }

  displaySlice.forEach(m => {
    const tr = document.createElement('tr');
    tr.style.cursor = 'pointer';

    const runs = parseInt(m.Runs) || 0;
    const balls = parseInt(m.Balls) || 0;
    const wkts = parseInt(m.Wickets) || 0;
    const rc = parseInt(m.Runs_Conceded) || 0;
    const isWin = (m.Result || '').toLowerCase() === 'won';
    const isPom = (m.Player_of_Match || '').toLowerCase() === 'yes';

    tr.innerHTML = `
      <td style="font-weight:600; color:var(--text-accent);">${m.Match_Date}</td>
      <td><span class="badge ${m.Format === 'IPL' ? 'badge-jersey' : 'badge-india'}">${m.Format}</span></td>
      <td><strong>${m.Opponent}</strong></td>
      <td style="max-width:180px; overflow:hidden; text-overflow:ellipsis;">${m.Tournament}</td>
      <td class="run-highlight ${runs >= 50 ? 'high' : ''}">${runs} <small style="color:var(--text-muted);">(${balls}b)</small></td>
      <td>${m.Strike_Rate || '0.0'}</td>
      <td style="color:${wkts >= 3 ? 'var(--accent-orange)' : '#E2E8F0'}; font-weight:${wkts >= 3 ? '700' : '500'};">${wkts}/${rc} <small style="color:var(--text-muted);">(${m.Overs}ov)</small></td>
      <td><span class="${isWin ? 'badge-win' : 'badge-loss'}">${m.Result}</span></td>
      <td>${isPom ? '<span class="badge-pom">★ Player of Match</span>' : '—'}</td>
      <td style="font-weight:700; color:var(--accent-cyan);">${m.Match_Impact_Score || '—'}</td>
    `;

    // Click row to open Drill-Down modal
    tr.addEventListener('click', () => openDrillDownModal(m));
    tbody.appendChild(tr);
  });
}

function openDrillDownModal(m) {
  const modal = document.getElementById('drill-modal-overlay');
  if (!modal) return;

  document.getElementById('modal-match-title').textContent = `${m.Team} vs ${m.Opponent}`;
  document.getElementById('modal-match-sub').textContent = `${m.Tournament} • ${m.Match_Date} • ${m.Venue}`;
  
  document.getElementById('modal-stat-format').textContent = m.Format;
  document.getElementById('modal-stat-runs').textContent = `${m.Runs} runs (${m.Balls}b)`;
  document.getElementById('modal-stat-sr').textContent = m.Strike_Rate;
  document.getElementById('modal-stat-boundaries').textContent = `${m.Fours} fours, ${m.Sixes} sixes`;
  document.getElementById('modal-stat-dismissal').textContent = m.Dismissal_Mode || '—';
  document.getElementById('modal-stat-bowling').textContent = `${m.Wickets}/${m.Runs_Conceded} in ${m.Overs} overs`;
  document.getElementById('modal-stat-econ').textContent = m.Economy;
  document.getElementById('modal-stat-catches').textContent = m.Catches;
  document.getElementById('modal-stat-result').textContent = `${m.Result} ${m.Player_of_Match === 'Yes' ? '★ (Player of Match)' : ''}`;
  document.getElementById('modal-stat-impact').textContent = m.Match_Impact_Score;

  modal.classList.add('active');
}

/* ==========================================================
   PAGE 06: ADVANCED INSIGHTS (WAGON WHEEL & MATCHUPS LOGIC)
   ========================================================== */
function initWagonWheel() {
  const slices = document.querySelectorAll('.shot-zone-slice');
  const wheelData = window.HARDIK_DATA?.wagonWheel || [];
  if (!slices.length || !wheelData.length) return;

  slices.forEach(slice => {
    slice.addEventListener('click', () => {
      slices.forEach(s => s.classList.remove('selected'));
      slice.classList.add('selected');

      const zoneId = slice.getAttribute('data-zone');
      const item = wheelData.find(w => w.Zone === zoneId);
      if (item) {
        updateZoneDetails(item);
      }
    });

    slice.addEventListener('mouseenter', () => {
      const zoneId = slice.getAttribute('data-zone');
      const item = wheelData.find(w => w.Zone === zoneId);
      if (item) {
        updateZoneDetails(item);
      }
    });
  });
}

function updateZoneDetails(z) {
  const title = document.getElementById('zone-card-title');
  const pct = document.getElementById('zone-card-pct');
  const desc = document.getElementById('zone-card-desc');
  const runs = document.getElementById('zone-card-runs');
  const sr = document.getElementById('zone-card-sr');
  const fours = document.getElementById('zone-card-fours');
  const sixes = document.getElementById('zone-card-sixes');

  if (title) title.textContent = z.Display_Name;
  if (pct) pct.textContent = `${z.Pct_Runs}% of Runs`;
  if (desc) desc.textContent = z.Description;
  if (runs) runs.textContent = parseInt(z.Runs).toLocaleString();
  if (sr) sr.textContent = z.Strike_Rate;
  if (fours) fours.textContent = z.Fours;
  if (sixes) sixes.textContent = z.Sixes;
}

function renderAdvancedInsights() {
  initWagonWheel();
  renderBowlerMatchups();
}

function renderBowlerMatchups() {
  const container = document.getElementById('matchups-grid-container');
  if (!container) return;

  const matchups = window.HARDIK_DATA?.matchups || [];
  if (!matchups.length) return;

  container.innerHTML = '';
  matchups.forEach(m => {
    const card = document.createElement('div');
    card.className = 'matchup-card';
    const sr = parseFloat(m.Strike_Rate);
    const avg = parseFloat(m.Batting_Average);

    card.innerHTML = `
      <div style="display:flex; justify-content:space-between; align-items:flex-start;">
        <div>
          <div class="matchup-bowler-name">${m.Bowler}</div>
          <div class="matchup-bowler-sub">${m.Country_Team} • ${m.Bowler_Type}</div>
        </div>
        <span class="badge ${sr >= 150 ? 'badge-jersey' : 'badge-india'}">SR ${sr}</span>
      </div>

      <div class="matchup-stats-flex">
        <div class="matchup-stat-box">
          <div class="matchup-stat-val" style="color:var(--accent-cyan);">${m.Runs_Scored}</div>
          <div class="matchup-stat-lbl">Runs (${m.Balls_Faced}b)</div>
        </div>
        <div class="matchup-stat-box">
          <div class="matchup-stat-val" style="color:${m.Dismissals === '1' ? 'var(--accent-emerald)' : '#FFFFFF'};">${avg.toFixed(1)}</div>
          <div class="matchup-stat-lbl">Avg (${m.Dismissals} out)</div>
        </div>
        <div class="matchup-stat-box">
          <div class="matchup-stat-val" style="color:var(--accent-orange);">${m.Sixes}</div>
          <div class="matchup-stat-lbl">Sixes</div>
        </div>
        <div class="matchup-stat-box">
          <div class="matchup-stat-val" style="color:var(--text-muted);">${m.Dot_Ball_Pct}%</div>
          <div class="matchup-stat-lbl">Dots</div>
        </div>
      </div>
    `;
    container.appendChild(card);
  });
}

