import { useFlags } from "flagsmith/react";

export default function MainPage() {
  const flags = useFlags(["background_color"]);
  const backgroundColor = `${flags.background_color.value || "#000"}`;
  return (
    <div
      className={`h-screen flex flex-col items-center justify-center`}
      style={{ backgroundColor }}
    >
      <h1 className="text-white text-mono text-5xl font-black text-center font-mono">
        Hello, world!
      </h1>
    </div>
  );
}
