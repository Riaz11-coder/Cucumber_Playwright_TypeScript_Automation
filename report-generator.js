import { generate } from 'cucumber-html-reporter';

const options = {
  theme: 'bootstrap',
  jsonFile: 'reports/json/cucumber_report.json',
  output: 'reports/html/cucumber_report.html',
  reportSuiteAsScenarios: true,
  launchReport: false,
  metadata: {
    "Browser": "Chrome",
    "Platform": "Mac",
    "Executed": "Jenkins"
  }
};

generate(options);
