/**
 * AMD Machines - Daily GA4 Analytics Report
 *
 * This script queries Google Analytics 4 and sends a daily email report
 * with visitor data in Excel format.
 *
 * SETUP INSTRUCTIONS:
 * 1. Go to script.google.com and create a new project
 * 2. Paste this entire code
 * 3. Update the CONFIG section below with your values
 * 4. Click "Run" > "setupTrigger" to schedule daily emails at 9pm EST
 * 5. Authorize the script when prompted
 */

// ============ CONFIGURATION ============
const CONFIG = {
  GA4_PROPERTY_ID: '520875139',
  EMAIL_TO: 'je@amdmachines.com',
  EMAIL_SUBJECT: 'AMD Machines - Daily Visitor Report',
  TIMEZONE: 'America/New_York'
};

// ============ MAIN FUNCTIONS ============

/**
 * Main function to generate and send the daily report
 */
function sendDailyReport() {
  try {
    // Get yesterday's date range (last 24 hours of completed data)
    const today = new Date();
    const yesterday = new Date(today);
    yesterday.setDate(yesterday.getDate() - 1);

    const startDate = Utilities.formatDate(yesterday, CONFIG.TIMEZONE, 'yyyy-MM-dd');
    const endDate = Utilities.formatDate(yesterday, CONFIG.TIMEZONE, 'yyyy-MM-dd');

    // Fetch analytics data
    const reportData = fetchGA4Data(startDate, endDate);

    if (!reportData || reportData.length === 0) {
      sendEmptyReport(startDate);
      return;
    }

    // Create Excel file
    const excelBlob = createExcelReport(reportData, startDate);

    // Send email
    sendReportEmail(excelBlob, startDate, reportData.length);

    Logger.log('Daily report sent successfully for ' + startDate);

  } catch (error) {
    Logger.log('Error sending daily report: ' + error.toString());
    sendErrorNotification(error);
  }
}

/**
 * Fetch data from GA4 using the Analytics Data API
 */
function fetchGA4Data(startDate, endDate) {
  const propertyId = CONFIG.GA4_PROPERTY_ID;

  // Build the request
  const request = AnalyticsData.newRunReportRequest();

  // Date range
  const dateRange = AnalyticsData.newDateRange();
  dateRange.startDate = startDate;
  dateRange.endDate = endDate;
  request.dateRanges = [dateRange];

  // Dimensions (what we want to group by)
  request.dimensions = [
    { name: 'sessionSource' },           // Traffic source
    { name: 'sessionMedium' },           // Medium (organic, cpc, etc.)
    { name: 'pagePath' },                // Page visited
    { name: 'deviceCategory' },          // Desktop/Mobile/Tablet
    { name: 'country' },                 // Country
    { name: 'city' }                     // City
  ];

  // Metrics (what we want to measure)
  request.metrics = [
    { name: 'sessions' },                // Number of sessions
    { name: 'totalUsers' },              // Number of users
    { name: 'screenPageViews' },         // Page views
    { name: 'averageSessionDuration' },  // Avg time on site
    { name: 'bounceRate' },              // Bounce rate
    { name: 'engagementRate' },          // Engagement rate
    { name: 'scrolledUsers' }            // Users who scrolled
  ];

  // Order by sessions descending
  const orderBy = AnalyticsData.newOrderBy();
  orderBy.desc = true;
  const metricOrderBy = AnalyticsData.newMetricOrderBy();
  metricOrderBy.metricName = 'sessions';
  orderBy.metric = metricOrderBy;
  request.orderBys = [orderBy];

  // Limit results
  request.limit = 1000;

  // Execute the request
  const response = AnalyticsData.Properties.runReport(request, 'properties/' + propertyId);

  // Parse the response
  const rows = response.rows || [];
  const data = [];

  for (const row of rows) {
    data.push({
      source: row.dimensionValues[0].value,
      medium: row.dimensionValues[1].value,
      pagePath: row.dimensionValues[2].value,
      device: row.dimensionValues[3].value,
      country: row.dimensionValues[4].value,
      city: row.dimensionValues[5].value,
      sessions: parseInt(row.metricValues[0].value),
      users: parseInt(row.metricValues[1].value),
      pageViews: parseInt(row.metricValues[2].value),
      avgDuration: parseFloat(row.metricValues[3].value).toFixed(2),
      bounceRate: (parseFloat(row.metricValues[4].value) * 100).toFixed(1) + '%',
      engagementRate: (parseFloat(row.metricValues[5].value) * 100).toFixed(1) + '%',
      scrolledUsers: parseInt(row.metricValues[6].value)
    });
  }

  return data;
}

/**
 * Create an Excel file from the report data
 */
function createExcelReport(data, reportDate) {
  // Create a new spreadsheet
  const ss = SpreadsheetApp.create('AMD_Automation_Report_' + reportDate);
  const sheet = ss.getActiveSheet();
  sheet.setName('Visitor Report');

  // Headers
  const headers = [
    'Source', 'Medium', 'Page Path', 'Device', 'Country', 'City',
    'Sessions', 'Users', 'Page Views', 'Avg Duration (sec)',
    'Bounce Rate', 'Engagement Rate', 'Scrolled Users'
  ];

  // Add header row
  sheet.getRange(1, 1, 1, headers.length).setValues([headers]);
  sheet.getRange(1, 1, 1, headers.length)
    .setFontWeight('bold')
    .setBackground('#1574c4')
    .setFontColor('white');

  // Add data rows
  const rows = data.map(d => [
    d.source, d.medium, d.pagePath, d.device, d.country, d.city,
    d.sessions, d.users, d.pageViews, d.avgDuration,
    d.bounceRate, d.engagementRate, d.scrolledUsers
  ]);

  if (rows.length > 0) {
    sheet.getRange(2, 1, rows.length, headers.length).setValues(rows);
  }

  // Auto-resize columns
  for (let i = 1; i <= headers.length; i++) {
    sheet.autoResizeColumn(i);
  }

  // Add summary sheet
  const summarySheet = ss.insertSheet('Summary');
  summarySheet.getRange('A1').setValue('AMD Machines - Daily Analytics Report');
  summarySheet.getRange('A1').setFontSize(16).setFontWeight('bold');
  summarySheet.getRange('A3').setValue('Report Date:');
  summarySheet.getRange('B3').setValue(reportDate);
  summarySheet.getRange('A4').setValue('Total Sessions:');
  summarySheet.getRange('B4').setValue(data.reduce((sum, d) => sum + d.sessions, 0));
  summarySheet.getRange('A5').setValue('Total Users:');
  summarySheet.getRange('B5').setValue(data.reduce((sum, d) => sum + d.users, 0));
  summarySheet.getRange('A6').setValue('Total Page Views:');
  summarySheet.getRange('B6').setValue(data.reduce((sum, d) => sum + d.pageViews, 0));
  summarySheet.getRange('A3:A6').setFontWeight('bold');

  // Convert to Excel blob
  const url = 'https://docs.google.com/spreadsheets/d/' + ss.getId() + '/export?format=xlsx';
  const token = ScriptApp.getOAuthToken();
  const response = UrlFetchApp.fetch(url, {
    headers: { 'Authorization': 'Bearer ' + token }
  });

  const blob = response.getBlob().setName('AMD_Automation_Report_' + reportDate + '.xlsx');

  // Delete the temporary spreadsheet
  DriveApp.getFileById(ss.getId()).setTrashed(true);

  return blob;
}

/**
 * Send the report via email
 */
function sendReportEmail(excelBlob, reportDate, rowCount) {
  const subject = CONFIG.EMAIL_SUBJECT + ' - ' + reportDate;

  const htmlBody = `
    <div style="font-family: Arial, sans-serif; max-width: 600px;">
      <h2 style="color: #1574c4;">AMD Machines - Daily Visitor Report</h2>
      <p>Please find attached the visitor analytics report for <strong>${reportDate}</strong>.</p>

      <h3>Quick Summary</h3>
      <p>Total data rows: <strong>${rowCount}</strong></p>

      <h3>Report Contents</h3>
      <ul>
        <li>Traffic sources and mediums</li>
        <li>Pages visited</li>
        <li>Time on site (average session duration)</li>
        <li>Scroll and engagement data</li>
        <li>Device, country, and city breakdown</li>
      </ul>

      <p style="color: #666; font-size: 12px; margin-top: 30px;">
        This is an automated report from AMD Machines website analytics.
      </p>
    </div>
  `;

  MailApp.sendEmail({
    to: CONFIG.EMAIL_TO,
    subject: subject,
    htmlBody: htmlBody,
    attachments: [excelBlob]
  });
}

/**
 * Send notification when no data is available
 */
function sendEmptyReport(reportDate) {
  MailApp.sendEmail({
    to: CONFIG.EMAIL_TO,
    subject: CONFIG.EMAIL_SUBJECT + ' - No Data - ' + reportDate,
    htmlBody: `
      <div style="font-family: Arial, sans-serif;">
        <h2 style="color: #1574c4;">AMD Machines - Daily Report</h2>
        <p>No visitor data was recorded for <strong>${reportDate}</strong>.</p>
        <p>This could mean there were no visitors, or GA4 data is still processing.</p>
      </div>
    `
  });
}

/**
 * Send error notification
 */
function sendErrorNotification(error) {
  MailApp.sendEmail({
    to: CONFIG.EMAIL_TO,
    subject: 'AMD Machines Report - ERROR',
    body: 'An error occurred while generating the daily report:\n\n' + error.toString()
  });
}

// ============ SETUP FUNCTIONS ============

/**
 * Set up the daily trigger to run at 9 PM EST
 * Run this function ONCE to set up the schedule
 */
function setupTrigger() {
  // Delete any existing triggers
  const triggers = ScriptApp.getProjectTriggers();
  for (const trigger of triggers) {
    if (trigger.getHandlerFunction() === 'sendDailyReport') {
      ScriptApp.deleteTrigger(trigger);
    }
  }

  // Create new trigger for 9 PM EST (21:00)
  ScriptApp.newTrigger('sendDailyReport')
    .timeBased()
    .atHour(21)
    .everyDays(1)
    .inTimezone('America/New_York')
    .create();

  Logger.log('Trigger set up successfully! Daily report will be sent at 9 PM EST.');
}

/**
 * Test function - run this to test the report manually
 */
function testReport() {
  sendDailyReport();
}
