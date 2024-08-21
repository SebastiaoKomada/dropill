import 'package:dropill_project/common/constants/app_colors.dart';
import 'package:dropill_project/common/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class MonitoringPage extends StatelessWidget {
  const MonitoringPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Monitoring Page',
          style: AppTextStyles.mediumText20.copyWith(color: AppColors.standartBlue),
        ),
      ),
    );
  }
}
