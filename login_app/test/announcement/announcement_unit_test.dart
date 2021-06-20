import 'package:flutter_test/flutter_test.dart';
import 'package:login_app/backend/controllers/announcements_controller.dart';
import 'package:login_app/requests/announcements_requests/create_announcement_request.dart';
import 'package:login_app/requests/announcements_requests/delete_announcement_request.dart';
import 'package:login_app/requests/announcements_requests/viewAdmin_announcement_request.dart';
import 'package:login_app/requests/announcements_requests/viewUser_announcement_request.dart';
import 'package:login_app/responses/announcement_responses/create_announcement_response.dart';
import 'package:login_app/responses/announcement_responses/delete_announcement_response.dart';
import 'package:login_app/responses/announcement_responses/viewAdmin_announcement_response.dart';
import 'package:login_app/responses/announcement_responses/viewUser_announcement_response.dart';
import 'package:login_app/subsystems/announcement_subsystem/announcement.dart';
import 'package:login_app/subsystems/user_subsystem/user.dart';
import 'package:login_app/backend/backend_globals/announcements_globals.dart'
    as globals;
import 'package:login_app/backend/backend_globals/user_globals.dart'
    as userGlobals;

void main() {
  ///////////////////////////////////// These Unit Tests Test Mocked Functionality For The Announcement System ///////////
////////////////////////////////////////////// Create Announcement/////////////////////////////////////////////////////

  test('Create Announcement Mock', () {
    var announcementController = AnnouncementsController();
    print(
        "/////////////////////////////Testing Mock Create Announcement ///////////////////");
    CreateAnnouncementRequest req = new CreateAnnouncementRequest(
        "GENERAL", "Please Register For PaySlips", "USRAD-1", "CID-1");
    CreateAnnouncementResponse resp =
        announcementController.createAnnouncementMock(req);
    print("Response : " + resp.getResponseMessage());
    print("AnnouncementID : " + resp.getAnnouncementID());

    print(
        "/////////////////////////////Completed Mock Testing For Creating Announcements ///////////////////");
    expect(globals.numAnnouncements, isNot(0));
  });

  test('Invalid create announcement request', () {
    var announcementController = AnnouncementsController();
    print(
        "/////////////////////////////Testing Invalid Create Announcement Request ///////////////////");
    CreateAnnouncementRequest req = null;
    CreateAnnouncementResponse resp =
        announcementController.createAnnouncementMock(req);
    print("Response : " + resp.getResponseMessage());

    print(
        "/////////////////////////////Completed Mock Testing For Invalid Create Announcement Request ///////////////////");
    expect(false, resp.getResponse());
  });

  ////////////////////////////////////////////// Delete Announcement  /////////////////////////////////////////////////////

  test('Delete Announcement Mock', () {
    var announcementController = AnnouncementsController();
    print(
        "/////////////////////////////Testing Mock delete Announcement ///////////////////");
    CreateAnnouncementRequest req = new CreateAnnouncementRequest(
        "GENERAL", "Please Register For PaySlips", "USRAD-1", "CID-1");
    CreateAnnouncementResponse resp =
        announcementController.createAnnouncementMock(req);
    print("Response : " + resp.getResponseMessage());
    print("AnnouncementID : " + resp.getAnnouncementID());
    print("Successfully created announcement will now attempt to delete it");

    DeleteAnnouncementRequest delReq =
        new DeleteAnnouncementRequest(resp.getAnnouncementID());

    DeleteAnnouncementResponse delResp =
        announcementController.deleteAnnouncementMock(delReq);
    print("Response : " + delResp.getResponseMessage());

    print(
        "/////////////////////////////Completed Mock Test For Delete ///////////////////");
    //number of announcement should be zero since we only made 1 announcement and the deleted it.
    expect(delResp.getResponse(), true);
  });
  /////////////////////////////////////////////// View Announcement Admin /////////////////////////////////////////////////////
  test('View Announcement For Admin Mock', () {
    var announcementController = AnnouncementsController();

    print(
        "/////////////////////////////Testing Mock Admin View Announcements ///////////////////");
    CreateAnnouncementRequest req = new CreateAnnouncementRequest(
        "GENERAL", "Please Register For PaySlips", "USRAD-1", "CID-1");
    CreateAnnouncementResponse resp =
        announcementController.createAnnouncementMock(req);
    print("Response : " + resp.getResponseMessage());
    print("AnnouncementID : " + resp.getAnnouncementID());
    print("Successfully created announcement ");

    //SECOND ANNOUNCEMENT WAS ADMINISTERED BY A DIFFERENT ADMIN WITH ID=USRAD-2
    CreateAnnouncementRequest req2 =
        new CreateAnnouncementRequest("GENERAL", "", "USRAD-2", "CID-2");
    CreateAnnouncementResponse resp2 =
        announcementController.createAnnouncementMock(req2);
    print("Response : " + resp2.getResponseMessage());
    print("AnnouncementID : " + resp2.getAnnouncementID());
    print("Successfully created announcement ");

    //THIRD ANNOUNCEMENT WAS ADMINISTERED BY ADMIN WITH ID=USRAD-1 WHICH IS THE SAME AS THE FIRST ANNOUNCEMENT
    CreateAnnouncementRequest req3 = new CreateAnnouncementRequest(
        "EMERGENCY",
        "THE OFFICES HAVE BEEN FOUND TO HAVE TRACES OF COVID-19",
        "USRAD-1",
        "CID-1");
    CreateAnnouncementResponse resp3 =
        announcementController.createAnnouncementMock(req3);
    print("Response : " + resp3.getResponseMessage());
    print("AnnouncementID : " + resp3.getAnnouncementID());
    print("Successfully created announcement ");
    print(
        "/////////////////////////////Successfully added announcements ///////////////////");
    ViewAdminAnnouncementRequest viewReq =
        new ViewAdminAnnouncementRequest("USRAD-1");

    ViewAdminAnnouncementResponse viewResp =
        announcementController.viewAnnouncementsAdminMock(viewReq);
    print("Response : " + viewResp.getMessage());
    if (viewResp.getAdminAnnouncements() != null) {
      List<Announcement> list = viewResp.getAdminAnnouncements();
      for (var j = 0; j < list.length; j++) {
        print("Printing Admin Announcement");
        print("Message : " + list[j].getMessage());
        print("Date : " + list[j].getDate());
        print("Type : " + list[j].getType());
        print("Announcement ID : " + list[j].getAnnouncementId());
        print("Admin ID : " + list[j].getadminId());
        print("Company ID : " + list[j].getCompanyId());
      }
    }

    print(
        "/////////// Completed View Announcement For Admin Mock Test //////////////////////");
    //number of announcement should be not be zero since 3 announcements were added.
    expect(globals.numAnnouncements, isNot(0));
  });

  /////////////////////////////////////////////// View Announcement Users /////////////////////////////////////////////////////
  test('View Announcement For User Mock', () {
    var announcementController = AnnouncementsController();

    print(
        "/////////////////////////////Testing Mock User View Announcements ///////////////////");
    User admin = User("ADMIN", "Njabulo", "Skosana", "njabuloS",
        "njabulo@gmail.com", "123456", "CID-1");
    User user = User("USER", "Mpho", "Lefatsi", "MphoLefatsi09",
        "lefatsi@gmail.com", "MphoLefatsi09", "CID-1");

    userGlobals.userDatabaseTable.add(admin);
    userGlobals.numUsers++;
    userGlobals.userDatabaseTable.add(user);
    userGlobals.numUsers++;
    print("Successfully added admin user and general user");
    for (var i = 0; i < userGlobals.userDatabaseTable.length; i++) {
      print("Printing out a user");
      print("Name : " + userGlobals.userDatabaseTable[i].getFirstName());
      print("Last Name : " + userGlobals.userDatabaseTable[i].getLastName());
      print("Company ID : " + userGlobals.userDatabaseTable[i].getCompanyId());
      print("User ID : " + userGlobals.userDatabaseTable[i].getUserId());
    }
    print("//////////////////////////////////////////////////");
    CreateAnnouncementRequest req = new CreateAnnouncementRequest(
        "GENERAL", "Please Register For PaySlips", "USRAD-1", "CID-1");
    CreateAnnouncementResponse resp =
        announcementController.createAnnouncementMock(req);
    print("Response : " + resp.getResponseMessage());
    print("AnnouncementID : " + resp.getAnnouncementID());
    print("Successfully created announcement ");

    //SECOND ANNOUNCEMENT WAS ADMINISTERED BY A DIFFERENT ADMIN WITH ID=USRAD-2
    CreateAnnouncementRequest req2 =
        new CreateAnnouncementRequest("GENERAL", "", "USRAD-2", "CID-2");
    CreateAnnouncementResponse resp2 =
        announcementController.createAnnouncementMock(req2);
    print("Response : " + resp2.getResponseMessage());
    print("AnnouncementID : " + resp2.getAnnouncementID());
    print("Successfully created announcement ");

    //THIRD ANNOUNCEMENT WAS ADMINISTERED BY ADMIN WITH ID=USRAD-1 WHICH IS THE SAME AS THE FIRST ANNOUNCEMENT
    CreateAnnouncementRequest req3 = new CreateAnnouncementRequest(
        "EMERGENCY",
        "THE OFFICES HAVE BEEN FOUND TO HAVE TRACES OF COVID-19",
        "USRAD-1",
        "CID-1");
    CreateAnnouncementResponse resp3 =
        announcementController.createAnnouncementMock(req3);
    print("Response : " + resp3.getResponseMessage());
    print("AnnouncementID : " + resp3.getAnnouncementID());
    print("Successfully created announcement ");
    print(
        "/////////////////////////////Successfully added announcements ///////////////////");
    ViewUserAnnouncementRequest viewReq =
        new ViewUserAnnouncementRequest(user.getUserId());

    ViewUserAnnouncementResponse viewResp =
        announcementController.viewAnnouncementsUserMock(viewReq);
    print("Response : " + viewResp.getMessage());
    List<Announcement> list = viewResp.getUserAnnouncements();
    print("//////////////////////////////////////////////////");
    for (var j = 0; j < list.length; j++) {
      print("Printing User Announcement");
      print("Message : " + list[j].getMessage());
      print("Date : " + list[j].getDate());
      print("Type : " + list[j].getType());
      print("//////////////////////////////////////////////////");
    }

    /**
     * Check if the userid is not given throw Exception 
     * Check if the userid given is invaild 
     */

    print(
        "/////////// Completed View Announcement For User Mock Test //////////////////////");
    //number of announcement should be not be zero since 3 announcements were added.
    expect(globals.numAnnouncements, isNot(0));
  });
}
