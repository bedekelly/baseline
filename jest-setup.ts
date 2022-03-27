import "@testing-library/jest-dom";

jest.mock("flagsmith/react", () => {
  return {
    useFlags: jest
      .fn()
      .mockReturnValue({ background_color: { value: "pink", enabled: true } }),
  };
});
