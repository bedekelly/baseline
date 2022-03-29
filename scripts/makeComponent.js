const prompts = require("prompts");
const { mkdirSync, writeFileSync } = require("fs");

(async () => {
  const { componentName } = await prompts({
    type: "text",
    name: "componentName",
    message: "Enter component name:",
  });

  if (!componentName) {
    console.log("No new components created; exiting now.");
    return;
  }
  const componentTemplate = `\
type ${componentName}Props = {
  className?: string;
};

export default function ${componentName}({ className }: ${componentName}Props) {
  return <div className={className || ""}>Hello, I'm ${componentName}!</div>;
}
`;

  const unitTestTemplate = `\
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import ${componentName} from "./${componentName}";

test("Error button with classname specified", async () => {
  render(<${componentName} />);
  const component = screen.getByText("Hello, I'm ${componentName}!");
  expect(component).toBeInTheDocument();
});
`;

  const indexTemplate = `\
export { default } from "./${componentName}";
`;

  const storybookTemplate = `\
import ${componentName} from "./${componentName}";
import { ComponentMeta, ComponentStory } from "@storybook/react";

export default {
  component: ${componentName},
  title: "${componentName}",
} as ComponentMeta<typeof ${componentName}>;

const Template: ComponentStory<typeof ${componentName}> = (args) => (
  <${componentName} className={args.className} />
);

export const Default${componentName} = Template.bind({});

Default${componentName}.args = {
  className: "",
};
`;

  mkdirSync(`./src/components/${componentName}`);
  writeFileSync(`./src/components/${componentName}/index.tsx`, indexTemplate);
  writeFileSync(
    `./src/components/${componentName}/${componentName}.tsx`,
    componentTemplate
  );
  writeFileSync(
    `./src/components/${componentName}/${componentName}.test.tsx`,
    unitTestTemplate
  );
  writeFileSync(
    `./src/components/${componentName}/${componentName}.stories.tsx`,
    storybookTemplate
  );

  console.log(`Created src/components/${componentName}!`);
})();
