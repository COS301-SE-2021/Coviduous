/*
  * File name: announcements_globals.dart
  
  * Purpose: Global variables used for integration with front and backend.
  
  * Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
library globals;

import 'package:coviduous/subsystems/announcement_subsystem/announcement.dart';
import 'package:coviduous/subsystems/user_subsystem/user.dart';

//Global variables used throughout the program
//=============================================

//Backend global variables
//==========================
/**
 * List<Announcement> announcementDatabaseTable acts like a database table that holds announcements, this is to mock out functionality for testing
 * numAnnouncements keeps track of number of announcements in the mock announcement database table
 */
List<Announcement> announcementDatabaseTable = [];
int numAnnouncements = 0;
