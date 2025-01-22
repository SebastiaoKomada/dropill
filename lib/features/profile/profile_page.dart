import 'package:dropill_project/common/constants/app_colors.dart';
import 'package:dropill_project/common/constants/app_text_styles.dart';
import 'package:dropill_project/common/constants/routes.dart';
import 'package:dropill_project/common/models/profile_model.dart';
import 'package:dropill_project/features/profile/profile_controller.dart';
import 'package:dropill_project/locator.dart';
import 'package:dropill_project/services/profile_service.dart';
import 'package:dropill_project/services/secure_storage.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileController _profileController;
  final SecureStorage _secureStorage = SecureStorage();
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _profileController = locator.get<ProfileController>();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.standartBlue,
      body: Stack(
        children: [
          if (_isEditMode)
            GestureDetector(
              onTap: () {},
              child: Container(
                color: AppColors.black.withOpacity(0.5),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: FutureBuilder(
                future: _profileController.listProfiles(),
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
                      children: [
                        const SizedBox(height: 64),
                        Text(
                          'Quem é você?',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.mediumText30.copyWith(color: AppColors.white),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.all(16.0),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16.0,
                            ),
                            itemCount: profiles.length + 1,
                            itemBuilder: (context, index) {
                              if (index < profiles.length) {
                                final profile = profiles[index];
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          borderRadius: BorderRadius.circular(64.0),
                                          onTap: () {
                                            if (_isEditMode) {
                                            } else {
                                              _profileController.saveProfileId(profile);
                                              Navigator.popAndPushNamed(context, NamedRoute.homeView);
                                            }
                                          },
                                          child: CircleAvatar(
                                            backgroundColor: AppColors.white,
                                            radius: 60,
                                            backgroundImage: (profile.foto != null && profile.foto!.isNotEmpty)
                                                ? NetworkImage(profile.foto!) as ImageProvider<Object>?
                                                : const AssetImage('assets/images/default.png') as ImageProvider<Object>?,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          profile.name ?? 'Nome não disponível',
                                          textAlign: TextAlign.center,
                                          style: AppTextStyles.mediumText18.copyWith(color: AppColors.white),
                                        ),
                                      ],
                                    ),
                                    if (_isEditMode)
                                      Positioned(
                                        top: 45,
                                        right: 65,
                                        child: InkWell(
                                          onTap: () {
                                            _profileController.saveProfileId(profile);
                                            Navigator.pushNamed(
                                              context,
                                              NamedRoute.profileEdit,
                                              arguments: profile,
                                            );
                                          },
                                          child: const Icon(
                                            Icons.edit,
                                            color: Colors.red,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              } else {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 16),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(64.0),
                                      onTap: () {
                                        if (_isEditMode) {
                                        } else {
                                          Navigator.pushNamed(context, NamedRoute.profileAdd);
                                        }
                                      },
                                      child: const CircleAvatar(
                                        backgroundColor: AppColors.white,
                                        radius: 60,
                                        child: Icon(
                                          Icons.add,
                                          color: AppColors.black,
                                          size: 70,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                );
                              }
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
          ),
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: _toggleEditMode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isEditMode ? AppColors.grey : AppColors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text(
                  _isEditMode ? 'Cancelar' : 'Editar Perfis',
                  style: AppTextStyles.mediumText18.copyWith(
                    color: _isEditMode ? AppColors.white : AppColors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
