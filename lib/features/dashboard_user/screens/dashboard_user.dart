import 'package:flutter/material.dart';
import '../../../widgets/lo_cards.dart';
import '../../../widgets/lo_buttons.dart';
import '../../../app.dart';

class DashboardUserScreen extends StatelessWidget {
  const DashboardUserScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const HeaderCard(title: 'Hello 👋', subtitle: 'Find and redeem coupons nearby'),
          const SizedBox(height: 16),
          LoPrimaryButton(text: 'Open Wallet', onPressed: () => Navigator.pushNamed(context, AppRoutes.wallet)),
          const SizedBox(height: 8),
          LoPrimaryButton(text: 'Redeem Coupon', onPressed: () => Navigator.pushNamed(context, AppRoutes.redeem)),
        ],
      ),
    );
  }
}
