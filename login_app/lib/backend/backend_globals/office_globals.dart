/*
  File name: office_globals.dart
  Purpose: Global variables used for integration with front and backend.
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
library globals;

import 'package:login_app/subsystems/office_subsystem/booking.dart';

//Global variables used throughout the program
//=============================================

//Backend global variables
//==========================
/**
 * List<Booking> globalBookings  acts like a database table that holds bookings made inside a room , this is to mock out functionality for testing
 * numBookings keeps track of number of bookings in the mock bookings database table
 */
List<Booking> globalBookings = [];

int numBookings = 0;
