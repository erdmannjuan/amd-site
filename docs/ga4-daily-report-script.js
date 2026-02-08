/**
 * AMD Machines - Daily GA4 Analytics Report
 *
 * Sends a daily HTML email with an Excel attachment containing:
 *   1. Visitor Detail — each traffic source with category label and pages visited
 *   2. Top 20 Pages — best performing pages with source breakdown per category
 *   3. Summary — totals for the day
 *
 * Source categories:
 *   Organic    — medium = "organic" or known search engine
 *   Paid Search — medium contains "cpc", "ppc", or "paid"
 *   Reference  — external referrals not classified above
 *   From AMD   — source = "(direct)" or contains "amdmachines"
 *
 * SETUP:
 * 1. Open https://script.google.com — create or open a project
 * 2. Enable "Google Analytics Data API" under Services (+) in sidebar
 * 3. In Google Cloud Console, enable "Google Analytics Data API" for the linked project
 * 4. Paste this script into Code.gs
 * 5. Run testReport() to authorize and verify
 * 6. Run setupTrigger() once to schedule the 9 PM Central daily trigger
 */

// ============ CONFIGURATION ============
var CONFIG = {
  GA4_PROPERTY_ID: '338848281',
  EMAIL_TO: 'je@amdmachines.com',
  EMAIL_SUBJECT: 'AMD Machines - Daily Visitor Report',
  TIMEZONE: 'America/Chicago'
};

var SEARCH_ENGINES = [
  'google', 'bing', 'yahoo', 'duckduckgo', 'baidu', 'yandex',
  'ecosia', 'ask', 'aol', 'dogpile', 'startpage', 'qwant'
];

// ============ MAIN ============

/**
 * Main entry point — fetches data, processes it, builds email + Excel, sends.
 */
function sendDailyReport() {
  try {
    var today = new Date();
    var yesterday = new Date(today);
    yesterday.setDate(yesterday.getDate() - 1);

    var reportDate = Utilities.formatDate(yesterday, CONFIG.TIMEZONE, 'yyyy-MM-dd');

    var visitorRows = fetchVisitorDetail(reportDate);
    var topPagesRows = fetchTopPages(reportDate);

    if ((!visitorRows || visitorRows.length === 0) && (!topPagesRows || topPagesRows.length === 0)) {
      sendEmptyReport(reportDate);
      return;
    }

    var visitorData = processVisitorData(visitorRows);
    var topPagesData = processTopPagesData(topPagesRows);

    var summary = buildSummary(visitorRows, topPagesRows);
    var htmlBody = buildHtmlEmail(visitorData, topPagesData, summary, reportDate);
    var excelBlob = createExcelReport(visitorData, topPagesData, summary, reportDate);

    sendReportEmail(htmlBody, excelBlob, reportDate);

    Logger.log('Daily report sent successfully for ' + reportDate);
  } catch (error) {
    Logger.log('Error: ' + error.toString() + '\n' + error.stack);
    sendErrorNotification(error);
  }
}

// ============ GA4 API CALLS ============

/**
 * Visitor Detail query — sessions grouped by source/medium/page.
 */
function fetchVisitorDetail(reportDate) {
  var request = AnalyticsData.newRunReportRequest();

  var dateRange = AnalyticsData.newDateRange();
  dateRange.startDate = reportDate;
  dateRange.endDate = reportDate;
  request.dateRanges = dateRange;

  var dimSource = AnalyticsData.newDimension();
  dimSource.name = 'sessionSource';
  var dimMedium = AnalyticsData.newDimension();
  dimMedium.name = 'sessionMedium';
  var dimPage = AnalyticsData.newDimension();
  dimPage.name = 'pagePath';
  request.dimensions = [dimSource, dimMedium, dimPage];

  var metSessions = AnalyticsData.newMetric();
  metSessions.name = 'sessions';
  var metPageViews = AnalyticsData.newMetric();
  metPageViews.name = 'screenPageViews';
  request.metrics = [metSessions, metPageViews];

  var orderBy = AnalyticsData.newOrderBy();
  orderBy.desc = true;
  var metricOrder = AnalyticsData.newMetricOrderBy();
  metricOrder.metricName = 'sessions';
  orderBy.metric = metricOrder;
  request.orderBys = [orderBy];

  request.limit = 5000;

  var response = AnalyticsData.Properties.runReport(request, 'properties/' + CONFIG.GA4_PROPERTY_ID);
  return parseVisitorRows(response);
}

/**
 * Top Pages query — pageviews per page with source breakdown.
 */
function fetchTopPages(reportDate) {
  var request = AnalyticsData.newRunReportRequest();

  var dateRange = AnalyticsData.newDateRange();
  dateRange.startDate = reportDate;
  dateRange.endDate = reportDate;
  request.dateRanges = dateRange;

  var dimPage = AnalyticsData.newDimension();
  dimPage.name = 'pagePath';
  var dimSource = AnalyticsData.newDimension();
  dimSource.name = 'sessionSource';
  var dimMedium = AnalyticsData.newDimension();
  dimMedium.name = 'sessionMedium';
  request.dimensions = [dimPage, dimSource, dimMedium];

  var metPageViews = AnalyticsData.newMetric();
  metPageViews.name = 'screenPageViews';
  var metSessions = AnalyticsData.newMetric();
  metSessions.name = 'sessions';
  var metUsers = AnalyticsData.newMetric();
  metUsers.name = 'totalUsers';
  request.metrics = [metPageViews, metSessions, metUsers];

  var orderBy = AnalyticsData.newOrderBy();
  orderBy.desc = true;
  var metricOrder = AnalyticsData.newMetricOrderBy();
  metricOrder.metricName = 'screenPageViews';
  orderBy.metric = metricOrder;
  request.orderBys = [orderBy];

  request.limit = 5000;

  var response = AnalyticsData.Properties.runReport(request, 'properties/' + CONFIG.GA4_PROPERTY_ID);
  return parseTopPagesRows(response);
}

// ============ ROW PARSERS ============

function parseVisitorRows(response) {
  var rows = (response && response.rows) || [];
  var data = [];
  for (var i = 0; i < rows.length; i++) {
    var r = rows[i];
    data.push({
      source: r.dimensionValues[0].value,
      medium: r.dimensionValues[1].value,
      pagePath: r.dimensionValues[2].value,
      sessions: parseInt(r.metricValues[0].value, 10),
      pageViews: parseInt(r.metricValues[1].value, 10)
    });
  }
  return data;
}

function parseTopPagesRows(response) {
  var rows = (response && response.rows) || [];
  var data = [];
  for (var i = 0; i < rows.length; i++) {
    var r = rows[i];
    data.push({
      pagePath: r.dimensionValues[0].value,
      source: r.dimensionValues[1].value,
      medium: r.dimensionValues[2].value,
      pageViews: parseInt(r.metricValues[0].value, 10),
      sessions: parseInt(r.metricValues[1].value, 10),
      users: parseInt(r.metricValues[2].value, 10)
    });
  }
  return data;
}

// ============ CATEGORIZATION ============

/**
 * Classify a source/medium pair into one of 4 categories.
 */
function categorizeSource(source, medium) {
  var src = (source || '').toLowerCase();
  var med = (medium || '').toLowerCase();

  // Paid Search
  if (med.indexOf('cpc') !== -1 || med.indexOf('ppc') !== -1 || med.indexOf('paid') !== -1) {
    return 'Paid Search';
  }

  // Organic
  if (med === 'organic') {
    return 'Organic';
  }
  for (var i = 0; i < SEARCH_ENGINES.length; i++) {
    if (src.indexOf(SEARCH_ENGINES[i]) !== -1) {
      return 'Organic';
    }
  }

  // From AMD (direct or self-referral)
  if (src === '(direct)' || src === '(none)' || src.indexOf('amdmachines') !== -1) {
    return 'From AMD';
  }

  // Everything else is a reference
  return 'Reference';
}

var CATEGORY_COLORS = {
  'Organic': '#2e7d32',
  'Paid Search': '#c62828',
  'Reference': '#1565c0',
  'From AMD': '#6a1b9a'
};

// ============ DATA PROCESSING ============

/**
 * Group visitor rows by source, list pages per source.
 * Returns array of { source, medium, category, totalSessions, totalPageViews, pages: [{path, sessions, pageViews}] }
 */
function processVisitorData(rows) {
  var sourceMap = {};
  for (var i = 0; i < rows.length; i++) {
    var r = rows[i];
    var key = r.source + '||' + r.medium;
    if (!sourceMap[key]) {
      sourceMap[key] = {
        source: r.source,
        medium: r.medium,
        category: categorizeSource(r.source, r.medium),
        totalSessions: 0,
        totalPageViews: 0,
        pages: []
      };
    }
    sourceMap[key].totalSessions += r.sessions;
    sourceMap[key].totalPageViews += r.pageViews;
    sourceMap[key].pages.push({ path: r.pagePath, sessions: r.sessions, pageViews: r.pageViews });
  }

  var result = [];
  for (var k in sourceMap) {
    if (sourceMap.hasOwnProperty(k)) {
      var entry = sourceMap[k];
      entry.pages.sort(function(a, b) { return b.pageViews - a.pageViews; });
      result.push(entry);
    }
  }
  result.sort(function(a, b) { return b.totalSessions - a.totalSessions; });
  return result;
}

/**
 * Aggregate by page, rank top 20, include source breakdown per category.
 * Returns array of { pagePath, totalPageViews, totalSessions, totalUsers, categories: {Organic: n, ...} }
 */
function processTopPagesData(rows) {
  var pageMap = {};
  for (var i = 0; i < rows.length; i++) {
    var r = rows[i];
    if (!pageMap[r.pagePath]) {
      pageMap[r.pagePath] = {
        pagePath: r.pagePath,
        totalPageViews: 0,
        totalSessions: 0,
        totalUsers: 0,
        categories: { 'Organic': 0, 'Paid Search': 0, 'Reference': 0, 'From AMD': 0 }
      };
    }
    var p = pageMap[r.pagePath];
    p.totalPageViews += r.pageViews;
    p.totalSessions += r.sessions;
    p.totalUsers += r.users;
    var cat = categorizeSource(r.source, r.medium);
    p.categories[cat] += r.pageViews;
  }

  var result = [];
  for (var k in pageMap) {
    if (pageMap.hasOwnProperty(k)) {
      result.push(pageMap[k]);
    }
  }
  result.sort(function(a, b) { return b.totalPageViews - a.totalPageViews; });
  return result.slice(0, 20);
}

/**
 * Build high-level summary numbers.
 */
function buildSummary(visitorRows, topPagesRows) {
  var totalSessions = 0;
  var totalPageViews = 0;
  var totalUsers = 0;
  var categoryCounts = { 'Organic': 0, 'Paid Search': 0, 'Reference': 0, 'From AMD': 0 };

  for (var i = 0; i < visitorRows.length; i++) {
    totalSessions += visitorRows[i].sessions;
    totalPageViews += visitorRows[i].pageViews;
    var cat = categorizeSource(visitorRows[i].source, visitorRows[i].medium);
    categoryCounts[cat] += visitorRows[i].sessions;
  }

  for (var j = 0; j < topPagesRows.length; j++) {
    totalUsers += topPagesRows[j].users;
  }

  return {
    totalSessions: totalSessions,
    totalPageViews: totalPageViews,
    totalUsers: totalUsers,
    categoryCounts: categoryCounts
  };
}

// ============ HTML EMAIL ============

function buildHtmlEmail(visitorData, topPagesData, summary, reportDate) {
  var html = '';

  // Container
  html += '<div style="font-family:Arial,Helvetica,sans-serif;max-width:800px;margin:0 auto;color:#333;">';

  // Header
  html += '<h2 style="color:#003087;margin-bottom:4px;">AMD Machines — Daily Visitor Report</h2>';
  html += '<p style="color:#666;margin-top:0;">Report date: <strong>' + reportDate + '</strong></p>';

  // Summary bar
  html += '<table cellpadding="0" cellspacing="0" style="width:100%;border-collapse:collapse;margin-bottom:20px;">';
  html += '<tr>';
  html += summaryCell('Sessions', summary.totalSessions, '#003087');
  html += summaryCell('Pageviews', summary.totalPageViews, '#00b785');
  html += summaryCell('Users', summary.totalUsers, '#c62828');
  html += '</tr></table>';

  // Category breakdown bar
  html += '<table cellpadding="0" cellspacing="0" style="width:100%;border-collapse:collapse;margin-bottom:24px;">';
  html += '<tr>';
  var cats = ['Organic', 'Paid Search', 'Reference', 'From AMD'];
  for (var c = 0; c < cats.length; c++) {
    html += summaryCell(cats[c], summary.categoryCounts[cats[c]] || 0, CATEGORY_COLORS[cats[c]]);
  }
  html += '</tr></table>';

  // --- Section 1: Visitor Detail ---
  html += '<h3 style="color:#003087;border-bottom:2px solid #003087;padding-bottom:4px;">Visitor Detail</h3>';

  if (visitorData.length === 0) {
    html += '<p style="color:#999;">No visitor data for this date.</p>';
  } else {
    for (var v = 0; v < visitorData.length; v++) {
      var src = visitorData[v];
      var catColor = CATEGORY_COLORS[src.category] || '#333';

      html += '<table cellpadding="6" cellspacing="0" style="width:100%;border-collapse:collapse;margin-bottom:12px;border:1px solid #e0e0e0;">';
      // Source header row
      html += '<tr style="background:#f5f5f5;">';
      html += '<td colspan="3" style="font-weight:bold;font-size:14px;">';
      html += escapeHtml(src.source) + ' / ' + escapeHtml(src.medium);
      html += ' <span style="display:inline-block;padding:2px 8px;border-radius:3px;font-size:11px;color:#fff;background:' + catColor + ';">' + src.category + '</span>';
      html += '</td>';
      html += '<td style="text-align:right;font-size:13px;color:#666;">' + src.totalSessions + ' sessions &middot; ' + src.totalPageViews + ' views</td>';
      html += '</tr>';

      // Page sub-header
      html += '<tr style="background:#fafafa;font-size:12px;color:#888;">';
      html += '<td style="width:60%;padding-left:20px;">Page</td>';
      html += '<td style="text-align:right;">Sessions</td>';
      html += '<td style="text-align:right;">Views</td>';
      html += '<td></td>';
      html += '</tr>';

      // Pages
      for (var p = 0; p < src.pages.length; p++) {
        var pg = src.pages[p];
        var bgColor = p % 2 === 0 ? '#fff' : '#fafafa';
        html += '<tr style="background:' + bgColor + ';font-size:13px;">';
        html += '<td style="padding-left:20px;">' + escapeHtml(pg.path) + '</td>';
        html += '<td style="text-align:right;">' + pg.sessions + '</td>';
        html += '<td style="text-align:right;">' + pg.pageViews + '</td>';
        html += '<td></td>';
        html += '</tr>';
      }

      html += '</table>';
    }
  }

  // --- Section 2: Top 20 Pages ---
  html += '<h3 style="color:#003087;border-bottom:2px solid #003087;padding-bottom:4px;margin-top:28px;">Top 20 Pages</h3>';

  if (topPagesData.length === 0) {
    html += '<p style="color:#999;">No page data for this date.</p>';
  } else {
    html += '<table cellpadding="6" cellspacing="0" style="width:100%;border-collapse:collapse;border:1px solid #e0e0e0;">';
    // Header
    html += '<tr style="background:#003087;color:#fff;font-size:13px;">';
    html += '<th style="text-align:left;">Page</th>';
    html += '<th style="text-align:right;">Views</th>';
    html += '<th style="text-align:right;">Sessions</th>';
    html += '<th style="text-align:right;">Users</th>';
    html += '<th style="text-align:right;color:' + lighten('Organic') + ';">Organic</th>';
    html += '<th style="text-align:right;color:' + lighten('Paid Search') + ';">Paid</th>';
    html += '<th style="text-align:right;color:' + lighten('Reference') + ';">Ref</th>';
    html += '<th style="text-align:right;color:' + lighten('From AMD') + ';">AMD</th>';
    html += '</tr>';

    for (var t = 0; t < topPagesData.length; t++) {
      var tp = topPagesData[t];
      var bg = t % 2 === 0 ? '#fff' : '#f9f9f9';
      html += '<tr style="background:' + bg + ';font-size:13px;">';
      html += '<td>' + escapeHtml(tp.pagePath) + '</td>';
      html += '<td style="text-align:right;font-weight:bold;">' + tp.totalPageViews + '</td>';
      html += '<td style="text-align:right;">' + tp.totalSessions + '</td>';
      html += '<td style="text-align:right;">' + tp.totalUsers + '</td>';
      html += '<td style="text-align:right;color:' + CATEGORY_COLORS['Organic'] + ';">' + tp.categories['Organic'] + '</td>';
      html += '<td style="text-align:right;color:' + CATEGORY_COLORS['Paid Search'] + ';">' + tp.categories['Paid Search'] + '</td>';
      html += '<td style="text-align:right;color:' + CATEGORY_COLORS['Reference'] + ';">' + tp.categories['Reference'] + '</td>';
      html += '<td style="text-align:right;color:' + CATEGORY_COLORS['From AMD'] + ';">' + tp.categories['From AMD'] + '</td>';
      html += '</tr>';
    }

    html += '</table>';
  }

  // Footer
  html += '<p style="color:#999;font-size:11px;margin-top:24px;">Automated report — AMD Machines website analytics (GA4 property ' + CONFIG.GA4_PROPERTY_ID + ')</p>';
  html += '</div>';

  return html;
}

function summaryCell(label, value, color) {
  return '<td style="text-align:center;padding:12px 8px;background:' + color + ';color:#fff;font-size:14px;">'
    + '<div style="font-size:22px;font-weight:bold;">' + value + '</div>'
    + '<div style="font-size:12px;opacity:0.85;">' + label + '</div>'
    + '</td>';
}

function lighten(category) {
  // Light versions for use on dark header background
  var map = { 'Organic': '#81c784', 'Paid Search': '#ef9a9a', 'Reference': '#90caf9', 'From AMD': '#ce93d8' };
  return map[category] || '#fff';
}

function escapeHtml(text) {
  return String(text)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

// ============ EXCEL REPORT ============

/**
 * Creates a temporary Google Sheet with 3 sheets, exports as XLSX, trashes the Sheet.
 */
function createExcelReport(visitorData, topPagesData, summary, reportDate) {
  var ss = SpreadsheetApp.create('AMD_Analytics_' + reportDate);

  // --- Sheet 1: Visitor Detail ---
  var sheet1 = ss.getActiveSheet();
  sheet1.setName('Visitor Detail');

  var headers1 = ['Source', 'Medium', 'Category', 'Page Path', 'Sessions', 'Page Views'];
  sheet1.getRange(1, 1, 1, headers1.length).setValues([headers1]);
  sheet1.getRange(1, 1, 1, headers1.length).setFontWeight('bold').setBackground('#003087').setFontColor('#ffffff');

  var rows1 = [];
  for (var v = 0; v < visitorData.length; v++) {
    var src = visitorData[v];
    for (var p = 0; p < src.pages.length; p++) {
      rows1.push([src.source, src.medium, src.category, src.pages[p].path, src.pages[p].sessions, src.pages[p].pageViews]);
    }
  }
  if (rows1.length > 0) {
    sheet1.getRange(2, 1, rows1.length, headers1.length).setValues(rows1);
  }
  for (var c1 = 1; c1 <= headers1.length; c1++) { sheet1.autoResizeColumn(c1); }

  // --- Sheet 2: Top 20 Pages ---
  var sheet2 = ss.insertSheet('Top 20 Pages');
  var headers2 = ['Page Path', 'Page Views', 'Sessions', 'Users', 'Organic', 'Paid Search', 'Reference', 'From AMD'];
  sheet2.getRange(1, 1, 1, headers2.length).setValues([headers2]);
  sheet2.getRange(1, 1, 1, headers2.length).setFontWeight('bold').setBackground('#003087').setFontColor('#ffffff');

  var rows2 = [];
  for (var t = 0; t < topPagesData.length; t++) {
    var tp = topPagesData[t];
    rows2.push([tp.pagePath, tp.totalPageViews, tp.totalSessions, tp.totalUsers,
                tp.categories['Organic'], tp.categories['Paid Search'], tp.categories['Reference'], tp.categories['From AMD']]);
  }
  if (rows2.length > 0) {
    sheet2.getRange(2, 1, rows2.length, headers2.length).setValues(rows2);
  }
  for (var c2 = 1; c2 <= headers2.length; c2++) { sheet2.autoResizeColumn(c2); }

  // --- Sheet 3: Summary ---
  var sheet3 = ss.insertSheet('Summary');
  sheet3.getRange('A1').setValue('AMD Machines — Daily Analytics Report').setFontSize(16).setFontWeight('bold');
  sheet3.getRange('A3').setValue('Report Date:'); sheet3.getRange('B3').setValue(reportDate);
  sheet3.getRange('A4').setValue('Total Sessions:'); sheet3.getRange('B4').setValue(summary.totalSessions);
  sheet3.getRange('A5').setValue('Total Page Views:'); sheet3.getRange('B5').setValue(summary.totalPageViews);
  sheet3.getRange('A6').setValue('Total Users:'); sheet3.getRange('B6').setValue(summary.totalUsers);
  sheet3.getRange('A8').setValue('Sessions by Category:').setFontWeight('bold');
  sheet3.getRange('A9').setValue('Organic'); sheet3.getRange('B9').setValue(summary.categoryCounts['Organic']);
  sheet3.getRange('A10').setValue('Paid Search'); sheet3.getRange('B10').setValue(summary.categoryCounts['Paid Search']);
  sheet3.getRange('A11').setValue('Reference'); sheet3.getRange('B11').setValue(summary.categoryCounts['Reference']);
  sheet3.getRange('A12').setValue('From AMD'); sheet3.getRange('B12').setValue(summary.categoryCounts['From AMD']);
  sheet3.getRange('A3:A12').setFontWeight('bold');
  sheet3.autoResizeColumn(1);
  sheet3.autoResizeColumn(2);

  // Export as XLSX
  var url = 'https://docs.google.com/spreadsheets/d/' + ss.getId() + '/export?format=xlsx';
  var token = ScriptApp.getOAuthToken();
  var resp = UrlFetchApp.fetch(url, { headers: { 'Authorization': 'Bearer ' + token } });
  var blob = resp.getBlob().setName('AMD_Analytics_' + reportDate + '.xlsx');

  // Trash the temp spreadsheet
  DriveApp.getFileById(ss.getId()).setTrashed(true);

  return blob;
}

// ============ EMAIL FUNCTIONS ============

function sendReportEmail(htmlBody, excelBlob, reportDate) {
  MailApp.sendEmail({
    to: CONFIG.EMAIL_TO,
    subject: CONFIG.EMAIL_SUBJECT + ' — ' + reportDate,
    htmlBody: htmlBody,
    attachments: [excelBlob]
  });
}

function sendEmptyReport(reportDate) {
  MailApp.sendEmail({
    to: CONFIG.EMAIL_TO,
    subject: CONFIG.EMAIL_SUBJECT + ' — No Data — ' + reportDate,
    htmlBody: '<div style="font-family:Arial,sans-serif;">'
      + '<h2 style="color:#003087;">AMD Machines — Daily Report</h2>'
      + '<p>No visitor data was recorded for <strong>' + reportDate + '</strong>.</p>'
      + '<p>This could mean there were no visitors, or GA4 data is still processing.</p>'
      + '</div>'
  });
}

function sendErrorNotification(error) {
  MailApp.sendEmail({
    to: CONFIG.EMAIL_TO,
    subject: 'AMD Machines Report — ERROR',
    body: 'An error occurred while generating the daily report:\n\n'
      + error.toString() + '\n\n'
      + (error.stack || '')
  });
}

// ============ SETUP ============

/**
 * Run once to schedule the daily trigger at 9 PM Central.
 */
function setupTrigger() {
  // Remove existing triggers for this function
  var triggers = ScriptApp.getProjectTriggers();
  for (var i = 0; i < triggers.length; i++) {
    if (triggers[i].getHandlerFunction() === 'sendDailyReport') {
      ScriptApp.deleteTrigger(triggers[i]);
    }
  }

  ScriptApp.newTrigger('sendDailyReport')
    .timeBased()
    .atHour(21)
    .everyDays(1)
    .inTimezone(CONFIG.TIMEZONE)
    .create();

  Logger.log('Trigger created — daily report at 9 PM Central (' + CONFIG.TIMEZONE + ').');
}

/**
 * Manual test — run this in the Apps Script editor to trigger the report immediately.
 */
function testReport() {
  Logger.log('Running test report...');
  sendDailyReport();
  Logger.log('Test report complete.');
}
