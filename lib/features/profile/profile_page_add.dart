import 'dart:developer';

import 'package:dropill_project/common/constants/app_colors.dart';
import 'package:dropill_project/common/constants/app_text_styles.dart';
import 'package:dropill_project/common/constants/routes.dart';
import 'package:dropill_project/common/utils/uppercase_text_fomatter.dart';
import 'package:dropill_project/common/utils/validator.dart';
import 'package:dropill_project/common/widgets/custom_bottom_sheet.dart';
import 'package:dropill_project/common/widgets/custom_circular_progress_indicator.dart';
import 'package:dropill_project/common/widgets/custom_text_fiel.dart';
import 'package:dropill_project/common/widgets/multi_text_button.dart';
import 'package:dropill_project/common/widgets/password_form_field.dart';
import 'package:dropill_project/common/widgets/primary_button.dart';
import 'package:dropill_project/common/widgets/secundary_button.dart';
import 'package:dropill_project/features/profile/profile_controller.dart';
import 'package:dropill_project/features/profile/profile_state.dart';
import 'package:dropill_project/features/sign_in/sign_in_controller.dart';
import 'package:dropill_project/features/sign_in/sign_in_state.dart';
import 'package:dropill_project/locator.dart';
import 'package:flutter/material.dart';

class ProfilePageAdd extends StatefulWidget {
  const ProfilePageAdd({super.key});

  @override
  State<ProfilePageAdd> createState() => _SignInPageState();
}

class _SignInPageState extends State<ProfilePageAdd> {
  late ProfileController _profileController;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _profileController = locator.get<ProfileController>();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Novo Perfil',
          style: AppTextStyles.mediumText24
              .copyWith(color: AppColors.standartBlue),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Expanded(
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
                        hintText: "NOME",
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: SecundaryButton(
                    text: 'Cadastrar',
                    onPressed: () {
                      final valid = _formKey.currentState != null &&
                          _formKey.currentState!.validate();
                      if (valid) {
                        _profileController.createProfile(
                          name: _nameController.text,
                        );
                      } else {
                        log("erro ao cadastrar");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
