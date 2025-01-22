import 'dart:convert';

class SymptomModel {
  final int sin_id;
  final String sin_nome;

  SymptomModel({
    required this.sin_id,
    required this.sin_nome,
  });

  factory SymptomModel.fromMap(Map<String, dynamic> map) {
    return SymptomModel(
      sin_id: map['sin_id'] ?? '',
      sin_nome: map['sin_nome'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sin_id': sin_id,
      'sin_nome': sin_nome,
    };
  }

  @override
  String toString() {
    return jsonEncode(toMap()); // Retornar os dados no formato JSON
  }
}
