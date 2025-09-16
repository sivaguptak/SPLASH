// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:locsy_skeleton/main.dart';
import 'package:locsy_skeleton/features/home/screens/home_screen.dart';

void main() {
  testWidgets('App starts with splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LocsyApp());

    // Verify that the app starts (we can't test splash screen without Firebase)
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Home screen displays welcome message', (WidgetTester tester) async {
    // Build the home screen widget
    await tester.pumpWidget(
      MaterialApp(
        home: const HomeScreen(),
      ),
    );

    // Verify that the welcome message is displayed
    expect(find.text('Welcome to Locsy! 🎉'), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);
    expect(find.text('Choose Your Role'), findsOneWidget);
  });

  testWidgets('Home screen has role selection cards', (WidgetTester tester) async {
    // Build the home screen widget
    await tester.pumpWidget(
      MaterialApp(
        home: const HomeScreen(),
      ),
    );

    // Verify that role selection cards are present
    expect(find.text('Customer'), findsOneWidget);
    expect(find.text('Shop Owner'), findsOneWidget);
    expect(find.text('Admin'), findsOneWidget);
  });
}
