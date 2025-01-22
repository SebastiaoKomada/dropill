import 'dart:convert';
import 'dart:developer';

import 'package:dropill_project/common/models/profile_model.dart';
import 'package:dropill_project/features/profile/profile_state.dart';
import 'package:dropill_project/services/profile_service.dart';
import 'package:dropill_project/services/secure_storage.dart';
import 'package:flutter/foundation.dart';

class ProfileController extends ChangeNotifier {
  final ProfileService _service;
  final SecureStorage _secureStorage;

  ProfileController(this._service, this._secureStorage);

  ProfileState _state = ProfileStateInitial();

  ProfileState get state => _state;

  String? userName;

  void _changeState(ProfileState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<List<ProfileModel>> listProfiles() async {
    _changeState(ProfileStateLoading());
    try {
      final profiles = await _service.listProfiles();
      _changeState(ProfileStateSuccess2(profiles));
      return profiles;
    } catch (e) {
      _changeState(ProfileStateError());
      rethrow;
    }
  }

  Future<void> saveProfileId(ProfileModel profile) async {
    try {
      final setProfile = {
        'id': profile.id,
        'name': profile.name,
      };
      final jsonProfile = jsonEncode(setProfile);
      await _secureStorage.write(key: 'SELECTED_PROFILE', value: jsonProfile);
    } catch (e) {
      print('Erro ao salvar ID do perfil no Secure Storage: $e');
    }
  }

  Future<void> createProfile({
    required String name,
  }) async {
    _changeState(ProfileStateLoading());
    const secureStorage = SecureStorage();
    try {
      final user = await _service.createProfile(name: name);
      _changeState(ProfileStateSuccess());
    } catch (e) {
      _changeState(ProfileStateError());
    }
  }

  Future<void> editProfile({
    required String name,
  }) async {
    _changeState(ProfileStateLoading());
    const secureStorage = SecureStorage();
    try {
      final user = await _service.editProfile(name: name);
      _changeState(ProfileStateSuccess());
    } catch (e) {
      _changeState(ProfileStateError());
    }
  }

  Future<void> existsIdProfile() async {
    _changeState(ProfileStateEditLoading());
    try {
      final jsonString = await _secureStorage.readOne(key: "SELECTED_PROFILE");
      if (jsonString != null) {
        final jsonProfile = jsonDecode(jsonString);
        userName = jsonProfile['name'];
        _changeState(ProfileStateEditSuccess());
      } else {
        _changeState(ProfileStateEditError());
      }
    } catch (e) {
      _changeState(ProfileStateEditError());
    }
  }

  Future<void> deleteProfile() async {
    _changeState(ProfileStateLoading());
    try {
      await _service.deleteProfile();
      _changeState(ProfileStateSuccess());
    } catch (e) {
      print('Erro ao buscar o perfil: $e');
      _changeState(ProfileStateError());
      rethrow;
    }
  }
}
