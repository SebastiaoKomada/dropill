import 'dart:convert';
import 'package:dropill_project/common/models/confirmation_model.dart';
import 'package:dropill_project/services/secure_storage.dart';
import 'package:http/http.dart' as http;

class ConfirmationService {
  final String apiUrl = 'http://10.0.2.2:8000';
  final SecureStorage _secureStorage;

  ConfirmationService(this._secureStorage);

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  Future<bool> confirmMedication({
    required int con_id,
  }) async {
    final url = Uri.parse('$apiUrl/confirmation/$con_id');

    final response = await http.post(
      url,
      headers: headers,
    );

    return true;
  }
}
