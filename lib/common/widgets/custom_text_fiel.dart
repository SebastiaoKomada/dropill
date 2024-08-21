import 'package:dropill_project/common/constants/app_colors.dart';
import 'package:dropill_project/common/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final String? hintText;
  final String? labelText;
  final TextCapitalization? textCapitalization;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final bool? obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final String? helperText;
  final GestureTapCallback? onTap;
  final FocusNode? focusNode; // Adicionado
  final VoidCallback? onEditingComplete; // Adicionado

  const CustomTextFormField({
    super.key,
    this.padding,
    this.hintText,
    this.labelText,
    this.textCapitalization,
    this.controller,
    this.keyboardType,
    this.maxLength,
    this.textInputAction,
    this.suffixIcon,
    this.obscureText,
    this.inputFormatters,
    this.validator,
    this.helperText,
    this.onTap,
    this.focusNode, // Inicializado
    this.onEditingComplete, // Inicializado
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final defaultBorder = const OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.standartBlue));

  String? _helperText;

  @override
  void initState() {
    super.initState();
    _helperText = widget.helperText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: TextFormField(
        focusNode: widget.focusNode, // Usa o focusNode se fornecido
        onEditingComplete:
            widget.onEditingComplete, // Usa o onEditingComplete se fornecido
        onChanged: (value) {
          if (value.length == 1) {
            setState(() {
              _helperText = null;
            });
          } else if (value.isEmpty) {
            setState(() {
              _helperText = widget.helperText;
            });
          }
        },
        validator: widget.validator,
        inputFormatters: widget.inputFormatters,
        obscureText: widget.obscureText ?? false,
        textInputAction: widget.textInputAction,
        maxLength: widget.maxLength,
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.none,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          helperText: _helperText,
          helperMaxLines: 3,
          errorMaxLines: 3,
          suffixIcon: widget.suffixIcon,
          hintText: widget.hintText,
          labelText: widget.labelText?.toUpperCase(),
          labelStyle:
              AppTextStyles.mediumText18.copyWith(color: AppColors.grey),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          focusedBorder: defaultBorder,
          errorBorder: defaultBorder.copyWith(
              borderSide: const BorderSide(color: Colors.red)),
          focusedErrorBorder: defaultBorder.copyWith(
              borderSide: const BorderSide(color: Colors.red)),
          enabledBorder: defaultBorder,
          disabledBorder: defaultBorder,
        ),
        onTap: widget.onTap, // Usa o onTap, se fornecido
      ),
    );
  }
}
