// ===============================================================
// FILE: lib/main.dart
// PURPOSE: App entry + MaterialApp routes. No business logic.
// ===============================================================

import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'app.dart';

// BEGIN screens (existing)
import 'features/auth/screens/splash_gate.dart';
import 'features/auth/screens/role_select.dart';
import 'features/dashboard_user/screens/dashboard_user.dart';
import 'features/dashboard_shop/screens/dashboard_shop.dart';
import 'features/dashboard_admin/screens/dashboard_admin.dart';
import 'features/offers/screens/create_offer.dart';
import 'features/offers/screens/my_offers.dart';
import 'features/distribution/screens/distribute.dart';
import 'features/redeem/screens/redeem.dart';
import 'features/wallet/screens/wallet.dart';
// END screens (existing)

import 'package:firebase_core/firebase_core.dart';

// BEGIN screens (new)
import 'features/auth/screens/auth_choice.dart';
import 'features/auth/screens/login_phone.dart';
import 'features/auth/screens/otp_verify.dart';
// END screens (new)

// BEGIN firebase_init_in_main
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // loads android/app/google-services.json
  runApp(const LocsyApp());
}
// END firebase_init_in_main

class LocsyApp extends StatelessWidget {
  const LocsyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOCSY Coupons',
      debugShowCheckedModeBanner: false,
      theme: LocsyTheme.light,

      // BEGIN routes
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash:     (_) => const SplashGate(),
        AppRoutes.authChoice: (_) => const AuthChoiceScreen(),  // NEW landing after splash
        AppRoutes.phoneOtp:   (_) => const LoginPhoneScreen(),  // NEW phone entry + OTP button
        AppRoutes.roleSelect: (_) => const RoleSelectScreen(),
        AppRoutes.userDash:   (_) => const DashboardUserScreen(),
        AppRoutes.shopDash:   (_) => const DashboardShopScreen(),
        AppRoutes.adminDash:  (_) => const DashboardAdminScreen(),
        AppRoutes.createOffer:(_) => const CreateOfferScreen(),
        AppRoutes.myOffers:   (_) => const MyOffersScreen(),
        AppRoutes.distribute: (_) => const DistributeScreen(),
        AppRoutes.redeem:     (_) => const RedeemScreen(),
        AppRoutes.wallet:     (_) => const WalletScreen(),
        // we still wire OTP verify as a named screen, used by LoginPhoneScreen
        '/auth/otp-verify':   (_) => const OtpVerifyScreen(),   // internal step
      },
      onUnknownRoute: (_) => MaterialPageRoute(builder: (_) => const SplashGate()),
      // END routes
    );
  }
}
