import { PlaywrightTestConfig } from "@playwright/test";

const config: PlaywrightTestConfig = {
  testDir: "integration",
  webServer: {
    command: "make start",
    port: 3000,
    timeout: 10000,
    reuseExistingServer: false,
  },
};

export default config;
