import 'dart:convert';
import 'dart:developer';

import 'package:dropill_project/common/models/medication_model.dart';
import 'package:dropill_project/services/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class MedicationService {
  final String apiUrl = 'https://dropill-api.onrender.com';
  final SecureStorage _secureStorage;

  MedicationService(this._secureStorage);

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  Future<MedicationModel> getMedication(int medId) async {
    final String url = '$apiUrl/medications/$medId';

    try {
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return MedicationModel.fromMap(responseData);
      } else if (response.statusCode == 404) {
        throw Exception('Medicação não encontrada');
      } else {
        throw Exception(
            'Erro ao obter a medicação. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao obter medicação: $e');
    }
  }

  Future<List<MedicationModel>> getMedicationsByProfile(int profileId) async {
    final String url = '$apiUrl/medication/profile/$profileId';

    try {
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((med) {
          return MedicationModel.fromMap(med as Map<String, dynamic>);
        }).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception(
            'Falha ao obter medicamentos. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      log('Erro ao obter medicamentos: $e');
      throw Exception('Erro ao obter medicamentos: $e');
    }
  }

  Future<List<MedicationModel>> getMedicationsById(int medId) async {
    final medID = await _secureStorage.readOne(key: "MEDICATION_ID");
    if (medID != null) {
      final result = jsonDecode(medID);

      final String url = '$apiUrl/medication/$result';
      //print('Request URL: $url');

      try {
        final http.Response response = await http.get(Uri.parse(url));

        print('Response Body: ${response.body}');

        if (response.statusCode == 200) {
          final dynamic responseData = jsonDecode(response.body);

          if (responseData is Map<String, dynamic>) {
            return [MedicationModel.fromMap(responseData)];
          } else {
            throw Exception('Formato de resposta inesperado');
          }
        } else if (response.statusCode == 404) {
          print('No medications found (404)');
          return [];
        } else {
          throw Exception(
              'Falha ao obter medicamentos. Código de status: ${response.statusCode}');
        }
      } catch (e) {
        log('Erro ao obter medicamentos: $e');
        throw Exception('Erro ao obter medicamentos: $e');
      }
    } else {
      throw Exception('User data not found');
    }
  }

  Future<MedicationModel> createMedication({
    required String nome,
    required String descricao,
    required String tipo,
    required int quantidade,
    required DateTime dataAtual,
    required DateTime dataFinal,
    required bool estado,
  }) async {
    final String? profileIdStr =
        await _secureStorage.readOne(key: 'SELECTED_PROFILE');

    if (profileIdStr == null) {
      throw Exception('Perfil não autenticado');
    }

    final Map<String, dynamic> profileData = jsonDecode(profileIdStr);
    final int profileId = profileData['id'];
    final String url = '$apiUrl/medication/$profileId';

    final Map<String, dynamic> bodyData = {
      'med_nome': nome,
      'med_descricao': descricao,
      'med_tipo': tipo,
      'med_quantidade': quantidade,
      'med_dataInicio': dataAtual.toIso8601String(),
      'med_dataFinal': dataFinal.toIso8601String(),
      'med_estado': estado,
      'perId': profileId,
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(bodyData),
      );

      log('Request Body: ${jsonEncode(bodyData)}');
      log('Response Status Code: ${response.statusCode}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return MedicationModel.fromMap(responseData);
      } else if (response.statusCode == 404) {
        throw Exception('Perfil não encontrado');
      } else {
        throw Exception(
            'Erro ao criar a medicação. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao criar medicação: $e');
    }
  }

  Future<void> createTimes({
    required List<TimeOfDay> times,
    required int medId,
  }) async {
    final String url = '$apiUrl/time/$medId';

    try {
      for (var time in times) {
        final Map<String, dynamic> timeData = {
          'hor_horario':
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
          'hor_medicacao': medId,
        };

        log('Requesting to: $url with data: $timeData');

        final http.Response response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(timeData),
        );

        log('Response Status Code: ${response.statusCode}');
        log('Response Body: ${response.body}');

        if (response.statusCode != 200 && response.statusCode != 201) {
          throw Exception(
              'Não foi possível criar o horário. Código de status: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception('Erro ao criar horários: $e');
    }
  }

  Future<void> deleteMedication(int medId) async {
    final String url = '$apiUrl/medication/$medId';

    try {
      final http.Response response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        log('Medicação deletada com sucesso.');
      } else if (response.statusCode == 404) {
        throw Exception('Medicação não encontrada.');
      } else {
        throw Exception(
            'Erro ao deletar a medicação. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      log('Erro ao deletar medicação: $e');
      throw Exception('Erro ao deletar medicação: $e');
    }
  }
}
