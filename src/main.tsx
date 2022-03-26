import React from "react";
import ReactDOM from "react-dom";
import "./index.css";
import App from "./App";
import FeatureFlags from "./FeatureFlags";

ReactDOM.render(
  <React.StrictMode>
    <FeatureFlags>
      <App />
    </FeatureFlags>
  </React.StrictMode>,
  document.getElementById("root")
);
