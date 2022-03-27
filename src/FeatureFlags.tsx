import flagsmith from "flagsmith";
import { FlagsmithProvider, useFlagsmith } from "flagsmith/react";
import React, { useEffect } from "react";

const FLAGSMITH_INTERVAL_ENV = import.meta.env.VITE_FLAGSMITH_INTERVAL;
const FLAGSMITH_INTERVAL =
  typeof FLAGSMITH_INTERVAL_ENV === "number" ? FLAGSMITH_INTERVAL_ENV : 1000;

function InitializeFlagsmith() {
  const flagsmith = useFlagsmith();

  useEffect(() => {
    (async function setupFlagsmith() {
      await flagsmith.init({
        environmentID: String(import.meta.env.VITE_FLAGSMITH_ENV),
        enableAnalytics: true,
        defaultFlags: {
          background_color: {
            value: "pink",
            enabled: true,
          },
        },
      });

      const shouldPoll = flagsmith.getValue("poll_for_flags");
      console.log(
        `Feature flag polling is: ${
          shouldPoll
            ? "on. Updating every 1000ms."
            : "off. Refresh to see feature changes."
        }`
      );

      if (shouldPoll) {
        flagsmith.startListening(FLAGSMITH_INTERVAL);
      }
    })();
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
