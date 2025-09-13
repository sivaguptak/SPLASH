# 🚨 URGENT: Firebase Phone Auth Setup

## Current Error: "Authentication error (unknown)"

This error means Firebase phone authentication is **NOT properly configured**. Follow these steps exactly:

## Step 1: Enable Phone Authentication in Firebase Console

1. **Go to Firebase Console**: https://console.firebase.google.com/
2. **Select your project**: `knlslocsy-ebf67`
3. **Click "Authentication"** in the left sidebar
4. **Click "Sign-in method"** tab
5. **Find "Phone"** in the providers list
6. **Click "Phone"** → **"Enable"**
7. **Click "Save"**

## Step 2: Get Your SHA-1 Fingerprint (CRITICAL)

Run this command in your project root:

### For Windows (PowerShell):
```powershell
keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

### For Windows (Command Prompt):
```cmd
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

### For Mac/Linux:
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

**Copy the SHA-1 fingerprint** (looks like: `AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD`)

## Step 3: Add SHA-1 to Firebase Console

1. **In Firebase Console** → **Project Settings** (gear icon)
2. **Scroll down** to "Your apps" section
3. **Find your Android app**: `com.example.locsy_skeleton`
4. **Click "Add fingerprint"**
5. **Paste your SHA-1 fingerprint**
6. **Click "Save"**

## Step 4: Add Test Phone Numbers

1. **In Firebase Console** → **Authentication** → **Sign-in method** → **Phone**
2. **Scroll down** to "Phone numbers for testing"
3. **Click "Add phone number"**
4. **Add these test numbers**:
   - Phone: `+919876543210`
   - Code: `123456`
   - Phone: `+919876543211`
   - Code: `654321`

## Step 5: Test Your App

1. **Run your app**
2. **Enter test phone**: `+919876543210`
3. **Enter test OTP**: `123456`
4. **Should work immediately**

## Common Issues & Solutions

### Issue: "App not authorized for phone authentication"
**Solution**: SHA-1 fingerprint not added to Firebase Console

### Issue: "Invalid phone number"
**Solution**: Use E.164 format: `+91XXXXXXXXXX`

### Issue: "Quota exceeded"
**Solution**: Check Firebase Console quotas

### Issue: Still getting "unknown" error
**Solutions**:
1. **Restart your app** after adding SHA-1
2. **Check Firebase Console** for error logs
3. **Verify google-services.json** is up to date
4. **Try test phone numbers** first

## Debug Commands

Add this to your `main.dart` for debugging:

```dart
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Debug Firebase config
  final app = Firebase.app();
  print('🔥 Firebase Project: ${app.options.projectId}');
  print('🔥 Firebase App ID: ${app.options.appId}');
  print('🔥 Firebase API Key: ${app.options.apiKey}');
  
  runApp(const LocsyApp());
}
```

## Verification Checklist

- [ ] Phone authentication enabled in Firebase Console
- [ ] SHA-1 fingerprint added to Firebase Console
- [ ] Test phone numbers configured
- [ ] App restarted after Firebase changes
- [ ] Using test phone numbers for testing

## If Still Not Working

1. **Check Firebase Console** → **Authentication** → **Users** for error logs
2. **Verify your google-services.json** is in `android/app/` folder
3. **Try different phone numbers**
4. **Check Firebase project quotas**

The "unknown" error typically means Firebase Console isn't properly configured. Follow the steps above exactly.
