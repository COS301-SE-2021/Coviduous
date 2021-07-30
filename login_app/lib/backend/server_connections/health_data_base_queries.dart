/*
  * File name: health_data_base_queries.dart
  
  * Purpose: Provides an interface to all the health service contracts of the system
  
  * Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
import 'dart:convert';
import 'dart:math';

import 'package:login_app/backend/backend_globals/health_globals.dart'
    as healthGlobals;
import 'package:http/http.dart' as http;
// import 'package:login_app/subsystems/health_subsystem/health_check.dart';

/**
 * Class name: HealthDatabaseQueries
 * 
 * Purpose: This class provides an interface to all the health service contracts of the system. It provides a bridge between the frontend screens and backend functionality for health.
 * 
 * The class has both mock and concrete implementations of the service contracts.
 */
class HealthDatabaseQueries {
  String server = "https://hvofiy7xh6.execute-api.us-east-1.amazonaws.com";

  String healthCheckId;
  String timestamp;

  HealthDatabaseQueries() {
    // healthCheckId = null;
    // timestamp = null;
  }

  String getHealthCheckID() {
    return healthCheckId;
  }

  String getTimestamp() {
    return timestamp;
  }

  //////////////////////////////////Concerete Implementations///////////////////////////////////

}
