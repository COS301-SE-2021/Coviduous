/*
  * File name: health_controller.dart
  
  * Purpose: Holds the controller class for health, all service contracts for the health subsystem are offered through this class.
  
  * Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
import 'package:login_app/backend/backend_globals/health_globals.dart'
    as healthGlobals;
import 'package:login_app/backend/server_connections/health_data_base_queries.dart';

/**
 * Class name: HealthController
 * 
 * Purpose: This class is the controller for health, all service contracts for the health subsystem are offered through this class
 * 
 * The class has both mock and concrete implementations of the service contracts.
 */
class HealthController {
  //This class provides an interface to all the health service contracts of the system. It provides a bridge between the front end screens and backend functionality for health.

  /** 
   * healthQueries attribute holds the class that provides access to the database, the attribute allows you to access functions that will handle database interaction.
   */
  HealthDatabaseQueries healthQueries;

  HealthController() {
    this.healthQueries = new HealthDatabaseQueries();
  }

  ////////////////////////////////////////////////Concrete Implementations////////////////////////////////////////////////

  //////////////////// HEALTH CHECK ////////////////////

  //////////////////// PERMISSION ////////////////////

  //////////////////// PERMISSION REQUEST ////////////////////

} // class