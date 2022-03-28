import { overrideTailwindClasses as tw } from "tailwind-override";
import { ButtonHTMLAttributes } from "react";

type ButtonProps = ButtonHTMLAttributes<HTMLButtonElement>;

export const buttonStyles = `
  cursor-pointer
  hover:bg-white hover:text-black
  px-5 py-2 mt-5 
  text-white
  text-3xl 
  font-black 
  text-center
  rounded-md 
  bg-black
`;

export default function Button({ children, className, ...props }: ButtonProps) {
  return (
    <button {...props} className={tw(`${buttonStyles} ${className || ""}`)}>
      {children}
    </button>
  );
}
