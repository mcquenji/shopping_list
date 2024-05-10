# shopping_list

Shopping list PWA built with Flutter using Cupertino design.

## Contributing

1. Fork it!
2. Once cloned, run `fvm use` to use the correct Flutter version.
3. Modify the code.
4. Open a pull request :D

## Development

### Obtaining Firebase Configuration

1. **Access the Firebase Console**
   Visit the [Firebase Console](https://console.firebase.google.com/) and log in with your Google account.
2. **Add a Web App to Your Project**
    If you haven't already configured a web app in Firebase

    - Click on the "Add app" button and select the web icon (symbol of a globe).
    - Follow the steps to register your app.
3. **Obtain Firebase Configuration**
   - Navigate to "Project settings" via the gear icon next to "Project Overview".
   - Under the "Your apps" section, select your web app to view your Firebase SDK snippet.
   - Find the configuration keys (`apiKey`, `authDomain`, `projectId`, etc.).

### Flutter Web Configuration

To securely incorporate Firebase configuration into your Flutter web project, use `--dart-define` to pass environment variables at build time. This prevents sensitive keys from being exposed in your codebase.

Add these lines to your build command or configure them in your IDE:

```bash
flutter build web \
  --dart-define=FIREBASE_API_KEY=your_firebase_api_key \
  --dart-define=FIREBASE_APP_ID=your_firebase_app_id \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=your_firebase_messaging_sender_id \
  --dart-define=FIREBASE_PROJECT_ID=your_firebase_project_id \
  --dart-define=FIREBASE_AUTH_DOMAIN=your_firebase_auth_domain \
  --dart-define=FIREBASE_STORAGE_BUCKET=your_firebase_storage_bucket \
  --dart-define=FIREBASE_MEASUREMENT_ID=your_firebase_measurement_id
```

Replace `your_firebase_api_key`, `your_firebase_app_id`, etc., with the actual values obtained from Firebase Console.

### Adding Secrets for CI/CD

To integrate Firebase with GitHub Actions for CI/CD:

1. **Navigate to Your Repository Settings**
   - Go to the "Settings" tab of your GitHub repository.

2. **Secrets**
   - Click on "Secrets" and then "New repository secret".

3. **Add Each Firebase Config as a Secret**
   - Add secrets for `FIREBASE_API_KEY`, `FIREBASE_APP_ID`, and other necessary configuration keys.

Use these secrets in your GitHub Actions workflows by referencing them with `${{ secrets.NAME }}` syntax to maintain security and confidentiality of your Firebase project details.
