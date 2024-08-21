import 'package:dropill_project/common/models/profile_model.dart';
import 'package:dropill_project/features/profile/profile_state.dart';
import 'package:dropill_project/services/profile_service.dart';
import 'package:flutter/foundation.dart';

class ProfileController extends ChangeNotifier {
  final ProfileService _service;

  ProfileController(this._service);

  ProfileState _state = ProfileStateInitial();

  ProfileState get state => _state;

  void _changeState(ProfileState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<List<ProfileModel>> listProfiles() async {
    _changeState(ProfileStateLoading());
    try {
      final profiles = await _service.listProfiles();
      _changeState(ProfileStateSuccess(profiles));
      return profiles;
    } catch (e) {
      _changeState(ProfileStateError());
      rethrow;
    }
  }
}
