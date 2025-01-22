import 'dart:convert';

import 'package:dropill_project/common/models/user_model.dart';
import 'package:dropill_project/services/auth_service.dart';
import 'package:dropill_project/services/secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserService implements AuthService {
  final String apiUrl = 'https://dropill-api.onrender.com';
  final SecureStorage _secureStorage;

  UserService(this._secureStorage);

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final signInUrl = '$apiUrl/auth/login';

    try {
      final signInResponse = await http.post(
        Uri.parse(signInUrl),
        headers: headers,
        body: jsonEncode({
          'usu_email': email,
          'usu_senha': password,
        }),
      );

      print('Response body: ${signInResponse.body}');

      if (signInResponse.statusCode == 200) {
        final responseData = jsonDecode(signInResponse.body);
        final id = responseData['id'];
        return UserModel(
          id: id,
          email: email,
        );
      } else if (signInResponse.statusCode == 401) {
        throw Exception('Credenciais inválidas');
      } else {
        throw Exception(
            'Não foi possível fazer login. Código de status: ${signInResponse.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao realizar login: $e');
    }
  }

  @override
  Future<UserModel> signUp({
    String? name,
    required String email,
    required String password,
  }) async {
    final signUpUrl = '$apiUrl/auth/register';

    String? fcmToken = await _secureStorage.readOne(key: 'fcmToken');

    try {
      final signUpResponse = await http.post(
        Uri.parse(signUpUrl),
        headers: headers,
        body: jsonEncode({
          'per_nome': name,
          'usu_email': email,
          'usu_senha': password,
          'fcm_token': fcmToken,
        }),
      );

      if (signUpResponse.statusCode == 201) {
        return UserModel(
          name: name,
          email: email,
        );
      } else if (signUpResponse.statusCode == 400) {
        final responseData = jsonDecode(signUpResponse.body);
        if (responseData['detail'] == 'Email already registered') {
          throw Exception('Email já cadastrado. Tente outro');
        } else {
          throw Exception('Não foi possível criar a sua conta');
        }
      } else {
        throw Exception('Não foi possível criar a sua conta');
      }
    } catch (e) {
      throw Exception('Erro ao registrar usuário: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      throw Exception('Erro ao realizar logout: $e');
    }
  }
}
