  import 'dart:convert';

  class ProfileModel {
    final int? id;
    final String? name;
    final int? usuId;
    final String? foto;

    ProfileModel({
      this.id,
      required this.name,
      this.usuId,
      this.foto,
    });

    ProfileModel copyWith({
      int? id,
      String? name,
      int? usuId,
      String? foto,
    }) {
      return ProfileModel(
        id: id ?? this.id,
        name: name ?? this.name,
        usuId: usuId ?? this.usuId,
        foto: foto ?? this.foto,
      );
    }

    Map<String, dynamic> toMap() {
      return {
        'id': id,
        'name': name,
        'usuId': usuId,
        'foto': foto,
      };
    }

    String toJson() => json.encode(toMap());

    factory ProfileModel.fromMap(Map<String, dynamic> map) {
      return ProfileModel(
        id: map['id'],
        name: map['name'],
        usuId: map['usuId'],
        foto: map['foto'],
      );
    }

    factory ProfileModel.fromJson(String source) {
      Map<String, dynamic> map = json.decode(source);
      return ProfileModel.fromMap(map);
    }
  }
