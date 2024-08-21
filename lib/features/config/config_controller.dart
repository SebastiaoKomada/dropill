import 'package:dropill_project/features/config/config_state.dart';
import 'package:flutter/foundation.dart';
//TO DO: import states

class ConfigController extends ChangeNotifier {
  //TO DO: inject service
  //TO DO: constructor

  ConfigState _state = ConfigStateInitial();

  ConfigState get state => _state;

  void _changeState(ConfigState newState) {
    _state = newState;
    notifyListeners();
  }

}