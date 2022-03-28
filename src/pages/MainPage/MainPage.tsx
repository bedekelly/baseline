import { useFlags } from "flagsmith/react";
import { Link } from "react-router-dom";
import Button from "~/components/Button";
import throwError from "./throwError";

export default function MainPage() {
  const flags = useFlags(["background_color"]);
  const backgroundColor = `${
    (flags.background_color.enabled && flags.background_color.value) || "#000"
  }`;
  return (
    <div
      className={`h-screen flex flex-col items-center justify-center`}
      data-testid="main-page-wrapper"
      style={{ backgroundColor }}
    >
      <h1 className="text-white text-mono text-5xl font-black text-center font-mono">
        Hello, world!
      </h1>

      <Button
        onClick={throwError}
        className="bg-white text-black hover:bg-black hover:text-white"
      >
        Click me to throw an error.
      </Button>
      <Link
        className="text-black cursor-pointer text-mono hover:bg-black hover:text-white px-5 mt-5 py-2 text-3xl font-black text-center rounded-md bg-white"
        to="/asdf"
      >
        Go to 404 page.
      </Link>
    </div>
  );
}
