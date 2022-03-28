import Button from "./Button";
import { ComponentMeta, ComponentStory } from "@storybook/react";

export default {
  component: Button,
  title: "Button",
  argTypes: { onClick: { action: "clicked" } },
} as ComponentMeta<typeof Button>;

const Template: ComponentStory<typeof Button> = (args) => (
  <Button onClick={args.onClick} className={args.className}>
    {args.children}
  </Button>
);

export const Standard = Template.bind({});

Standard.args = {
  children: "Click me!",
  className: "hover:bg-gray-200",
};
