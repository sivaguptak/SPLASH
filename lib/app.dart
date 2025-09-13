// ===============================================================
// FILE: lib/app.dart
// PURPOSE: Central route-name constants + in-app Navigator router.
// NOTES:
//  - Keeps your original LocsyRouter with onGenerateRoute + switch.
//  - Integrates new unified Phone OTP flow (PhoneOtpFlow).
//  - Adds generic '/dashboard' route for post-auth landing.
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

// BEGIN screen imports (auth)
import 'features/auth/screens/auth_choice.dart';        // Google first
import 'features/auth/screens/phone_otp_flow.dart';     // Unified phone->OTP flow
// END screen imports (auth)

// BEGIN screen imports (new dashboard stub)
import 'features/dashboard/screens/dashboard_screen.dart';
// END screen imports (new dashboard stub)

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

  // Auth flow
  static const authChoice  = '/auth/choice';      // Google → then phone OTP (mandatory)
  static const phoneOtp    = '/auth/phone-otp';   // Unified flow entry (phone + otp)
  static const otpVerify   = '/auth/otp-verify';  // Legacy path -> redirect to unified flow

  // New generic dashboard landing after auth
  static const dashboard   = '/dashboard';
}

// ===============================================================
// In-app Router (onGenerateRoute switch)
// ===============================================================
class LocsyRouter extends StatelessWidget {
  const LocsyRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        Widget page;

        switch (settings.name) {
        // ---------- Auth flow ----------
          case AppRoutes.authChoice:
            page = const AuthChoiceScreen();
            break;

        // Both entries point to unified PhoneOtpFlow
          case AppRoutes.phoneOtp:
          case AppRoutes.otpVerify:
            page = const PhoneOtpFlow();
            break;

        // ---------- New generic dashboard ----------
          case AppRoutes.dashboard:
            page = const DashboardScreen();
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

        return MaterialPageRoute(builder: (_) => page, settings: settings);
      },
    );
  }
}
