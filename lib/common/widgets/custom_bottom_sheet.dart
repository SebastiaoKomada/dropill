import 'package:dropill_project/common/constants/app_colors.dart';
import 'package:dropill_project/common/widgets/primary_button.dart';
import 'package:flutter/material.dart';

Future<void> customModalBottomSheet(BuildContext context, {required String content, required String buttonText}) {
  return showModalBottomSheet<void>(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(38.0),
        topRight: Radius.circular(38.0),
      ),
    ),
    context: context,
    builder: (BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(38.0),
            topRight: Radius.circular(38.0),
          ),
        ),
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(content),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: PrimaryButton(
                  text: buttonText,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
