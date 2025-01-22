import 'package:dropill_project/common/constants/app_colors.dart';
import 'package:dropill_project/common/constants/app_text_styles.dart';
import 'package:dropill_project/common/constants/routes.dart';
import 'package:dropill_project/features/medication/medication_state.dart';
import 'package:flutter/material.dart';
import 'package:dropill_project/features/medication/medication_controller.dart';
import 'package:dropill_project/locator.dart';
import 'package:intl/intl.dart'; // Adicione esta importação

class MedicationPageView extends StatefulWidget {
  const MedicationPageView({super.key});

  @override
  State<MedicationPageView> createState() => _MedicationPageViewState();
}

class _MedicationPageViewState extends State<MedicationPageView> {
  late MedicationController _medicationController;

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _medicationController = locator.get<MedicationController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalhes do Medicamento',
          style: AppTextStyles.mediumText20
              .copyWith(color: AppColors.standartBlue),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<void>(
        future: _medicationController.getMedication(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar medicação: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final state = _medicationController.state;

          if (state is getMedicationStateSuccess) {
            final medication =
                state.medication.isNotEmpty ? state.medication.first : null;

            if (medication == null) {
              return const Center(child: Text("Nenhuma medicação disponível"));
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Text(
                      medication.nome ?? 'Nome não disponível',
                      style: AppTextStyles.mediumText24.copyWith(
                        color: AppColors.standartBlue,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Tipo: ${medication.tipo ?? 'Não disponível'}',
                      style: AppTextStyles.mediumText18.copyWith(
                        color: AppColors.grey,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Dosagem: ${medication.quantidade.toString() ?? 'Não disponível'}',
                      style: AppTextStyles.mediumText18.copyWith(
                        color: AppColors.grey,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Descrição: ${medication.descricao ?? 'Não disponível'}',
                      style: AppTextStyles.mediumText18.copyWith(
                        color: AppColors.grey,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Data Atual: ${medication.dataAtual != null ? _dateFormat.format(DateTime.parse(medication.dataAtual!.toString())) : 'Não disponível'}',
                      style: AppTextStyles.mediumText18.copyWith(
                        color: AppColors.grey,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Data Final: ${medication.dataFinal != null ? _dateFormat.format(DateTime.parse(medication.dataFinal!.toString())) : 'Não disponível'}',
                      style: AppTextStyles.mediumText18.copyWith(
                        color: AppColors.grey,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Horários: ${medication.horario ?? 'Não disponível'}',
                      style: AppTextStyles.mediumText18.copyWith(
                        color: AppColors.grey,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () async {
                            try {
                              await _medicationController.deleteMedication();
                              Navigator.popAndPushNamed(
                                  context, NamedRoute.homeView);
                            } catch (e) {
                              print('Erro ao deletar medicação: $e');
                            }
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 32,
                          ),
                          tooltip: 'Deletar Medicamento',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else if (state is MedicationStateError) {
            return const Center(
              child: Text("Erro ao carregar medicação",
                  style: TextStyle(color: Colors.red)),
            );
          } else {
            return const Center(
              child: Text("Nenhuma medicação disponível",
                  style: TextStyle(color: Colors.grey)),
            );
          }
        },
      ),
    );
  }
}
