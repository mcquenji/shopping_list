/// Contains API keys and configurations for Firebase services.
library config.firebase;

/// The Firebase API key used to initialize communication with Firebase services.
///
/// This key is loaded from the environment variable `FIREBASE_API_KEY`.
/// If the environment variable is not set, the default value is an empty string.
///
/// See also:
///   - [isFirebaseConfigured]
///   - [assertFirebaseConfigured]
const kFirebaseApiKey = String.fromEnvironment(
  "FIREBASE_API_KEY",
  defaultValue: "",
);

/// The Firebase Application ID associated with your Firebase project.
///
/// This ID is essential for the initialization and configuration of your Firebase application.
/// It is retrieved from the environment variable `FIREBASE_APP_ID`.
/// If the environment variable is not set, it defaults to an empty string.
///
/// See also:
///   - [isFirebaseConfigured]
///   - [assertFirebaseConfigured]
const kFirebaseAppId = String.fromEnvironment(
  "FIREBASE_APP_ID",
  defaultValue: "",
);

/// The sender ID used by Firebase Cloud Messaging to send notifications.
///
/// This ID identifies the sender of the messages and is crucial for message delivery.
/// It is sourced from the environment variable `FIREBASE_MESSAGING_SENDER_ID`.
/// If not provided, it defaults to an empty string.
///
/// See also:
///   - [isFirebaseConfigured]
///   - [assertFirebaseConfigured]
const kFirebaseMessagingSenderId = String.fromEnvironment(
  "FIREBASE_MESSAGING_SENDER_ID",
  defaultValue: "",
);

/// The project ID for your Firebase project.
///
/// This ID uniquely identifies your Firebase project across all Firebase services.
/// It is obtained from the environment variable `FIREBASE_PROJECT_ID`.
/// Defaults to an empty string if the environment variable is missing.
///
/// See also:
///   - [isFirebaseConfigured]
///   - [assertFirebaseConfigured]
const kFirebaseProjectId = String.fromEnvironment(
  "FIREBASE_PROJECT_ID",
  defaultValue: "",
);

/// The authentication domain for Firebase Authentication.
///
/// This domain is used to authenticate users and must be correctly configured.
/// It is taken from the environment variable `FIREBASE_AUTH_DOMAIN`.
/// If the environment variable is absent, the default value is an empty string.
///
/// See also:
///   - [isFirebaseConfigured]
///   - [assertFirebaseConfigured]
const kFirebaseAuthDomain = String.fromEnvironment(
  "FIREBASE_AUTH_DOMAIN",
  defaultValue: "",
);

/// The Firebase Storage bucket name.
///
/// This bucket is used for storing files in Firebase Storage.
/// It is configured through the environment variable `FIREBASE_STORAGE_BUCKET`.
/// Defaults to an empty string if not specified.
///
/// See also:
///   - [isFirebaseConfigured]
///   - [assertFirebaseConfigured]
const kFirebaseStorageBucket = String.fromEnvironment(
  "FIREBASE_STORAGE_BUCKET",
  defaultValue: "",
);

/// The measurement ID for Firebase Analytics.
///
/// This ID is used to integrate Firebase Analytics into your application.
/// It is pulled from the environment variable `FIREBASE_MEASUREMENT_ID`.
/// If not set, the default value is an empty string.
///
/// See also:
///   - [isFirebaseConfigured]
///   - [assertFirebaseConfigured]
const kFirebaseMeasurementId = String.fromEnvironment(
  "FIREBASE_MEASUREMENT_ID",
  defaultValue: "",
);

/// Checks if all required Firebase configuration values are set.
///
/// Returns `true` if all configuration constants from the environment variables are not empty,
/// indicating that Firebase has been configured. It evaluates:
///   - [kFirebaseApiKey]
///   - [kFirebaseAppId]
///   - [kFirebaseMessagingSenderId]
///   - [kFirebaseProjectId]
///   - [kFirebaseAuthDomain]
///   - [kFirebaseStorageBucket]
///   - [kFirebaseMeasurementId]
/// Otherwise, it returns `false`.
///
/// NOTE: This does not validate the correctness of the values, only their presence.
///
/// See also:
///   - [assertFirebaseConfigured]
bool get isFirebaseConfigured {
  return kFirebaseApiKey.isNotEmpty &&
      kFirebaseAppId.isNotEmpty &&
      kFirebaseMessagingSenderId.isNotEmpty &&
      kFirebaseProjectId.isNotEmpty &&
      kFirebaseAuthDomain.isNotEmpty &&
      kFirebaseStorageBucket.isNotEmpty &&
      kFirebaseMeasurementId.isNotEmpty;
}

/// Asserts that Firebase is configured.
///
/// Throws an [AssertionError] if any of the Firebase configuration values are missing.
/// This method should be called during initialization to ensure that all necessary
/// Firebase environment variables have been set, preventing runtime errors due to misconfiguration.
///
/// NOTE: This does not validate the correctness of the values, only their presence.
///
/// See also:
///  - [isFirebaseConfigured]
void assertFirebaseConfigured() {
  assert(isFirebaseConfigured, """
  Firebase has not been configured.
  Please set the following environment variables:
  FIREBASE_API_KEY
  FIREBASE_APP_ID
  FIREBASE_MESSAGING_SENDER_ID
  FIREBASE_PROJECT_ID
  FIREBASE_AUTH_DOMAIN
  FIREBASE_STORAGE_BUCKET
  FIREBASE_MEASUREMENT_ID
  """);
}
