/*
  File name: get_shifts_response.dart
  Purpose: Holds the response class of retrieving all shifts
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

import 'package:login_app/subsystems/shift_subsystem/group.dart';

/**
 * This class holds the response object for retrieving shifts by the admin user
 */
class GetGroupsResponse {
  List<Group> groups;
  bool response;
  String responseMessage;

  GetGroupsResponse(List<Group> groups, bool response, String responseMessage) {
    this.groups = groups;
    this.response = response;
    this.responseMessage = responseMessage;
  }

  List<Group> getGroups() {
    return groups;
  }

  bool getResponse() {
    return this.response;
  }

  String getResponseMessage() {
    return this.responseMessage;
  }
}
