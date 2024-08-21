import 'dart:convert';

import 'package:dropill_project/common/models/profile_model.dart';
import 'package:dropill_project/services/secure_storage.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  final SecureStorage _secureStorage;

  ProfileService(this._secureStorage);

  final String apiUrl = 'http://10.0.2.2:8000';

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
}
