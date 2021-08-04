import 'package:frontend/subsystems/shift_subsystem/group.dart';

class CreateGroupResponse {
  bool status;
  List<Group> groups;

  CreateGroupResponse(List<Group> groups, bool status) {
    this.groups = groups;
    this.status = status;
  }

  List<Group> getGroups() {
    return groups;
  }

  bool getStatus() {
    return status;
  }
}
