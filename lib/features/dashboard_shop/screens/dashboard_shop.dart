import 'package:flutter/material.dart';
import '../../../widgets/lo_cards.dart';
import '../../../widgets/lo_buttons.dart';
import '../../../app.dart';

class DashboardShopScreen extends StatelessWidget {
  const DashboardShopScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shop Owner Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const HeaderCard(title: 'Mahalakshmi Sweets', subtitle: 'Accepting redemptions'),
          const SizedBox(height: 16),
          Wrap(spacing: 10, runSpacing: 10, children: [
            SizedBox(width: double.infinity, child: LoPrimaryButton(text: 'Create Offer', onPressed: () => Navigator.pushNamed(context, AppRoutes.createOffer))),
            SizedBox(width: double.infinity, child: LoPrimaryButton(text: 'My Offers', onPressed: () => Navigator.pushNamed(context, AppRoutes.myOffers))),
            SizedBox(width: double.infinity, child: LoPrimaryButton(text: 'Distribute', onPressed: () => Navigator.pushNamed(context, AppRoutes.distribute))),
            SizedBox(width: double.infinity, child: LoPrimaryButton(text: 'Scan/Redeem', onPressed: () => Navigator.pushNamed(context, AppRoutes.redeem))),
          ]),
        ],
      ),
    );
  }
}
