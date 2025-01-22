import 'dart:convert';
import 'dart:developer';
import 'package:dropill_project/common/models/return_monitoring_model.dart';
import 'package:dropill_project/features/monitoring/monitoring_state.dart';
import 'package:dropill_project/services/secure_storage.dart';
import 'package:dropill_project/services/sympton_service.dart';
import 'package:flutter/foundation.dart';

class MonitoringController extends ChangeNotifier {
  final SymptomService _symptomService;
  final SecureStorage _service;

  MonitoringController(this._symptomService, this._service);

  List<ReturnMonitoring> monitoringList = [];


  MonitoringState _state = MonitoringStateInitial();
  MonitoringState get state => _state;

  void _changeState(MonitoringState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> listSymptoms() async {
    _changeState(MonitoringStateLoading());
    try {
      final symptomsList = await _symptomService.getSymptons();
      if (symptomsList.isEmpty) {
        log('Nenhum sintoma encontrado.');
        _changeState(MonitoringStateSuccess2(symptomsList));
      } else {
        print(symptomsList);
        _changeState(MonitoringStateSuccess2(symptomsList));
      }
    } catch (e) {
      _changeState(MonitoringStateError());
      rethrow;
    }
  }

  Future<void> createMonitoring({ required int sin_id }) async {
    print('createMonitoring chamado com sin_id: $sin_id');
    _changeState(SymptomStateLoading());
    try {
      final createMonitoring = await _symptomService.addSymptom(sin_id);
      _changeState(SymptomStateSuccess());
    } catch (e) {
      _changeState(SymptomStateError());
      print('Erro ao criar monitoramento: $e');
    }
  }

  Future<void> listMonitoring() async {
    _changeState(MonitoringStateLoading());
    try {
      final profile = await _service.readOne(key: "SELECTED_PROFILE");

      if (profile != null) {
        final profileData = jsonDecode(profile);
        final int perId = profileData['id'];
        //log(perId.toString());
        monitoringList = await _symptomService.getMonitoringsByProfile(perId);
        if (monitoringList.isEmpty) {
          log('Nenhum monitoramento encontrado para este perfil.');
        }
        _changeState(MonitoringStateSuccess());
      } else {
        _changeState(MonitoringStateError());
      }
    } catch (e) {
      _changeState(MonitoringStateError());
      rethrow;
    }
  }

}
