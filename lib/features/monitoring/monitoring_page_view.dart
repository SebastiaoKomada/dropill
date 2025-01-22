import 'package:dropill_project/common/constants/app_colors.dart';
import 'package:dropill_project/common/constants/app_text_styles.dart';
import 'package:dropill_project/common/constants/routes.dart';
import 'package:dropill_project/features/monitoring/monitoring_controller.dart';
import 'package:dropill_project/features/monitoring/monitoring_state.dart';
import 'package:dropill_project/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MonitoringPageView extends StatefulWidget {
  const MonitoringPageView({super.key});

  @override
  State<MonitoringPageView> createState() => _MonitoringPageViewState();
}

class _MonitoringPageViewState extends State<MonitoringPageView> {
  late MonitoringController _monitoringController;


  @override
  void initState() {
    super.initState();
    _monitoringController = locator.get<MonitoringController>();
    _monitoringController.listSymptoms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Como você está se sentindo?',
          style: AppTextStyles.mediumText20
              .copyWith(color: AppColors.standartBlue),
        ),
      ),
      body: AnimatedBuilder(
        animation: _monitoringController,
        builder: (context, child) {
          if (_monitoringController.state is MonitoringStateLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (_monitoringController.state is MonitoringStateSuccess2) {
            final symptoms =
                (_monitoringController.state as MonitoringStateSuccess2)
                    .symptoms;

            if (symptoms.isEmpty) {
              return Center(
                child: Text(
                  'Nenhum medicamento disponível',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.mediumText16w500.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              );
            }

            // Exibe a lista de sintomas em um GridView
            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Número de colunas
                childAspectRatio: 2.2, // Proporção do item
                crossAxisSpacing: 20, // Espaço entre colunas
                mainAxisSpacing: 20, // Espaço entre linhas
              ),
              itemCount: symptoms.length,
              itemBuilder: (context, index) {
                return ElevatedButton(
                    onPressed: () {
                      print("Sintoma selecionado: ${symptoms[index].sin_id}");
                      int sin_id = symptoms[index].sin_id;
                      _monitoringController.createMonitoring(sin_id: sin_id);

                      Navigator.popAndPushNamed(context, NamedRoute.homeView);
                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.standartBlue,
                    minimumSize: const Size(150, 100),
                    padding: EdgeInsets.zero, // Remove o padding padrão
                  ),
                  child: Center(
                    child: Text(
                      symptoms[index].sin_nome, // Exibindo o nome do sintoma
                      style: AppTextStyles.mediumText18
                          .copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            );
          } else if (_monitoringController.state is MonitoringStateError) {
            // Exibir mensagem de erro se a API falhar
            return const Center(
              child: Text('Erro ao carregar sintomas.'),
            );
          } else {
            // Estado inicial ou nenhum dado
            return const Center(
              child: Text('Nenhum dado disponível.'),
            );
          }
        },
      ),
    );
  }
}
