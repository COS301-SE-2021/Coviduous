import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/views/user/admin_delete_account.dart';

import 'package:frontend/globals.dart' as globals;

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('Correct widgets appear', (WidgetTester tester) async {
    //Create widget for testing
    Widget createWidgetForTesting({Widget child}) {
      return MaterialApp(
          home: child
      );
    }

    globals.loggedInUserType = "ADMIN";

    //Build admin delete account screen
    await tester.pumpWidget(createWidgetForTesting(child: new AdminDeleteAccount()));

    //Verify that the correct widgets appear in the correct order
    expect(find.text('Email'), findsOneWidget); //Find one widget containing 'Email'
    expect(find.text('Password'), findsOneWidget); //Find one widget containing 'Password'
    expect(find.text('Confirm password'), findsOneWidget); //Find one widget containing 'Confirm password'
    expect(find.text('Company ID'), findsOneWidget); //Find one widget containing 'Company ID'
    expect(find.text('Remove'), findsOneWidget); //Find one widget containing 'Remove'
  });
}