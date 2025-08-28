// ===============================================================
// FILE: lib/app.dart
// PURPOSE: Central route-name constants + in-app Navigator router.
// NOTES:
//  - Keeps your original LocsyRouter with onGenerateRoute + switch.
//  - Adds Register/Login flow routes: authChoice, phoneOtp, otpVerify.
//  - Minimal changes elsewhere. Use as a full replacement.
// ===============================================================

import 'package:flutter/material.dart';

// BEGIN screen imports (existing)
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
// END screen imports (existing)

// BEGIN screen imports (new auth pages)
import 'features/auth/screens/auth_choice.dart';   // Register/Login (Google first)
import 'features/auth/screens/login_phone.dart';   // Phone entry -> Send OTP
import 'features/auth/screens/otp_verify.dart';    // OTP entry -> continue
// END screen imports (new auth pages)

export 'features/auth/screens/splash_gate.dart';

// ===============================================================
// Route name constants
// ===============================================================
class AppRoutes {
  static const splash      = '/splash';
  static const roleSelect  = '/role';
  static const userDash    = '/dashboard/user';
  static const shopDash    = '/dashboard/shop';
  static const adminDash   = '/dashboard/admin';
  static const createOffer = '/offers/create';
  static const myOffers    = '/offers/mine';
  static const distribute  = '/distribute';
  static const redeem      = '/redeem';
  static const wallet      = '/wallet';

  // BEGIN new: auth flow
  static const authChoice  = '/auth/choice';      // Google → then phone OTP (mandatory)
  static const phoneOtp    = '/auth/phone-otp';   // Phone entry + Send OTP
  static const otpVerify   = '/auth/otp-verify';  // Enter OTP
// END new
}

// ===============================================================
// In-app Router (kept same style as your older version)
// ===============================================================
class LocsyRouter extends StatelessWidget {
  const LocsyRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      // BEGIN route switch
      onGenerateRoute: (settings) {
        // Decide which page to show for a given route
        Widget page;

        switch (settings.name) {
        // ---------- Auth flow (new) ----------
          case AppRoutes.authChoice:
            page = const AuthChoiceScreen();
            break;
          case AppRoutes.phoneOtp:
            page = const LoginPhoneScreen();
            break;
          case AppRoutes.otpVerify:
            page = const OtpVerifyScreen();
            break;

        // ---------- Existing routes ----------
          case AppRoutes.roleSelect:
            page = const RoleSelectScreen();
            break;
          case AppRoutes.userDash:
            page = const DashboardUserScreen();
            break;
          case AppRoutes.shopDash:
            page = const DashboardShopScreen();
            break;
          case AppRoutes.adminDash:
            page = const DashboardAdminScreen();
            break;
          case AppRoutes.createOffer:
            page = const CreateOfferScreen();
            break;
          case AppRoutes.myOffers:
            page = const MyOffersScreen();
            break;
          case AppRoutes.distribute:
            page = const DistributeScreen();
            break;
          case AppRoutes.redeem:
            page = const RedeemScreen();
            break;
          case AppRoutes.wallet:
            page = const WalletScreen();
            break;

        // ---------- Default (Splash) ----------
          default:
            page = const SplashGate();
            break;
        }

        // Material transition
        return MaterialPageRoute(builder: (_) => page, settings: settings);
      },
      // END route switch
    );
  }
}
