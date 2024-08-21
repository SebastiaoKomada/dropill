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
import 'package:dropill_project/features/sign_up/sign_up_controller.dart';
import 'package:dropill_project/features/sign_up/sign_up_state.dart';
import 'package:dropill_project/locator.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _controller = locator.get<SignUpController>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.state is SignUpStateLoading) {
        showDialog(
          context: context,
          builder: (context) => const CustomCircularProgressIndicator(),
        );
      }

      if (_controller.state is SignUpStateSuccess) {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, NamedRoute.sigIn);
      }

      if (_controller.state is SignUpStateError) {
        final error = _controller.state as SignUpStateError;
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 48.0),
            Text(
              'dropill',
              textAlign: TextAlign.center,
              style: AppTextStyles.bigText50.copyWith(color: AppColors.standartBlue),
            ),
            const SizedBox(height: 32.0),
            Text(
              'Crie sua conta!',
              textAlign: TextAlign.center,
              style: AppTextStyles.mediumText30.copyWith(color: AppColors.standartBlue),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: _nameController,
                    labelText: "Seu Nome",
                    hintText: "NOME",
                    inputFormatters: [
                      UpperCaseTextInputFormatter(),
                    ],
                    validator: Validator.validateName,
                  ),
                  CustomTextFormField(
                    controller: _emailController,
                    labelText: "Seu E-mail",
                    hintText: "seunome@email.com",
                    keyboardType: TextInputType.emailAddress,
                    validator: Validator.validateEmail,
                  ),
                  PasswordFormField(
                    controller: _passwordController,
                    helperText: "Crie sua Senha Forte!",
                    labelText: "Escolha Sua Senha",
                    hintText: "********",
                    validator: Validator.validatePassword,
                  ),
                  PasswordFormField(
                    controller: _confirmPasswordController,
                    labelText: "Confirme Sua Senha",
                    hintText: "********",
                    validator: (value) => Validator.validateConfirmPassword(value, _passwordController.text),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: PrimaryButton(
                text: 'Criar conta',
                onPressed: () {
                  final valid = _formKey.currentState != null && _formKey.currentState!.validate();
                  if (valid) {
                    try {
                      _controller.signUp(
                        name: _nameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                    } catch (e) {
                      log('Erro ao registrar: $e');
                      customModalBottomSheet(
                        context,
                        content: 'Erro ao tentar criar a conta. Tente novamente mais tarde.',
                        buttonText: "Voltar",
                      );
                    }
                  } else {
                    log("Erro ao validar o formulário");
                  }
                },
              ),
            ),
            MultiTextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, NamedRoute.sigIn),
              children: [
                Text(
                  'Já possui uma conta? ',
                  style: AppTextStyles.smallText.copyWith(color: AppColors.darkGrey),
                ),
                Text(
                  'Clique aqui! ',
                  style: AppTextStyles.smallText.copyWith(color: AppColors.standartBlue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
