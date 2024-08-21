import 'dart:ui';

class AppColors {
  AppColors._();

  static const Color darkBlue = Color(0xf0003c5f);
  static const Color standartBlue = Color(0xEC01588A);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xF0000000);
  static const Color grey = Color(0xFF666666);
  static const Color darkGrey = Color(0xFF444444);

  static const Color primaryBorderColor = Color(0xFF01588A); // Cor da borda para o botão secundário
  static const Color disabledBorderColor = Color(0xFFB5B5B5); // Cor da borda quando desativado
  static const Color transparent = Color(0x00000000); // Cor transparente para o fundo
  static const Color disabledBackgroundColor = Color(0xFFF0F0F0); // Cor de fundo quando desativado
  static const Color primaryTextColor = Color(0xFF01588A); // Cor do texto para o botão secundário
  static const Color disabledTextColor = Color(0xFFB5B5B5); // Cor do texto quando desativado

  static const List<Color> blueGradient = [
    Color(0xf0003c5f),
    Color(0xEC01588A),
  ];
  static const List<Color> greyGradient = [
    Color(0xFFB5B5B5),
    Color(0xFF7F7F7F),
  ];
}
