import 'package:flutter/material.dart';
import '../../../widgets/lo_buttons.dart';
import '../../../app.dart';

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Role')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            LoPrimaryButton(text: 'Continue as Customer', onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.userDash)),
            const SizedBox(height: 12),
            LoPrimaryButton(text: 'I\'m a Shop Owner', onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.shopDash)),
            const SizedBox(height: 12),
            LoPrimaryButton(text: 'Admin Console', onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.adminDash)),
          ],
        ),
      ),
    );
  }
}
