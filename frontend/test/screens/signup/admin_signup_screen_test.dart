import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/views/signup/admin_signup_screen.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('Correct widgets appear', (WidgetTester tester) async {
    //Create widget for testing
    Widget createWidgetForTesting({Widget child}) {
      return MaterialApp(
          home: child
      );
    }

    //Build admin signup screen
    await tester.pumpWidget(createWidgetForTesting(child: new AdminRegister()));

    //Verify that the correct widgets appear in the correct order
    expect(find.text('First name'), findsOneWidget); //Find one widget containing 'First name'
    expect(find.text('Last name'), findsOneWidget); //Find one widget containing 'Last name'
    expect(find.text('Email'), findsOneWidget); //Find one widget containing 'Email'
    expect(find.text('Username'), findsOneWidget); //Find one widget containing 'Username'
    expect(find.text('Password'), findsOneWidget); //Find one widget containing 'Password'
    expect(find.text('Confirm password'), findsOneWidget); //Find one widget containing 'Confirm password'
    expect(find.text('Company ID'), findsOneWidget); //Find one widget containing 'Company ID'
    expect(find.text('Company name'), findsOneWidget); //Find one widget containing 'Company name'
    expect(find.text('Company address'), findsOneWidget); //Find one widget containing 'Company address'
  });
}