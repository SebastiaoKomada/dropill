import 'dart:convert';
import 'dart:developer';

import 'package:dropill_project/common/models/medication_model.dart';
import 'package:dropill_project/features/home/home_state.dart';
import 'package:dropill_project/services/medication_service.dart';
import 'package:dropill_project/services/secure_storage.dart';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  final SecureStorage _service;
  final MedicationService _medicationService;

  HomeController(this._service, this._medicationService);

  String? userName;
  int? perId;
  List<MedicationModel> medicationsList = [];

  HomeState _state = HomeStateInitial();

  HomeState get state => _state;

  void _changeState(HomeState newState) {
    _state = newState;
    notifyListeners();
  }

  void existsIdProfile() async {
    try {
      final jsonString = await _service.readOne(key: "SELECTED_PROFILE");
      //log(jsonString.toString());
      if (jsonString != null) {
        final jsonProfile = jsonDecode(jsonString);
        userName = jsonProfile['name'];
        _changeState(HomeStateSuccess());
      } else {
        _changeState(HomeStateError());
      }
    } catch (e) {
      _changeState(HomeStateError());
    }
  }

  Future<void> listMedications() async {
    _changeState(HomeStateLoading());
    try {
      final profile = await _service.readOne(key: "SELECTED_PROFILE");
      
      if (profile != null) {
        final profileData = jsonDecode(profile);
        //log(profileData.toString());
        final int perId = profileData['id'];
        log(perId.toString());
        medicationsList = await _medicationService.getMedicationsByProfile(perId);
        if (medicationsList.isEmpty) {
          log('Nenhum medicamento encontrado para este perfil.');
        }
        _changeState(HomeStateSuccess());
      } else {
        _changeState(HomeStateError());
      }
    } catch (e) {
      _changeState(HomeStateError());
      rethrow;
    }
  }
}
