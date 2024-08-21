import 'package:dropill_project/features/monitoring/monitoring_state.dart';
import 'package:flutter/foundation.dart';
//TO DO: import states

class MonitoringController extends ChangeNotifier {
  //TO DO: inject service
  //TO DO: constructor

  MonitoringState _state = MonitoringStateInitial();

  MonitoringState get state => _state;

  void _changeState(MonitoringState newState) {
    _state = newState;
    notifyListeners();
  }

}