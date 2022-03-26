import { render, screen } from "@testing-library/react";
import App from "./App";

test("App shows hello message", () => {
  render(<App />);
  const message = screen.getByText("Hello, world!");
  expect(message).toBeInTheDocument();
});
