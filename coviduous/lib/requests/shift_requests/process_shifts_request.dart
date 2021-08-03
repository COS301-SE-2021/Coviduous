import 'package:coviduous/subsystems/shift_subsystem/tempGroup.dart';

class ProcessShiftsRequest {
  List<TempGroup> list;

  ProcessShiftsRequest(List<TempGroup> notifList) {
    this.list = notifList;
  }

  List<TempGroup> getList() {
    return list;
  }
}
