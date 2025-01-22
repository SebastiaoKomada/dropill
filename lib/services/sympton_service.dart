import 'dart:convert';
import 'dart:developer';

import 'package:dropill_project/common/models/return_monitoring_model.dart';
import 'package:dropill_project/common/models/sympton_model.dart';
import 'package:dropill_project/services/secure_storage.dart';

import 'package:http/http.dart' as http;

class SymptomService {
  final String apiUrl = 'https://dropill-api.onrender.com';

  final SecureStorage _secureStorage;

  SymptomService(this._secureStorage);

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  Future<List<SymptomModel>> getSymptons() async {
    final String url = '$apiUrl/monitoring/';
    try {
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((symptons) {
          return SymptomModel.fromMap(symptons as Map<String, dynamic>);
        }).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception(
            'Falha ao obter sintomas. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      log('Erro ao obter sintomas: $e');
      throw Exception('Erro ao obter sintomas: $e');
    }
  }

  Future addSymptom(int sin_id) async {
    final result = await _secureStorage.readOne(key: "SELECTED_PROFILE");
    if (result != null) {
      try {
        Map<String, dynamic> userData = jsonDecode(result);
        int profileId = userData['id'];
        print("ID: $profileId");

        final String url = '$apiUrl/monitoring/';
        final Map<String, String> queryParams = {
          'per_id': profileId.toString(),
          'sin_id': sin_id.toString(),
        };

        final response = await http.post(
          Uri.parse(url).replace(queryParameters: queryParams),
          headers: headers,
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          return responseData;
        } else {
          log('Erro ao adicionar sintoma. Código de status: ${response.statusCode}');
          throw Exception('Erro ao adicionar sintoma: ${response.body}');
        }
      } catch (e) {
        log('Erro ao processar resposta: $e');
        throw Exception('Erro ao processar resposta: $e');
      }
    } else {
      throw Exception('Perfil não encontrado no armazenamento seguro');
    }
  }

  Future<List<ReturnMonitoring>> getMonitoringsByProfile(int profileId) async {
    final String url = '$apiUrl/monitoring/byPerId/$profileId';

    try {
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        print(responseData.toString());
        return responseData.map((med) {
          return ReturnMonitoring.fromMap(med as Map<String, dynamic>);
        }).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception(
            'Falha ao obter monitoramentos. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      log('Erro ao obter monitoramentos: $e');
      throw Exception('Erro ao obter monitoramentos: $e');
    }
  }

}
