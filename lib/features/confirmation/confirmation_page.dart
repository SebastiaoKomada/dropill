import 'package:flutter/material.dart';
import 'package:dropill_project/common/constants/app_colors.dart';
import 'package:dropill_project/common/constants/app_text_styles.dart';
import 'package:dropill_project/common/constants/routes.dart';
import 'package:dropill_project/common/widgets/primary_button.dart';
import 'package:dropill_project/features/confirmation/confirmation_controller.dart';
import 'package:dropill_project/locator.dart';

class ConfirmationPage extends StatefulWidget {
  const ConfirmationPage({super.key});

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  final ConfirmationController _confirmationController =
  locator<ConfirmationController>();

  Map<String, dynamic>? data;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    print('Data: $data');
  }

  Future<void> confirm() async {
    if (data != null) {
      setState(() {
        _isLoading = true;
      });

      final conId = data?['con_id'] != null
          ? int.tryParse(data!['con_id'].toString()) ?? 0
          : 0;
      print(conId);
      try {
        await _confirmationController.confirmMedication(conId);
        Navigator.pushNamedAndRemoveUntil(
          context,
          NamedRoute.homeView,
              (route) => false,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Confirme Agora',
          style: AppTextStyles.mediumText24
              .copyWith(color: AppColors.standartBlue),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.standartBlue,
                size: 80,
              ),
              const SizedBox(height: 20),
              Text(
                'Você está quase lá!',
                style: AppTextStyles.mediumText24.copyWith(
                  color: AppColors.standartBlue,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Confirme a medicação abaixo para completar o processo.',
                style: AppTextStyles.mediumText18.copyWith(
                  color: AppColors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Text(
                'Nome: ${data?['med_nome'] ?? 'Desconhecido'}',
                style: AppTextStyles.mediumText24.copyWith(color: AppColors.grey),
              ),
              Text(
                'Horário: ${data?['horario'] ?? 'Desconhecido'}',
                style: AppTextStyles.mediumText24.copyWith(color: AppColors.grey),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                text: 'Confirmar',
                onPressed: () async {
                  await confirm();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
