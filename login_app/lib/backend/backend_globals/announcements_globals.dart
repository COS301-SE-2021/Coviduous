library globals;

import 'package:login_app/subsystems/announcement_subsystem/announcement.dart';
import 'package:login_app/subsystems/user_subsystem/user.dart';

//Global variables used throughout the program
//=============================================

//Backend global variables
//==========================
/**
 * List<Announcement> announcementDatabaseTable = [] acts like a database table that holds announcements , this is to mock out functionality for testing
 * numAnnouncements keeps track of number of announcements in the mock announcement database table
 */
List<Announcement> announcementDatabaseTable = [];
int numAnnouncements = 0;

/**
 * List<Announcement> userDatabaseTable = [] acts like a database table that holds users , this is to mock out functionality for testing
 * numAnnouncements keeps track of number of users in the mock user database table
 */
List<User> userDatabaseTable = [];
int numUsers = 0;
