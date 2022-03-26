import { render, screen } from "@testing-library/react";
import flagsmith from "flagsmith";
import { FlagsmithProvider } from "flagsmith/react";
import App from "./App";

const Providers = ({ children }: { children: React.ReactNode }) => (
  <FlagsmithProvider flagsmith={flagsmith}>{children}</FlagsmithProvider>
);

test("App shows hello message", () => {
  render(
    <Providers>
      <App />
    </Providers>
  );
  const message = screen.getByText("Hello, world!");
  expect(message).toBeInTheDocument();
});
