import 'package:dropill_project/common/constants/app_colors.dart';
import 'package:dropill_project/common/constants/app_text_styles.dart';
import 'package:dropill_project/common/models/return_monitoring_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Adicione esta importação para formatação de data

class CustomMonitoringList extends StatelessWidget {
  final List<ReturnMonitoring> monitoring;

  const CustomMonitoringList({super.key, required this.monitoring});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: monitoring.length,
      itemBuilder: (context, index) {
        final monitoringItem = monitoring[index];

        // Formate o DateTime para uma string
        final horario = monitoringItem.dataHorario != null
            ? DateFormat('dd/MM/yyyy HH:mm').format(monitoringItem.dataHorario!)
            : 'Horário desconhecido';

        // Pegue o nome do sintoma
        final nomeSintoma = monitoringItem.symptomName ?? 'Sintoma desconhecido';

        return Card(
          color: AppColors.standartBlue,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            title: Text(
              horario,
              style: AppTextStyles.mediumText14.copyWith(
                color: AppColors.white,
              ),
            ),
            subtitle: Text(
              nomeSintoma,
              style: AppTextStyles.mediumText14.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
        );
      },    );
  }
}
