import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_app/frontend/screens/user_view_announcements.dart';
import 'package:login_app/backend/backend_globals/announcements_globals.dart' as announcementGlobals;

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('Correct widgets appear', (WidgetTester tester) async {
    //Create widget for testing
    Widget createWidgetForTesting({Widget child}) {
      return MaterialApp(
          home: child
      );
    }

    //Build user view announcements screen
    await tester.pumpWidget(createWidgetForTesting(child: new UserViewAnnouncements()));

    int numberOfAnnouncements = announcementGlobals.numAnnouncements;

    //Verify that the correct widgets appear in the correct order
    if (numberOfAnnouncements == 0) {
      expect(find.text('No announcements found'), findsOneWidget); //Find one widget containing 'No announcements found'
      expect(find.text('You have no announcements.'), findsOneWidget); //Find one widget containing 'You have no announcements.'
    } else {
      expect(find.text('Announcement 1'), findsOneWidget); //Find one widget containing 'Announcement 1'
      expect(find.text('Type: General'), findsOneWidget); //Find one widget containing 'Type: General'
      expect(find.text('Date: test'), findsOneWidget); //Find one widget containing 'Date: test'
      expect(find.text('Message: Hello World'), findsOneWidget); //Find one widget containing 'Message: Hello World'
    }
  });
}