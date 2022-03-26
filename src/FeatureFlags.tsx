import flagsmith from "flagsmith";
import { FlagsmithProvider, useFlagsmith } from "flagsmith/react";
import React, { useEffect } from "react";

function InitializeFlagsmith() {
  const flagsmith = useFlagsmith();

  useEffect(() => {
    flagsmith.init({
      environmentID: String(import.meta.env.VITE_FLAGSMITH_ENV),
      enableAnalytics: true,
      defaultFlags: {
        background_color: {
          value: "pink",
          enabled: true,
        },
      },
    });

    // Todo: is there an event for when flagsmith initialises?
    setTimeout(() => {
      const shouldPoll = flagsmith.getValue("poll_for_flags");
      console.log(
        `Feature flag polling is: ${
          shouldPoll
            ? "on. Updating every 1000ms."
            : "off. Refresh to see feature changes."
        }`
      );
      if (shouldPoll) {
        flagsmith.startListening(1000);
      }
    }, 1000);
  }, []);
  return null;
}

export default function FeatureFlags({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <FlagsmithProvider flagsmith={flagsmith}>
      <InitializeFlagsmith />
      {children}
    </FlagsmithProvider>
  );
}
