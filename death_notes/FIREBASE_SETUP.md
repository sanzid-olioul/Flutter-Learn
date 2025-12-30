# Firebase Setup Guide for Death Notes App

## Checklist to Fix "Internal Error" Issues

### 1. Enable Authentication in Firebase Console
- Go to https://console.firebase.google.com
- Select your project: **death-notes-786**
- Go to **Authentication** (left sidebar)
- Click **Get started**
- Enable **Email/Password** provider
- Make sure status shows "Enabled" (green checkmark)

### 2. Enable Firestore Database
- Go to **Firestore Database** (left sidebar)
- Click **Create database**
- Start in **Test mode** (for development)
- Choose location: **us-central1** or nearest to you
- Click **Create**

### 3. Create Firestore Collection
- In Firestore, click **Create collection**
- Name it: `death_notes`
- Add a document with sample data or leave empty
- Click **Save**

### 4. Check Bundle ID Matches
iOS Bundle ID must match Firebase configuration:
- **Expected:** `com.example.deathNotes`
- Check in: iOS > Runner.xcodeproj > Build Settings > Product Bundle Identifier

### 5. Verify Network Connection
When testing on iOS Simulator:
- Simulator inherits your Mac's internet connection
- Ensure your Mac is connected to internet
- Restart Simulator if needed: **Cmd + Q**, then re-run

### 6. Clear Cache & Rebuild
Run these commands:
```bash
flutter clean
flutter pub get
flutter run
```

### Common Error Messages & Solutions

| Error | Solution |
|-------|----------|
| `[firebase_auth/internal-error]` | Enable Email/Password authentication in Firebase Console |
| `No internet connection` | Check Mac's internet, restart Simulator |
| `Project not found` | Verify project ID is `death-notes-786` in firebase_options.dart |
| `Permission denied` | Firestore is likely in production mode, set to test mode |

### Testing Registration
1. Click "Register" on login screen
2. Enter: `test@example.com` and `password123`
3. Check for success message or detailed error
4. Error messages will show exact issue

### Troubleshooting Steps
1. **Check Firebase Console Logs**
   - Go to Firebase Console
   - Click on Logs icon (right side)
   - Filter for your email
   - Look for error details

2. **Enable Console Logging**
   - Errors are logged to Xcode console
   - Open Xcode: `open ios/Runner.xcworkspace`
   - Run and check Console output

3. **Test with Different Email**
   - Try: `user@gmail.com` with a stronger password
   - Use format: email@domain.com

### Android Additional Step
If testing on Android Emulator:
- GoogleService-Info.plist (iOS only)
- Check `android/app/google-services.json` exists instead
