import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/frontend/screens/admin_delete_announcement.dart';
import '../../lib/backend/backend_globals/announcements_globals.dart' as announcementGlobals;

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('Correct widgets appear', (WidgetTester tester) async {
    //Create widget for testing
    Widget createWidgetForTesting({Widget child}) {
      return MaterialApp(
          home: child
      );
    }

    //Build admin delete announcement screen
    await tester.pumpWidget(createWidgetForTesting(child: new AdminDeleteAnnouncement()));

    int numberOfAnnouncements = announcementGlobals.numAnnouncements;

    //Verify that the correct widgets appear in the correct order
    if (numberOfAnnouncements == 0) {
      expect(find.text('No announcements found'), findsOneWidget); //Find one widget containing 'No announcements found'
      expect(find.text('You have no announcements.'), findsOneWidget); //Find one widget containing 'You have no announcements.'
    } else {
      expect(find.text('Select announcement ID'), findsOneWidget); //Find one widget containing 'Select announcement ID'
      expect(find.text('Proceed'), findsOneWidget); //Find one widget containing 'Proceed'
    }
  });
}