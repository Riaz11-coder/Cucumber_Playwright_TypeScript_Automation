import { generate } from 'cucumber-html-reporter';

const options = {
  theme: 'bootstrap',
  jsonFile: 'reports/cucumber_report.json',
  output: 'reports/index.html',
  reportSuiteAsScenarios: true,
  launchReport: false,
  metadata: {
    "Browser": "Chrome",
    "Platform": "Mac",
    "Executed": "Jenkins"
  }
};

generate(options);
