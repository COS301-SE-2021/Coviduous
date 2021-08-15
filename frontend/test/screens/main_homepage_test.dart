import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/views/main_homepage.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('Correct widgets appear', (WidgetTester tester) async {
    //Create widget for testing
    Widget createWidgetForTesting({Widget child}) {
      return MaterialApp(
          home: child
      );
    }

    //Build main homepage screen
    await tester.pumpWidget(createWidgetForTesting(child: new HomePage()));

    //Verify that the correct widgets appear in the correct order
    expect(find.text('Company member'), findsOneWidget); //Find one widget containing 'Company member'
    expect(find.text('Visitor'), findsOneWidget); //Find one widget containing 'Vistor'
  });
}