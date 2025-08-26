import 'package:flutter/material.dart';
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

export 'features/auth/screens/splash_gate.dart';

class AppRoutes {
  static const splash = '/splash';
  static const roleSelect = '/role';
  static const userDash = '/dashboard/user';
  static const shopDash = '/dashboard/shop';
  static const adminDash = '/dashboard/admin';
  static const createOffer = '/offers/create';
  static const myOffers = '/offers/mine';
  static const distribute = '/distribute';
  static const redeem = '/redeem';
  static const wallet = '/wallet';
}

class LocsyRouter extends StatelessWidget {
  const LocsyRouter({super.key});
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case AppRoutes.roleSelect: page = const RoleSelectScreen(); break;
          case AppRoutes.userDash: page = const DashboardUserScreen(); break;
          case AppRoutes.shopDash: page = const DashboardShopScreen(); break;
          case AppRoutes.adminDash: page = const DashboardAdminScreen(); break;
          case AppRoutes.createOffer: page = const CreateOfferScreen(); break;
          case AppRoutes.myOffers: page = const MyOffersScreen(); break;
          case AppRoutes.distribute: page = const DistributeScreen(); break;
          case AppRoutes.redeem: page = const RedeemScreen(); break;
          case AppRoutes.wallet: page = const WalletScreen(); break;
          default: page = const SplashGate(); break;
        }
        return MaterialPageRoute(builder: (_) => page, settings: settings);
      },
    );
  }
}
