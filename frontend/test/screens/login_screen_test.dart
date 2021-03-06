import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/views/login_screen.dart';

import 'package:frontend/globals.dart' as globals;

void main() {
  setUpAll(() => HttpOverrides.global = null);

  globals.showChatBot = false;

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
    expect(find.text('Forgot password?'), findsOneWidget); //Find one widget containing 'Forgot password?'
    expect(find.text('Submit'), findsOneWidget); //Find one widget containing 'Submit'
  });
}