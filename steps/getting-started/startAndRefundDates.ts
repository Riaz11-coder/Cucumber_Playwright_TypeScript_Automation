import { Given, Then, When } from "@cucumber/cucumber";
import { expect} from "@playwright/test";
import { startApplicationPage, page } from "../../globalPagesSetup";
import { productInfo } from "../../utilities/qa-data-reader";

Given('user is on the enrollment page', async function (): Promise<void> {
    await startApplicationPage.login();
});

Then('the program start date is displayed', async function (): Promise<void> {
    await page.pause();
    await expect(startApplicationPage.programStartDate).toBeVisible();
});

Then('the program refund date is displayed', async function (): Promise<void> {
    await expect(startApplicationPage.refundEndDate).toBeVisible();
});

Then('the displayed start date for the program is correct', async function (): Promise<void> {
    const actualStartDate: string = await startApplicationPage.programStartDate.innerText();
    const expectedStartDate: string = productInfo.startDate;
    expect(actualStartDate).toBe(expectedStartDate);
});

Then('the displayed refund date for the program is correct', async function (): Promise<void> {
    const actualRefundDate: string = await startApplicationPage.refundEndDate.innerText();
    const expectedRefundDate: string = productInfo.refundDate;
    expect(actualRefundDate).toBe(expectedRefundDate);
});