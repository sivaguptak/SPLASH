# Firebase Phone Authentication Setup Script

## 🚨 CRITICAL: Your app was using the wrong OTP screen!

I found the issue - your app was using the old `OtpVerifyScreen` which is just a stub that always accepts any OTP. I've fixed the routing to use the proper `PhoneOtpFlow`.

## Step-by-Step Firebase Console Setup

### 1. Enable Phone Authentication
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **knlslocsy-ebf67**
3. Click **Authentication** in the left sidebar
4. Click **Sign-in method** tab
5. Find **Phone** in the providers list
6. Click **Phone** → **Enable**
7. Click **Save**

### 2. Get Your SHA-1 Fingerprint
Run this command in your project root:

```bash
# For Windows (PowerShell)
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

# For Mac/Linux
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

**Copy the SHA-1 fingerprint** (it looks like: `AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD`)

### 3. Add SHA-1 to Firebase Console
1. In Firebase Console, go to **Project Settings** (gear icon)
2. Scroll down to **Your apps** section
3. Find your Android app: **com.example.locsy_skeleton**
4. Click **Add fingerprint**
5. Paste your SHA-1 fingerprint
6. Click **Save**

### 4. Test Phone Numbers (IMPORTANT for Development)
1. In Firebase Console → **Authentication** → **Sign-in method** → **Phone**
2. Scroll down to **Phone numbers for testing**
3. Click **Add phone number**
4. Add test numbers like:
   - Phone: `+919876543210`
   - Code: `123456`
   - Phone: `+919876543211` 
   - Code: `654321`

### 5. Check Firebase Project Quotas
1. In Firebase Console → **Authentication** → **Usage**
2. Check if you have SMS quota remaining
3. If quota is exceeded, wait 24 hours or upgrade plan

## Testing Your Setup

### Test 1: Use Test Phone Number
1. Run your app
2. Enter a test phone number: `+919876543210`
3. Enter the test OTP: `123456`
4. Should work immediately (no real SMS sent)

### Test 2: Use Real Phone Number
1. Enter your real phone number: `+91XXXXXXXXXX`
2. Wait for real SMS (can take 1-2 minutes)
3. Enter the 6-digit OTP from SMS

## Common Issues & Solutions

### Issue: "App not authorized for phone authentication"
**Solution**: Add SHA-1 fingerprint to Firebase Console

### Issue: "Invalid phone number"
**Solution**: Use E.164 format: `+91XXXXXXXXXX`

### Issue: "Quota exceeded"
**Solution**: 
- Check Firebase Console quotas
- Use test phone numbers for development
- Wait for quota reset (24 hours)

### Issue: No SMS received
**Solutions**:
1. Check if phone number is in test list
2. Verify network connectivity
3. Check spam/junk folder
4. Try different phone number
5. Check Firebase Console for error logs

### Issue: Wrong OTP accepted
**Solution**: ✅ FIXED - App now uses proper Firebase verification

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
  
  runApp(const LocsyApp());
}
```

## Verification Checklist

- [ ] Phone authentication enabled in Firebase Console
- [ ] SHA-1 fingerprint added to Firebase Console
- [ ] Test phone numbers configured
- [ ] App uses `PhoneOtpFlow` (not old `OtpVerifyScreen`)
- [ ] Firebase project has SMS quota
- [ ] `google-services.json` is up to date

## Next Steps

1. **Configure Firebase Console** (most important)
2. **Test with test phone numbers first**
3. **Test with real phone numbers**
4. **Check console logs for errors**

The code fixes are complete. The main issue was using the wrong OTP screen. Now you need to configure Firebase Console properly.
