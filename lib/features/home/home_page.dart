import 'package:dropill_project/common/constants/app_colors.dart';
import 'package:dropill_project/common/constants/app_text_styles.dart';
import 'package:dropill_project/common/widgets/custom_medication_list.dart';
import 'package:dropill_project/features/home/home_controller.dart';
import 'package:dropill_project/features/home/home_state.dart';
import 'package:dropill_project/locator.dart';
import 'package:dropill_project/services/secure_storage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeController _homeController;
  final SecureStorage _secureStorage = SecureStorage();

  @override
  void initState() {
    super.initState();
    _homeController = locator.get<HomeController>();
    _homeController.existsIdProfile();
    _homeController.listMedications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _homeController,
        builder: (context, child) {
          if (_homeController.state is HomeStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (_homeController.state is HomeStateError) {
            return const Center(
              child: Text('Erro ao carregar dados',
                  style: TextStyle(color: Colors.red)),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48.0),
                Row(
                  children: [
                    Text(
                      'Olá, ${_homeController.userName ?? 'Usuário'}',
                      style: AppTextStyles.mediumText20
                          .copyWith(color: AppColors.standartBlue),
                    ),
                  ],
                ),
                _homeController.medicationsList.isNotEmpty
                    ? CustomMedicationList(
                        secureStorage: _secureStorage,
                        medications: _homeController.medicationsList,
                      )
                    : Container(
                        alignment: Alignment.center,
                        height: 120,
                        child: Text(
                          'Nenhum medicamento disponível',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.mediumText16w500
                              .copyWith(color: AppColors.grey),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
