import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/frontend/screens/login_screen.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('Correct widgets appear', (WidgetTester tester) async {
    //Create widget for testing
    Widget createWidgetForTesting({Widget child}) {
      return MaterialApp(
          home: child
      );
    }

    //Build login screen
    await tester.pumpWidget(createWidgetForTesting(child: new LoginScreen()));

    //Verify that the correct widgets appear in the correct order
    expect(find.text('Email'), findsOneWidget); //Find one widget containing 'Email'
    expect(find.text('Password'), findsOneWidget); //Find one widget containing 'Password'
    expect(find.text('Admin'), findsOneWidget); //Find one widget containing 'Admin'
    expect(find.text('User'), findsOneWidget); //Find one widget containing 'User'
    expect(find.text('Submit'), findsOneWidget); //Find one widget containing 'Submit'
  });
}