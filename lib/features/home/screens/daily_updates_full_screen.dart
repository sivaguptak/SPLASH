import 'package:flutter/material.dart';
import '../../../widgets/daily_updates_widget.dart';
import '../../../widgets/back_button_handler.dart';
import '../../../core/theme.dart';

class DailyUpdatesFullScreen extends StatelessWidget {
  const DailyUpdatesFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Daily Updates',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: LocsyColors.orange,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: const DailyUpdatesWidget(),
    );
  }
}
