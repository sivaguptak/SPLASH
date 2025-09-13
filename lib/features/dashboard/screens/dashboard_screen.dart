// BEGIN DASHBOARD STUB
// Simple placeholder screen shown after OTP success.

import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const Center(
        child: Text('✅ Phone OTP Success! This is Dashboard.'),
      ),
    );
  }
}
// END DASHBOARD STUB
