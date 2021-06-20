import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_app/frontend/screens/admin_reset_password_screen.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('Correct widgets appear', (WidgetTester tester) async {
    //Create widget for testing
    Widget createWidgetForTesting({Widget child}) {
      return MaterialApp(
          home: child
      );
    }

    //Build admin reset password screen
    await tester.pumpWidget(createWidgetForTesting(child: new AdminResetPassword()));

    //Verify that the correct widgets appear in the correct order
    expect(find.text('Email'), findsOneWidget); //Find one widget containing 'Email'
    expect(find.text('Reset password'), findsOneWidget); //Find one widget containing 'Reset password'
  });
}