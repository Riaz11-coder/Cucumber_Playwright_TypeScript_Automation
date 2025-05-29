/**
 * Cucumber.js configuration for running TypeScript-based tests
 */
module.exports = {
  default: {

    // Run tests in parallel using 2 workers
    parallel: 2,

    // Location of feature files
    paths: ["./features/**/*.feature"],

    // Modules to load before tests (TypeScript support)
    requireModule: ['ts-node/register'],

    // Location of step definitions and hooks
    require: ["./steps/**/*.ts", "./hooks/**/*.ts"],

    // Output formats: console, JSON, and HTML reports
    format: [
      "progress-bar",
      "json:reports/cucumber-report.json",
      "html:reports/cucumber-report.html",
    ],

    // Use async/await style in generated snippets
    formatOptions: {
      snippetInterface: "async-await"
    },

    // Make all environment variables available in world context
    worldParameters: {
      ...process.env,
    },
  },
}
