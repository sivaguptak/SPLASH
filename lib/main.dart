import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'app.dart';

// screens
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

void main() => runApp(const LocsyApp());

class LocsyApp extends StatelessWidget {
  const LocsyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOCSY Coupons',
      debugShowCheckedModeBanner: false,
      theme: LocsyTheme.light,

      // ✅ Use proper named routes (no fallback to Splash)
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash:     (_) => const SplashGate(),
        AppRoutes.roleSelect: (_) => const RoleSelectScreen(),
        AppRoutes.userDash:   (_) => const DashboardUserScreen(),
        AppRoutes.shopDash:   (_) => const DashboardShopScreen(),
        AppRoutes.adminDash:  (_) => const DashboardAdminScreen(),
        AppRoutes.createOffer:(_) => const CreateOfferScreen(),
        AppRoutes.myOffers:   (_) => const MyOffersScreen(),
        AppRoutes.distribute: (_) => const DistributeScreen(),
        AppRoutes.redeem:     (_) => const RedeemScreen(),
        AppRoutes.wallet:     (_) => const WalletScreen(),
      },

      // (optional) unknown route → splash
      onUnknownRoute: (_) =>
          MaterialPageRoute(builder: (_) => const SplashGate()),
    );
  }
}
