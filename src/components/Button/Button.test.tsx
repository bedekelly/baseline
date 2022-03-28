import { logDOM, render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import Button from "./Button";

test("Error button with classname specified", async () => {
  const onClick = jest.fn();
  render(
    <Button className="bg-pink-100" onClick={onClick}>
      Click Me
    </Button>
  );
  const button = screen.getByRole("button", { name: "Click Me" });
  expect(button).toHaveClass("bg-pink-100");
  expect(button).toHaveClass("font-black");
  userEvent.click(button);
  expect(onClick).toHaveBeenCalledTimes(1);
});

test("Error button with no classname", async () => {
  const onClick = jest.fn();
  render(<Button onClick={onClick}>Click Me</Button>);
  const button = screen.getByRole("button", { name: "Click Me" });
  expect(button).toHaveClass("bg-black");
  expect(button).toHaveClass("text-white");
});
