import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/frontend/screens/home_signup_screen.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('Correct widgets appear', (WidgetTester tester) async {
    //Create widget for testing
    Widget createWidgetForTesting({Widget child}) {
      return MaterialApp(
          home: child
      );
    }

    //Build signup screen
    await tester.pumpWidget(createWidgetForTesting(child: new Register()));

    //Verify that the correct widgets appear in the correct order
    expect(find.text('Email'), findsOneWidget); //Find one widget containing 'Email'
    expect(find.text('Password'), findsOneWidget); //Find one widget containing 'Password'
    expect(find.text('Confirm Password'), findsOneWidget); //Find one widget containing 'Confirm Password'
    expect(find.text('Select user type'), findsOneWidget); //Find one widget containing 'Select user type'
    expect(find.text('Submit'), findsOneWidget); //Find one widget containing 'Submit'
  });
}