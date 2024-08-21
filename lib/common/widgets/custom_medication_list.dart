import 'package:dropill_project/common/constants/app_colors.dart';
import 'package:dropill_project/common/models/medication_model.dart';
import 'package:flutter/material.dart';

class CustomMedicationList extends StatelessWidget {
  final List<MedicationModel> medications;

  const CustomMedicationList({super.key, required this.medications});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: medications.length,
      itemBuilder: (context, index) {
        final medication = medications[index];
        return Card(
          color: AppColors.standartBlue,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.white, backgroundColor: AppColors.standartBlue, // Cor do texto do botão
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide.none,
              ),
            ),
            onPressed: () {
              print('Medication clicked: ${medication.nome}');
            },
            child: ListTile(
              textColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              title: Text(medication.nome ?? 'Nome desconhecido'),
              subtitle: Text(medication.descricao ?? 'Descrição não disponível'),
              trailing: Text('Tipo: ${medication.tipo ?? 'Nenhum'}'),
              leading: Text('Qtd: ${medication.quantidade ?? 0}'),
            ),
          ),
        );
      },
    );
  }
}
