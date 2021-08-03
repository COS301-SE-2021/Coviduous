import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coviduous/frontend/screens/user/user_manage_account.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('Correct widgets appear', (WidgetTester tester) async {
    //Create widget for testing
    Widget createWidgetForTesting({Widget child}) {
      return MaterialApp(
          home: child
      );
    }

    //Build user manage account screen
    await tester.pumpWidget(createWidgetForTesting(child: new UserManageAccount()));

    //Verify that the correct widgets appear in the correct order
    expect(find.text('Update account information'), findsOneWidget); //Find one widget containing 'Update account information'
    expect(find.text('Reset password'), findsOneWidget); //Find one widget containing 'Reset password'
    expect(find.text('Delete account'), findsOneWidget); //Find one widget containing 'Delete account'
  });
}