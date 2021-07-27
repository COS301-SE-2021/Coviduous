/*
  * File name: notification_globals.dart
  
  * Purpose: Global variables used for integration with front and backend.
  
  * Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
library globals;

import 'package:login_app/subsystems/notification_subsystem/notification.dart';
import 'package:login_app/subsystems/notification_subsystem/tempNotification.dart';

//Global variables used throughout the program
//=============================================

//Backend global variables
//==========================
/**
 * List<Shift> notificationDatabaseTable acts like a database table that holds notifications, this is to mock out functionality for testing
 * numNotifications keeps track of number of notifications in the mock notification database table
 */
List<Notification> notificationDatabaseTable = [];
int numNotifications = 0;

List<TempNotification> temp = [];
int tempSize = 0;
