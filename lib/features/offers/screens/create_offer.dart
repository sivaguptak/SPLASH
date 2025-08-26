import 'package:flutter/material.dart';
import '../../../widgets/lo_fields.dart';
import '../../../widgets/lo_buttons.dart';

class CreateOfferScreen extends StatelessWidget {
  const CreateOfferScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final title = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Create Offer')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: title, decoration: loField('Title', hint: 'Instant PAN – Special')),
            const SizedBox(height: 16),
            LoPrimaryButton(text: 'Save (stub)', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
