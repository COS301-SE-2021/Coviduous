import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_app/frontend/screens/admin_make_announcement.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('Correct widgets appear', (WidgetTester tester) async {
    //Create widget for testing
    Widget createWidgetForTesting({Widget child}) {
      return MaterialApp(
          home: child
      );
    }

    //Build admin make announcement screen
    await tester.pumpWidget(createWidgetForTesting(child: new MakeAnnouncement()));

    //Verify that the correct widgets appear in the correct order
    expect(find.text('Select announcement type'), findsOneWidget); //Find one widget containing 'Select announcement type'
    expect(find.text('Description'), findsOneWidget); //Find one widget containing 'Description'
    expect(find.text('Post'), findsOneWidget); //Find one widget containing 'Post'
  });
}