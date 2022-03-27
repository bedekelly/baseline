import { PlaywrightTestConfig } from "@playwright/test";

const config: PlaywrightTestConfig = {
  testDir: "integration",
  webServer: {
    command: "make serve-existing",
    port: 3000,
    timeout: 20 * 1000,
    reuseExistingServer: true,
  },
};

export default config;
