import MainPage from "./MainPage";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import React, { Suspense } from "react";
const PageNotFound = React.lazy(() => import("./PageNotFound"));

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<MainPage />} />
        <Route
          path="*"
          element={
            <Suspense fallback={<div>Loading...</div>}>
              <PageNotFound />
            </Suspense>
          }
        />
      </Routes>
    </BrowserRouter>
  );
}
