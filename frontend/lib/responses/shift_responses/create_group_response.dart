/*
  File name: create_group_response.dart
  Purpose: Holds the response class of creating a shift group
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

/**
 * Purpose: This class holds the response object for creating a shift group
 */
class CreateGroupResponse {
  String groupID;
  String timestamp;
  bool response;
  String responseMessage;

  CreateGroupResponse(
      String groupID, String timestamp, bool response, String responseMessage) {
    this.groupID = groupID;
    this.timestamp = timestamp;
    this.response = response;
    this.responseMessage = responseMessage;
  }

  String getGroupID() {
    return this.groupID;
  }

  String getTimestamp() {
    return this.timestamp;
  }

  bool getResponse() {
    return this.response;
  }

  String getResponseMessage() {
    return this.responseMessage;
  }
}
