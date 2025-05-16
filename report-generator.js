import { generate } from 'multiple-cucumber-html-reporter';

generate({
  jsonDir: 'reports',
  reportPath: 'reports/html',
  metadata:{
    browser: {
      name: 'chrome',
      version: '120'
    },
    device: 'Jenkins Node',
    platform: {
      name: 'macOS',
      version: 'Ventura'
    }
  },
  customData: {
    title: 'Run Info',
    data: [
      { label: 'Project', value: 'SEP Automation' },
      { label: 'Release', value: '1.0.0' },
      { label: 'Cycle', value: 'Regression' },
      { label: 'Execution Start Time', value: new Date().toLocaleString() },
      { label: 'Execution End Time', value: new Date().toLocaleString() }
    ]
  }
});

