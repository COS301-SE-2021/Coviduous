/*
  * File name: health_globals.dart
  
  * Purpose: Global variables used for integration with front and backend.
  
  * Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
library globals;

import 'package:coviduous/subsystems/health_subsystem/health_check.dart';
import 'package:coviduous/subsystems/health_subsystem/permission.dart';
import 'package:coviduous/subsystems/health_subsystem/permission_request.dart';

//Global variables used throughout the program
//=============================================

//Backend global variables
//==========================
/**
 * List<HealthCheck> healthDatabaseTable acts like a database table that holds health checks, this is to mock out functionality for testing
 * numHealths keeps track of number of health checks in the mock healthCheck database table
 */
List<HealthCheck> healthCheckDatabaseTable = [];
int numHealthChecks = 0;

/**
 * List<Permission> permissionDatabaseTable acts like a database table that holds permissions, this is to mock out functionality for testing
 * numPermissions keeps track of number of permissions in the mock permission database table
 */
List<Permission> permissionDatabaseTable = [];
int numPermissions = 0;

/**
 * List<PermissionRequest> permissionDatabaseTable acts like a database table that holds permission requests, this is to mock out functionality for testing
 * numPermissionRequests keeps track of number of permission requests in the mock permissionRequest database table
 */
List<PermissionRequest> permissionRequestDatabaseTable = [];
int numPermissionRequests = 0;
