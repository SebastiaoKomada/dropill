import 'dart:convert';
import 'dart:developer';

import 'package:dropill_project/features/medication/medication_state.dart';
import 'package:dropill_project/services/secure_storage.dart';
import 'package:flutter/material.dart';

import '../../services/medication_service.dart';

class MedicationController extends ChangeNotifier {
  final MedicationService _medicationService;
  final SecureStorage _secureStorage;
  MedicationState _state = MedicationStateInitial();

  MedicationController(this._medicationService, this._secureStorage);

  MedicationState get state => _state;

  void _changeState(MedicationState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> createMedicationWithTimes({
    required String nome,
    required String descricao,
    required String tipo,
    required int quantidade,
    required DateTime dataAtual,
    required DateTime dataFinal,
    required bool estado,
    required List<TimeOfDay> times,
  }) async {
    _changeState(MedicationStateLoading());

    try {
      final newMedication = await _medicationService.createMedication(
        nome: nome,
        descricao: descricao,
        tipo: tipo,
        quantidade: quantidade,
        dataAtual: dataAtual,
        dataFinal: dataFinal,
        estado: estado,
      );

      //log('Medicação criada: ${newMedication.toString()}');

      if (times.isNotEmpty) {
        await _medicationService.createTimes(
          times: times,
          medId: newMedication.id!,
        );
      }

      _changeState(MedicationStateSuccess());
    } catch (e) {
      log('Erro ao criar medicação ou horários: $e');
      _changeState(MedicationStateError());
      rethrow;
    }
  }

  Future<void> getMedication() async {
    _changeState(MedicationStateLoading());
    try {
      final medID = await _secureStorage.readOne(key: "MEDICATION_ID");
      //print(medID);
      if (medID != null) {
        final result = jsonDecode(medID);
        final medication = await _medicationService.getMedicationsById(result);

        _changeState(getMedicationStateSuccess(medication));
      } else {
        print("No medication ID found.");
        _changeState(MedicationStateError());
      }
    } catch (e) {
      log('Erro ao buscar a medicação: $e');
      _changeState(MedicationStateError());
      rethrow;
    }
  }

  Future<void> deleteMedication() async {
    _changeState(MedicationStateLoading());
    try {
      final medID = await _secureStorage.readOne(key: "MEDICATION_ID");
      if (medID != null) {
        final result = jsonDecode(medID);
        final medication = await _medicationService.deleteMedication(result);

        _changeState(MedicationStateSuccess());
      } else {
        print("No medication ID found.");
        _changeState(MedicationStateError());
      }
    } catch (e) {
      log('Erro ao buscar a medicação: $e');
      _changeState(MedicationStateError());
      rethrow;
    }
  }
}
