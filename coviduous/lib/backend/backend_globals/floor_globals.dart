/*
  * File name: floor_globals.dart
  
  * Purpose: Global variables used for integration with front and backend.
  
  * Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
library globals;

import 'package:coviduous/subsystems/floorplan_subsystem/floor.dart';
import 'package:coviduous/subsystems/floorplan_subsystem/floorplan.dart';
import 'package:coviduous/subsystems/floorplan_subsystem/room.dart';

//Global variables used throughout the program
//=============================================

//Backend global variables
//==========================
/**
 * List<Floor> globalFloors acts like a database table that holds floors, this is to mock out functionality for testing
 * globalNumFloors keeps track of number of floors in the mock floors database table
 * Floors refer to the buildings floors, each floor is a level inside the building.
 */
List<Floor> globalFloors = [];
int globalNumFloors = 0;
List<Room> globalRooms = [];
int globalNumRooms = 0;
List<FloorPlan> globalFloorPlan = [];
int globalNumFloorPlans = 0;
