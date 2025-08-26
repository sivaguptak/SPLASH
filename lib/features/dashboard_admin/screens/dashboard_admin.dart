import 'package:flutter/material.dart';
import '../../../widgets/lo_cards.dart';

class DashboardAdminScreen extends StatelessWidget {
  const DashboardAdminScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: HeaderCard(title: 'Admin – Today', subtitle: 'Moderation · Reports · Settings'),
      ),
    );
  }
}
