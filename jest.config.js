module.exports = {
  testEnvironment: "jsdom",
  setupFilesAfterEnv: ["<rootDir>/jest-setup.ts"],
  testPathIgnorePatterns: ["integration"],
  moduleNameMapper: {
    "^~/(.*)$": "<rootDir>/src/$1",
  },
};
