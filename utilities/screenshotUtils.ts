import { Page } from "@playwright/test";
import fs from "fs";
import path from "path";

const screenshotsDir = path.join(process.cwd(), "reports", "screenshots");

/**
 * Clears the screenshots folder before a new test run.
 */
export function clearScreenshots(): void {
  if (fs.existsSync(screenshotsDir)) {
    fs.rmSync(screenshotsDir, { recursive: true, force: true });
    console.log("✅ Old screenshots deleted");
  }
  fs.mkdirSync(screenshotsDir, { recursive: true });
}

/**
 * Captures a screenshot of the current page.
 */
export async function takeScreenshot(
  page: Page | undefined,
  scenarioName: string
): Promise<void> {
  if (!page) {
    console.warn("Page object not available, skipping screenshot");
    return;
  }

  const currentDateTime = new Date()
    .toISOString()
    .replace(/[:T.]/g, "_")
    .slice(0, -5);

  const fileName = `${scenarioName.replace(/\s+/g, "_")}_${currentDateTime}.png`;
  const filePath = path.join(screenshotsDir, fileName);

  try {
    await page.screenshot({ path: filePath, fullPage: true });
    console.log(`📸 Screenshot saved: ${filePath}`);
  } catch (err) {
    console.warn("Failed to take screenshot:", err);
  }
}