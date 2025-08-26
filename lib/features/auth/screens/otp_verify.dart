import 'package:flutter/material.dart';
import '../../../widgets/lo_buttons.dart';
import '../../../widgets/lo_fields.dart';

class OtpVerifyScreen extends StatelessWidget {
  const OtpVerifyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ctrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: ctrl, keyboardType: TextInputType.number, decoration: loField('Enter OTP')),
            const SizedBox(height: 16),
            LoPrimaryButton(text: 'Verify', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
