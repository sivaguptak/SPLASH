// ===============================================================
// FILE: lib/main.dart
// PURPOSE: App entry + MaterialApp routes. No business logic.
// ===============================================================

// Core
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:locsy_skeleton/core/theme.dart';
import 'package:locsy_skeleton/app.dart';

// Screens (existing)
import 'package:locsy_skeleton/features/auth/screens/splash_gate.dart';
import 'package:locsy_skeleton/features/auth/screens/role_select.dart';
import 'package:locsy_skeleton/features/dashboard_user/screens/dashboard_user.dart';
import 'package:locsy_skeleton/features/dashboard_shop/screens/dashboard_shop.dart';
import 'package:locsy_skeleton/features/dashboard_admin/screens/dashboard_admin.dart';
import 'package:locsy_skeleton/features/offers/screens/create_offer.dart';
import 'package:locsy_skeleton/features/offers/screens/my_offers.dart';
import 'package:locsy_skeleton/features/distribution/screens/distribute.dart';
import 'package:locsy_skeleton/features/redeem/screens/redeem.dart';
import 'package:locsy_skeleton/features/wallet/screens/wallet.dart';

// Screens (new)
import 'package:locsy_skeleton/features/auth/screens/auth_choice.dart';
import 'package:locsy_skeleton/features/auth/screens/login_phone.dart';
import 'package:locsy_skeleton/features/auth/screens/otp_verify.dart';

// ---------------------------------------------------------------
// Firebase init
// ---------------------------------------------------------------
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // uses android/app/google-services.json
  // sanity log: confirm correct Firebase project
  final o = Firebase.app().options;
  // ignore: avoid_print
  print('🔥 Firebase -> projectId=${o.projectId}, appId=${o.appId}');
  runApp(const LocsyApp());
}

class LocsyApp extends StatelessWidget {
  const LocsyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOCSY Coupons',
      debugShowCheckedModeBanner: false,
      theme: LocsyTheme.light,

      // ------------------- Named routes -------------------------
      initialRoute: AppRoutes.splash,
      routes: {
        // Auth flow
        AppRoutes.splash:     (_) => const SplashGate(),
        AppRoutes.authChoice: (_) => const AuthChoiceScreen(),
        AppRoutes.phoneOtp:   (_) => const LoginPhoneScreen(),

        // OTP step (reads phone from ModalRoute.arguments inside screen)
        '/auth/otp-verify':   (_) => const OtpVerifyScreen(),

        // Role + dashboards
        AppRoutes.roleSelect: (_) => const RoleSelectScreen(),
        AppRoutes.userDash:   (_) => const DashboardUserScreen(),
        AppRoutes.shopDash:   (_) => const DashboardShopScreen(),
        AppRoutes.adminDash:  (_) => const DashboardAdminScreen(),

        // Offers / distribution / wallet
        AppRoutes.createOffer: (_) => const CreateOfferScreen(),
        AppRoutes.myOffers:    (_) => const MyOffersScreen(),
        AppRoutes.distribute:  (_) => const DistributeScreen(),
        AppRoutes.redeem:      (_) => const RedeemScreen(),
        AppRoutes.wallet:      (_) => const WalletScreen(),
      },

      onUnknownRoute: (_) =>
          MaterialPageRoute(builder: (_) => const SplashGate()),
    );
  }
}
