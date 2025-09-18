// ===============================================================
// FILE: lib/main.dart
// PURPOSE: App entry + MaterialApp routes. No business logic.
// ===============================================================

// Core
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:locsy_skeleton/features/auth/screens/phone_otp_flow.dart';
import 'package:locsy_skeleton/features/home/screens/home_screen.dart';
import 'package:locsy_skeleton/features/home/screens/all_categories_screen.dart';
import 'package:locsy_skeleton/features/profile/screens/profile_screen.dart';
import 'package:locsy_skeleton/features/demo/screens/scratch_demo_screen.dart';

// ---------------------------------------------------------------
// Firebase init
// ---------------------------------------------------------------
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lock orientation to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  await Firebase.initializeApp(); // uses android/app/google-services.json
  // sanity log: confirm correct Firebase project
  final o = Firebase.app().options;
  // ignore: avoid_print
  print('🔥 Firebase -> projectId=${o.projectId}, appId=${o.appId}');
  print('🔥 Firebase -> apiKey=${o.apiKey}');
  print('🔥 Firebase -> authDomain=${o.authDomain}');
  print('🔥 Firebase -> storageBucket=${o.storageBucket}');
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
        AppRoutes.phoneOtp:   (_) => const PhoneOtpFlow(),
        AppRoutes.home:       (_) => const HomeScreen(),
        AppRoutes.allCategories: (_) => const AllCategoriesScreen(),
        AppRoutes.profile:    (_) => const ProfileScreen(),

        // OTP step (reads phone from ModalRoute.arguments inside screen)
        '/auth/otp-verify':   (_) => const PhoneOtpFlow(),

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
        
        // Demo routes
        AppRoutes.scratchDemo: (_) => const ScratchDemoScreen(),
      },

      onUnknownRoute: (_) =>
          MaterialPageRoute(builder: (_) => const SplashGate()),
    );
  }
}
