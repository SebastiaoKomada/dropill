import 'package:dropill_project/common/constants/app_colors.dart';
import 'package:dropill_project/common/constants/app_text_styles.dart';
import 'package:dropill_project/common/constants/routes.dart';
import 'package:dropill_project/common/models/profile_model.dart';
import 'package:dropill_project/services/profile_service.dart';
import 'package:dropill_project/services/secure_storage.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService _profileService = ProfileService(const SecureStorage());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.standartBlue,
      body: Center(
        child: FutureBuilder(
          future: _profileService.listProfiles(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text(
                'Erro ao carregar perfil',
                style: AppTextStyles.mediumText18.copyWith(color: AppColors.white),
              );
            } else if (snapshot.hasData) {
              final profiles = snapshot.data as List<ProfileModel>;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 64),
                  Text(
                    'Quem é você?',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.mediumText30.copyWith(color: AppColors.white),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: profiles.length,
                      itemBuilder: (context, index) {
                        final profile = profiles[index];
                        return Column(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(64.0),
                              onTap: () {
                                _profileService.saveProfileId(profile);
                                Navigator.popAndPushNamed(context, NamedRoute.homeView);
                              },
                              child: CircleAvatar(
                                backgroundColor: AppColors.white,
                                radius: 80,
                                backgroundImage: (profile.foto != null && profile.foto!.isNotEmpty)
                                    ? NetworkImage(profile.foto!) as ImageProvider<Object>?
                                    : const AssetImage('assets/images/default.png') as ImageProvider<Object>?,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              profile.name ?? 'Nome não disponível',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.mediumText18.copyWith(color: AppColors.white),
                            ),
                            const SizedBox(height: 32),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}