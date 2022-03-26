import { test, expect } from '@playwright/test';

test('Browser should be open', async ({ page }) => {
    await page.goto('https://bede.io');
    const title = page.locator('h1');
    await expect(title).toHaveText('Bede Kelly');
})
