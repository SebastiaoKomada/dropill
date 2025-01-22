import 'dart:convert';

class ReturnMonitoring {
  final DateTime? dataHorario;
  final int? sintomasId;
  final int? perfilId;
  final String? symptomName; // Adicionado campo symptomName

  ReturnMonitoring({
    this.dataHorario,
    this.sintomasId,
    this.perfilId,
    this.symptomName, // Adicionado campo symptomName
  });

  ReturnMonitoring copyWith({
    DateTime? dataHorario,
    int? sintomasId,
    int? perfilId,
    String? symptomName, // Adicionado campo symptomName
  }) {
    return ReturnMonitoring(
      dataHorario: dataHorario ?? this.dataHorario,
      sintomasId: sintomasId ?? this.sintomasId,
      perfilId: perfilId ?? this.perfilId,
      symptomName: symptomName ?? this.symptomName, // Adicionado campo symptomName
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mon_dataHorario': dataHorario?.toIso8601String(),
      'mon_sintomasId': sintomasId,
      'mon_perfilId': perfilId,
      'symptom_name': symptomName, // Adicionado campo symptomName
    };
  }

  String toJson() => json.encode(toMap());

  factory ReturnMonitoring.fromMap(Map<String, dynamic> map) {
    return ReturnMonitoring(
      dataHorario: map['mon_dataHorario'] != null ? DateTime.parse(map['mon_dataHorario']) : null,
      sintomasId: map['mon_sintomasId'],
      perfilId: map['mon_perfilId'],
      symptomName: map['symptom_name'], // Adicionado campo symptomName
    );
  }

  factory ReturnMonitoring.fromJson(String source) {
    Map<String, dynamic> map = json.decode(source);
    return ReturnMonitoring.fromMap(map);
  }
}
