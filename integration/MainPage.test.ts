import { test, expect } from "@playwright/test";

test("Homepage should display welcome message", async ({ page }) => {
  await page.goto("http://localhost:3000");
  const title = page.locator("h1");
  await expect(title).toHaveText("Hello, world!");
});

test("Error page should be shown when navigating to a nonexistent page", async ({
  page,
}) => {
  await page.goto("/non-existent");
  const title = page.locator("h1");
  await expect(title).toHaveText("Page not found.");
});
