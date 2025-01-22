import 'package:dropill_project/common/constants/app_colors.dart';
import 'package:dropill_project/common/constants/app_text_styles.dart';
import 'package:dropill_project/common/constants/routes.dart';
import 'package:dropill_project/common/models/medication_model.dart';
import 'package:dropill_project/services/secure_storage.dart';
import 'package:flutter/material.dart';

class CustomMedicationList extends StatelessWidget {
  final List<MedicationModel> medications;
  final SecureStorage secureStorage;
  const CustomMedicationList(
      {super.key, required this.medications, required this.secureStorage});

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
              foregroundColor: AppColors.white,
              backgroundColor: AppColors.standartBlue, // Cor do texto do botão
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide.none,
              ),
            ),
            onPressed: () async {
              print('Medication clicked: ${medication.id}');
              await secureStorage.write(
                  key: "MEDICATION_ID", value: medication.id.toString());
              Navigator.pushNamed(context, NamedRoute.medicationView);
            },
            child: ListTile(
              textColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              title: Text(medication.nome ?? 'Nome desconhecido',
                style: AppTextStyles.mediumText14.copyWith(
                  color: AppColors.white,
                ),),
              subtitle:
                  Text(medication.descricao ?? 'Descrição não disponível',
                    style: AppTextStyles.mediumText14.copyWith(
                      color: AppColors.white,
                    ),),
              trailing: Text('Tipo: ${medication.tipo ?? 'Nenhum'}',
                style: AppTextStyles.mediumText14.copyWith(
                color: AppColors.white,
              ),),
              leading: Text('Dose: ${medication.quantidade ?? 0}',
                style: AppTextStyles.mediumText14.copyWith(
                  color: AppColors.white,
                ),),
            ),
          ),
        );
      },
    );
  }
}
