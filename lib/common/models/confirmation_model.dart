import 'dart:convert';

class ConfirmationModel {
  final int? conId;

  ConfirmationModel({
    this.conId,
  });

  ConfirmationModel copyWith({
    int? conId,
  }) {
    return ConfirmationModel(
      conId: conId ?? this.conId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'con_id': conId,
    };
  }

  factory ConfirmationModel.fromMap(Map<String, dynamic> map) {
    return ConfirmationModel(
      conId: map['con_id'] as int?,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfirmationModel.fromJson(String source) =>
      ConfirmationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
