import 'dart:convert';

import 'package:dropill_project/features/config/config_state.dart';
import 'package:dropill_project/services/secure_storage.dart';
import 'package:flutter/foundation.dart';

class ConfigController extends ChangeNotifier {
  final SecureStorage _secureStorage;

  ConfigController(this._secureStorage);

  String? userName;
  String? userEmail;

  ConfigState _state = ConfigStateInitial();

  ConfigState get state => _state;

  void _changeState(ConfigState newState) {
    _state = newState;
    notifyListeners();
  }

  void loadInfos() async {
    try {
      final userString = await _secureStorage.readOne(key: "CURRENT_USER");
      final profileString =
          await _secureStorage.readOne(key: "SELECTED_PROFILE");

      if (userString != null && profileString != null) {
        final jsonProfile = jsonDecode(profileString);
        final jsonUser = jsonDecode(userString);
        print(jsonUser);
        userName = jsonProfile['name'];
        userEmail = jsonUser['email'];
        _changeState(ConfigStateSuccess());
      } else {
        _changeState(ConfigStateError());
      }
    } catch (e) {
      _changeState(ConfigStateError());
    }
  }
}
