/*
  * File name: announcements_controller.dart
  
  * Purpose: Holds the controller class for announcements, all service contracts for the announcement subsystem are offered through this class.
  
  * Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
import 'package:frontend/backend/server_connections/announcement_data_base_queries.dart';
import 'package:frontend/requests/announcements_requests/create_announcement_request.dart';
import 'package:frontend/requests/announcements_requests/delete_announcement_request.dart';
import 'package:frontend/requests/announcements_requests/viewAdmin_announcement_request.dart';
import 'package:frontend/requests/announcements_requests/viewUser_announcement_request.dart';
import 'package:frontend/responses/announcement_responses/create_announcement_response.dart';
import 'package:frontend/responses/announcement_responses/delete_announcement_response.dart';
import 'package:frontend/responses/announcement_responses/viewAdmin_announcement_response.dart';
import 'package:frontend/responses/announcement_responses/viewUser_announcement_response.dart';

/**
 * Class name: AnnouncementsController
 * 
 * Purpose: This class is the controller for announcements, all service contracts for the announcement subsystem are offered through this class
 * 
 * The class has both mock and concrete implementations of the service contracts.
 */
class AnnouncementsController {
  //This class provides an interface to all the announcement service contracts of the system. It provides a bridge between the front end screens and backend functionality for announcements.

  /** 
   * announcementQueries attribute holds the class that provides access to the database , the attribute allows you to access functions that will handle database interaction.
   */
  AnnouncementDatabaseQueries announcementQueries;

  AnnouncementsController() {
    this.announcementQueries = new AnnouncementDatabaseQueries();
  }
//////////////////////////////////////////////DEMO3 API CLOUD FUNCTIONS ////////////////////////////////////////////////
  Future<CreateAnnouncementResponse> createAnnouncementAPI(
      CreateAnnouncementRequest req) async {
    if (req != null) {
      if (await announcementQueries.createAnnouncementAPI(req.getType(),
              req.getMessage(), req.getAdminID(), req.getCompanyID()) ==
          true) {
        return new CreateAnnouncementResponse(
            announcementQueries.getAnnouncementID(),
            announcementQueries.getTimestamp(),
            true,
            "Successfully Created Announcement");
      } else {
        return new CreateAnnouncementResponse(
            null, null, false, "Announcement unsuccessfully created");
      }
    } else {
      return new CreateAnnouncementResponse(
          null, null, false, "Announcement unsuccessfully created");
    }
  }

  ////////////////////////////////////////////////Concrete Implementations////////////////////////////////////////////////
  /**
   * createAnnouncement creates a new announcement, This activity is only done by the admin user who is responsisble for issuing announcements
   */
  Future<CreateAnnouncementResponse> createAnnouncement(
      CreateAnnouncementRequest req) async {
    if (req != null) {
      if (await announcementQueries.createAnnouncement(req.getType(),
              req.getMessage(), req.getAdminID(), req.getCompanyID()) ==
          true) {
        return new CreateAnnouncementResponse(
            announcementQueries.getAnnouncementID(),
            announcementQueries.getTimestamp(),
            true,
            "Successfully Created Announcement");
      } else {
        return new CreateAnnouncementResponse(
            null, null, false, "Announcement unsuccessfully created");
      }
    } else {
      return new CreateAnnouncementResponse(
          null, null, false, "Announcement unsuccessfully created");
    }
  }

//////////////////////////////////////////////////////////////////////////////////////////
/**
 * View Admin Announcement : Returns a list of all announcements issued by an admin based on their admin ID 
 */
  Future<ViewAdminAnnouncementResponse> viewAdminAnnouncement(
      ViewAdminAnnouncementRequest req) async {
    if (req != null) {
      if (await announcementQueries.viewAdminAnnouncement(req.getAdminId()) ==
          true) {
        return new ViewAdminAnnouncementResponse(
            null, true, "Announcement successfully found");
      } else {
        return new ViewAdminAnnouncementResponse(
            null, false, "Announcement unsuccessfully found");
      }
    } else {
      return new ViewAdminAnnouncementResponse(
          null, false, "Announcement unsuccessfully found");
    }
  }

///////////////////////////////////////////////////////////////
/**
 * deleteAnnouncement Deletes an announcement made by an admin based on the announcement id which can be seen when the admin views the announcement
 */
  Future<DeleteAnnouncementResponse> deleteAnnouncement(
      DeleteAnnouncementRequest req) async {
    if (req != null) {
      if (await announcementQueries
              .deleteAnnouncement(req.getAnnouncementId()) ==
          true) {
        return new DeleteAnnouncementResponse(
            true, "Successfully Deleted Announcement");
      } else {
        return new DeleteAnnouncementResponse(
            false, "Announcement unsuccessfully deleted");
      }
    } else {
      return new DeleteAnnouncementResponse(
          false, "Announcement unsuccessfully deleted");
    }
  }

////////////////////////////////////////////////Mock Implementations////////////////////////////////////////////////

  //create Announcement Mock
  /**
   * This function is used to test if the logic and implementation of creating an announcement works
   */
  CreateAnnouncementResponse createAnnouncementMock(
      CreateAnnouncementRequest req) {
    if (req != null) {
      if (announcementQueries.createAnnouncementMock(req.getType(),
          req.getMessage(), req.getAdminID(), req.getCompanyID())) {
        return new CreateAnnouncementResponse(
            announcementQueries.getAnnouncementID(),
            announcementQueries.getTimestamp(),
            true,
            "Successfully Created Announcement");
      } else {
        return new CreateAnnouncementResponse(
            null, null, false, "Announcement unsuccessfully created");
      }
    } else {
      return new CreateAnnouncementResponse(
          null, null, false, "Announcement unsuccessfully created");
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //Delete Announcement Mock
  /**
   * This function is used to test if the logic and implementation of deleting an announcement works
   */
  DeleteAnnouncementResponse deleteAnnouncementMock(
      DeleteAnnouncementRequest req) {
    if (announcementQueries.deleteAnnouncementMock(req.getAnnouncementId())) {
      return DeleteAnnouncementResponse(
          true, "Successfully Deleted Announcement");
    } else // throw Exception
    {
      throw new Exception("Announcement unsuccessfully deleted");
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//View Announcement Mock For Admin
  /**
   * This function is used to test if the logic and implementation of viewing an announcement by the admin works
   */
  ViewAdminAnnouncementResponse viewAnnouncementsAdminMock(
      ViewAdminAnnouncementRequest req) {
    var list = announcementQueries.viewAnnouncementsAdminMock(req.getAdminId());
    if (list != null) {
      return new ViewAdminAnnouncementResponse(
          list, true, "Successfully Fetched Announcements For Admin");
    } else {
      throw new Exception("Announcement id does not exist");
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//View Announcement Mock For User
/**
   * This function is used to test if the logic and implementation of viewing an announcement by the user works
   */
  ViewUserAnnouncementResponse viewAnnouncementsUserMock(
      ViewUserAnnouncementRequest req) {
    var list = announcementQueries.viewAnnouncementsUserMock(req.getUserId());
    if (list != null) {
      return new ViewUserAnnouncementResponse(
          list, true, "Successfully Fetched Announcements For User");
    } else {
      throw new Exception("Announcement id does not exist");
    }
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
