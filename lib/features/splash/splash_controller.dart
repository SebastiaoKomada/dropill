import 'package:dropill_project/features/splash/splash_state.dart';
import 'package:dropill_project/services/secure_storage.dart';
import 'package:flutter/foundation.dart';

class SplashController extends ChangeNotifier {
  final SecureStorage _service;

  SplashController(this._service);

  SplashState _state = SplashStateInitial();

  SplashState get state => _state;

  void _changeState(SplashState newState) {
    _state = newState;
    notifyListeners();
  }

  void isUserLogged() async {
    //await _service.deleteOne(key: "CURRENT_USER");
    //await _service.deleteOne(key: "SELECTED_PROFILE");
    final result = await _service.readOne(key: "CURRENT_USER");
    if (result != null) {
      _changeState(SplashStateSuccess());
    } else {
      _changeState(SplashStateError());
    }
  }
}
