import 'package:flutter/material.dart';
import '../../../widgets/lo_buttons.dart';
import '../../../widgets/lo_fields.dart';

class LoginPhoneScreen extends StatelessWidget {
  const LoginPhoneScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ctrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: ctrl, keyboardType: TextInputType.phone, decoration: loField('Phone number', hint: '+91 ...')),
            const SizedBox(height: 16),
            LoPrimaryButton(text: 'Send OTP', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
