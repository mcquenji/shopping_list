/// Contains general configurations for the app.
library confgig.general;

/// The name of the app.
/// Defaults to "McQuenji's Shopping List".
///
/// This value can be overridden by setting the `APP_NAME` environment variable.
const kAppName = String.fromEnvironment(
  "APP_NAME",
  defaultValue: "Shopping List",
);
