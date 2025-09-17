class Uid123 {
  String? email;
  String? role;

  Uid123({this.email, this.role});

  Uid123 copyWith({String? email, String? role}) =>
      Uid123(email: email ?? this.email, role: role ?? this.role);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["email"] = email;
    map["role"] = role;
    return map;
  }

  Uid123.fromJson(dynamic json){
    email = json["email"];
    role = json["role"];
  }
}

class Uid456 {
  String? email;
  String? role;

  Uid456({this.email, this.role});

  Uid456 copyWith({String? email, String? role}) =>
      Uid456(email: email ?? this.email, role: role ?? this.role);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["email"] = email;
    map["role"] = role;
    return map;
  }

  Uid456.fromJson(dynamic json){
    email = json["email"];
    role = json["role"];
  }
}

class RoleModel {
  Uid123? uid123;
  Uid456? uid456;

  RoleModel({this.uid123, this.uid456});

  RoleModel copyWith({Uid123? uid123, Uid456? uid456}) =>
      RoleModel(uid123: uid123 ?? this.uid123, uid456: uid456 ?? this.uid456);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (uid123 != null) {
      map["uid123"] = uid123?.toJson();
    }
    if (uid456 != null) {
      map["uid456"] = uid456?.toJson();
    }
    return map;
  }

  RoleModel.fromJson(dynamic json){
    uid123 = json["uid123"] != null ? Uid123.fromJson(json["uid123"]) : null;
    uid456 = json["uid456"] != null ? Uid456.fromJson(json["uid456"]) : null;
  }
}