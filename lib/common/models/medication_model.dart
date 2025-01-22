import 'dart:convert';

class MedicationModel {
  final int? id;
  final String? nome;
  final String? descricao;
  final String? tipo;
  final int? quantidade;
  final DateTime? dataAtual;
  final DateTime? dataFinal;
  final int? perId;
  final bool? estado;
  final List<String>? horario;

  MedicationModel({
    this.id,
    this.nome,
    this.descricao,
    this.tipo,
    this.quantidade,
    this.dataAtual,
    this.dataFinal,
    this.perId,
    this.estado,
    this.horario,
  });

  MedicationModel copyWith({
    int? id,
    String? nome,
    String? descricao,
    String? tipo,
    int? quantidade,
    DateTime? dataAtual,
    DateTime? dataFinal,
    int? perId,
    bool? estado,
    List<String>? horario,
  }) {
    return MedicationModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      tipo: tipo ?? this.tipo,
      quantidade: quantidade ?? this.quantidade,
      dataAtual: dataAtual ?? this.dataAtual,
      dataFinal: dataFinal ?? this.dataFinal,
      perId: perId ?? this.perId,
      estado: estado ?? this.estado,
      horario: horario ?? this.horario,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'med_id': id,
      'med_nome': nome,
      'med_descricao': descricao,
      'med_tipo': tipo,
      'med_quantidade': quantidade,
      'med_dataInicio': dataAtual?.toIso8601String(),
      'med_dataFinal': dataFinal?.toIso8601String(),
      'med_perId': perId,
      'med_estado': estado,
      'hor_horario': horario,
    };
  }

  factory MedicationModel.fromMap(Map<String, dynamic> map) {
    return MedicationModel(
      id: map['med_id'] as int?,
      nome: map['med_nome'] as String?,
      descricao: map['med_descricao'] as String?,
      tipo: map['med_tipo'] as String?,
      quantidade: map['med_quantidade'] as int?,
      dataAtual: map['med_dataInicio'] != null
          ? DateTime.parse(map['med_dataInicio'] as String)
          : null,
      dataFinal: map['med_dataFinal'] != null
          ? DateTime.parse(map['med_dataFinal'] as String)
          : null,
      perId: map['med_perId'] as int?,
      estado: map['med_estado'] as bool?,
      horario: map['hor_horario'] != null
          ? List<String>.from(map['hor_horario'])
          : null, // Convertendo a lista de horários
    );
  }

  String toJson() => json.encode(toMap());

  factory MedicationModel.fromJson(String source) =>
      MedicationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
