import 'dart:developer';

import 'package:dropill_project/common/constants/app_colors.dart';
import 'package:dropill_project/common/constants/app_text_styles.dart';
import 'package:dropill_project/common/constants/routes.dart';
import 'package:dropill_project/common/utils/validator.dart';
import 'package:dropill_project/common/widgets/custom_bottom_sheet.dart';
import 'package:dropill_project/common/widgets/custom_circular_progress_indicator.dart';
import 'package:dropill_project/common/widgets/custom_text_fiel.dart';
import 'package:dropill_project/common/widgets/multi_text_button.dart';
import 'package:dropill_project/common/widgets/password_form_field.dart';
import 'package:dropill_project/common/widgets/primary_button.dart';
import 'package:dropill_project/features/sign_in/sign_in_controller.dart';
import 'package:dropill_project/features/sign_in/sign_in_state.dart';
import 'package:dropill_project/locator.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _controller = locator.get<SignInController>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.state is SignInStateLoading) {
        showDialog(
          context: context,
          builder: (context) => const CustomCircularProgressIndicator(),
        );
      }

      if (_controller.state is SignInStateSuccess) {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, NamedRoute.profile);
      }

      if (_controller.state is SignInStateError) {
        final error = _controller.state as SignInStateError;
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
              'Bem-vindo!',
              textAlign: TextAlign.center,
              style: AppTextStyles.mediumText30.copyWith(color: AppColors.standartBlue),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: _emailController,
                    labelText: "Seu E-mail",
                    hintText: "seunome@email.com",
                    keyboardType: TextInputType.emailAddress,
                    validator: Validator.validateEmail,
                  ),
                  PasswordFormField(
                    controller: _passwordController,
                    labelText: "Escolha Sua Senha",
                    hintText: "********",
                    validator: Validator.validatePassword,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: PrimaryButton(
                text: 'Entrar',
                onPressed: () {
                  final valid = _formKey.currentState != null && _formKey.currentState!.validate();
                  if (valid) {
                    _controller.signIn(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                  } else {
                    log("erro ao logar");
                  }
                },
              ),
            ),
            MultiTextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, NamedRoute.initial),
              children: [
                Text(
                  'Não possui uma conta? ',
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
