import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { MemoryRouter } from "react-router-dom";
import MainPage from "./MainPage";
import throwError from "./throwError";
import { useFlags } from "flagsmith/react";

const { useFlags: realUseFlags } = jest.requireActual("flagsmith/react");
const mockUseFlags = useFlags as jest.MockedFunction<typeof realUseFlags>;

jest.mock("flagsmith/react", () => {
  return {
    useFlags: jest
      .fn()
      .mockReturnValue({ background_color: { value: "pink", enabled: true } }),
  };
});

jest.mock("./throwError", () => jest.fn());

test("Error button", async () => {
  render(
    <MemoryRouter>
      <MainPage />
    </MemoryRouter>
  );
  const button = screen.getByRole("button", {
    name: "Click me to throw an error.",
  });
  userEvent.click(button);
  expect(throwError).toHaveBeenCalledTimes(1);
});

test("Feature flag background color", () => {
  render(
    <MemoryRouter>
      <MainPage />
    </MemoryRouter>
  );
  const bg = screen.getByTestId("main-page-wrapper");
  expect(bg).toHaveStyle({ backgroundColor: "pink" });
});

test("Default background color for empty flags", () => {
  mockUseFlags.mockReturnValue({
    background_color: { value: "", enabled: true },
  });
  render(
    <MemoryRouter>
      <MainPage />
    </MemoryRouter>
  );
  const bg = screen.getByTestId("main-page-wrapper");
  expect(bg).toHaveStyle({ backgroundColor: "#000" });
});

test("Default background color for disabled flags", () => {
  mockUseFlags.mockReturnValue({
    background_color: { value: "pink", enabled: false },
  });
  render(
    <MemoryRouter>
      <MainPage />
    </MemoryRouter>
  );
  const bg = screen.getByTestId("main-page-wrapper");
  expect(bg).toHaveStyle({ backgroundColor: "#000" });
});
