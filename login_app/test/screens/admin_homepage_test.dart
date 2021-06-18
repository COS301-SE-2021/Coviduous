import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_app/frontend/screens/admin_homepage.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('Correct widgets appear', (WidgetTester tester) async {
    //Create widget for testing
    Widget createWidgetForTesting({Widget child}) {
      return MaterialApp(home: child);
    }

    //Build admin homepage screen
    await tester.pumpWidget(createWidgetForTesting(child: new AdminHomePage()));

    //Verify that the correct widgets appear in the correct order
    expect(find.text('Add a floor plan'),
        findsOneWidget); //Find one widget containing 'Add a floor plan'
    expect(find.text('Update floor plan'),
        findsOneWidget); //Find one widget containing 'Update floor plan'
    expect(find.text('Delete floor plan'),
        findsOneWidget); //Find one widget containing 'Delete floor plan'
    expect(find.text('View announcements'),
        findsOneWidget); //Find one widget containing 'View announcements'
    expect(find.text('Log out'),
        findsOneWidget); //Find one widget containing 'Log out'
  });
}
