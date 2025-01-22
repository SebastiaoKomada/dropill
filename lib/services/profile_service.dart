import 'dart:convert';
import 'dart:developer';

import 'package:dropill_project/common/models/profile_model.dart';
import 'package:dropill_project/services/secure_storage.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  final SecureStorage _secureStorage;

  ProfileService(this._secureStorage);

  final String apiUrl = 'https://dropill-api.onrender.com';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  Future<List<ProfileModel>> listProfiles() async {
    final result = await _secureStorage.readOne(key: "CURRENT_USER");
    if (result != null) {
      Map<String, dynamic> userData = jsonDecode(result);
      int userId = userData['id'];
      final profileUrl = '$apiUrl/profile/$userId';

      try {
        var response = await http.get(Uri.parse(profileUrl));

        if (response.statusCode == 200) {
          final List<dynamic> profileData = jsonDecode(response.body);
          if (profileData.isNotEmpty) {
            List<ProfileModel> profiles = profileData.map((profile) {
              return ProfileModel(
                id: profile['per_id'],
                name: profile['per_nome'],
                usuId: userId,
                foto: profile['per_foto'] ?? '',
              );
            }).toList();
            return profiles;
          } else {
            throw Exception('Profile data is empty');
          }
        } else {
          throw Exception('Failed to load profile: ${response.body}');
        }
      } catch (e) {
        throw Exception('Error loading profile: $e');
      }
    } else {
      throw Exception('User data not found');
    }
  }

  Future<ProfileModel> createProfile({
    required String name,
  }) async {
    final userString = await _secureStorage.readOne(key: "CURRENT_USER");

    if (userString != null) {
      final jsonUser = jsonDecode(userString);
      final userID = jsonUser['id'];

      final createProfileUrl = '$apiUrl/profile/$userID';

      try {
        final createResponse = await http.post(
          Uri.parse(createProfileUrl),
          headers: headers,
          body: jsonEncode({
            'per_nome': name,
          }),
        );

        print('Response body: ${createResponse.body}');
        if (createResponse.statusCode == 200) {
          final profileJson = jsonDecode(createResponse.body);
          return ProfileModel.fromJson(createResponse.body);
        } else if (createResponse.statusCode == 401) {
          throw Exception('Credenciais inválidas');
        } else {
          throw Exception(
              'Não foi possível criar o perfil. Código de status: ${createResponse.statusCode}');
        }
      } catch (e) {
        throw Exception('Erro ao criar o perfil: $e');
      }
    } else {
      throw Exception('Usuário não encontrado');
    }
  }

  Future<ProfileModel> editProfile({
    required String name,
  }) async {
    final profileString = await _secureStorage.readOne(key: "SELECTED_PROFILE");

    if (profileString != null) {
      final jsonUser = jsonDecode(profileString);
      final profileID = jsonUser['id'];

      final editProfileUrl = '$apiUrl/profile/alterName/$profileID';

      try {
        final createResponse = await http.patch(
          Uri.parse(editProfileUrl),
          headers: headers,
          body: jsonEncode({
            'per_nome': name,
          }),
        );

        print('Response body: ${createResponse.body}');
        if (createResponse.statusCode == 200) {
          final profileJson = jsonDecode(createResponse.body);
          return ProfileModel.fromJson(createResponse.body);
        } else if (createResponse.statusCode == 401) {
          throw Exception('Credenciais inválidas');
        } else {
          throw Exception(
              'Não foi possível editar o perfil. Código de status: ${createResponse.statusCode}');
        }
      } catch (e) {
        throw Exception('Erro ao editar o perfil: $e');
      }
    } else {
      throw Exception('Perfil não encontrado');
    }
  }

  Future<void> deleteProfile() async {
    final profileString = await _secureStorage.readOne(key: "SELECTED_PROFILE");
    if (profileString != null) {
      final jsonUser = jsonDecode(profileString);
      final profileID = jsonUser['id'];

      final deleteProfileUrl = '$apiUrl/profile/$profileID';

      try {
        final http.Response response = await http.delete(
          Uri.parse(deleteProfileUrl),
          headers: headers,
        );

        if (response.statusCode == 200) {
          log('Perfil deletado com sucesso.');
        } else if (response.statusCode == 404) {
          throw Exception('Perfil não encontrada.');
        } else {
          throw Exception(
              'Erro ao deletar o perfil. Código de status: ${response
                  .statusCode}');
        }
      } catch (e) {
        log('Erro ao deletar perfil: $e');
        throw Exception('Erro ao deletar perfil: $e');
      }
    }
  }
}
