import 'dart:convert';
import 'dart:developer';

import 'package:dropill_project/common/constants/app_colors.dart';
import 'package:dropill_project/common/constants/app_text_styles.dart';
import 'package:dropill_project/common/constants/routes.dart';
import 'package:dropill_project/common/utils/uppercase_text_fomatter.dart';
import 'package:dropill_project/common/utils/validator.dart';
import 'package:dropill_project/common/widgets/custom_bottom_sheet.dart';
import 'package:dropill_project/common/widgets/custom_circular_progress_indicator.dart';
import 'package:dropill_project/common/widgets/custom_text_fiel.dart';
import 'package:dropill_project/common/widgets/secundary_button.dart';
import 'package:dropill_project/features/profile/profile_controller.dart';
import 'package:dropill_project/features/profile/profile_state.dart';
import 'package:dropill_project/features/sign_in/sign_in_state.dart';
import 'package:dropill_project/locator.dart';
import 'package:dropill_project/services/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePageEdit extends StatefulWidget {
  const ProfilePageEdit({super.key});

  @override
  State<ProfilePageEdit> createState() => _ProfilePageEditState();
}

class _ProfilePageEditState extends State<ProfilePageEdit> {
  late ProfileController _profileController;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final SecureStorage _secureStorage = SecureStorage();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _profileController = locator.get<ProfileController>();
    super.initState();
    _profileController.existsIdProfile();

    _profileController.addListener(() {
      if (_profileController.state is ProfileStateLoading) {
        showDialog(
          context: context,
          builder: (context) => const CustomCircularProgressIndicator(),
        );
      }

      if (_profileController.state is ProfileStateSuccess) {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, NamedRoute.profile);
      }

      if (_profileController.state is ProfileStateError) {
        final error = _profileController.state as SignInStateError;
        Navigator.pop(context);
        customModalBottomSheet(
          context,
          content: error.message,
          buttonText: "Voltar",
        );
      }
    });
  }

  void _deleteProfile() async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Excluir Perfil"),
        content: const Text("Tem certeza que deseja excluir este perfil?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Excluir"),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      try {
        await _profileController.deleteProfile();
      } catch (e) {
        customModalBottomSheet(
          context,
          content: 'Erro ao excluir o perfil: $e',
          buttonText: "Voltar",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editar Perfil',
          style: AppTextStyles.mediumText24.copyWith(color: AppColors.standartBlue),
        ),
      ),
      body: AnimatedBuilder(
        animation: _profileController,
        builder: (context, child) {
          if (_profileController.state is ProfileStateEditLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (_profileController.state is ProfileStateEditError) {
            return const Center(
              child: Text('Erro ao carregar dados', style: TextStyle(color: Colors.red)),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          controller: _nameController,
                          labelText: "Seu Nome",
                          hintText: _profileController.userName ?? '',
                          keyboardType: TextInputType.name,
                          validator: Validator.validateName,
                          inputFormatters: [
                            UpperCaseTextInputFormatter(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: SecundaryButton(
                      text: 'Excluir',
                      onPressed: _deleteProfile,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: SecundaryButton(
                      text: 'Editar',
                      onPressed: () {
                        final valid = _formKey.currentState != null && _formKey.currentState!.validate();
                        if (valid) {
                          _profileController.editProfile(
                            name: _nameController.text,
                          );
                        } else {
                          log("erro ao editar");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}