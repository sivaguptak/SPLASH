import 'package:flutter/material.dart';
import '../../../widgets/lo_fields.dart';
import '../../../widgets/lo_buttons.dart';

class RedeemScreen extends StatelessWidget {
  const RedeemScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final token = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Redeem')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: token, decoration: loField('Token / QR payload')),
            const SizedBox(height: 16),
            LoPrimaryButton(text: 'Redeem (stub)', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
