class UserModel {
  String? email;
  String? firstName;
  String? lastName;
  String? uid;

  UserModel(
      { this.email, this.firstName, this.lastName, this.uid});

  UserModel copyWith(
      {String? createdAt, String? email, String? firstName, String? lastName, String? uid}) =>
      UserModel(
          email: email ?? this.email,
          firstName: firstName ?? this.firstName,
          lastName: lastName ?? this.lastName,
          uid: uid ?? this.uid);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["email"] = email;
    map["firstName"] = firstName;
    map["lastName"] = lastName;
    map["uid"] = uid;
    return map;
  }

  UserModel.fromJson(dynamic json){
    email = json["email"];
    firstName = json["firstName"];
    lastName = json["lastName"];
    uid = json["uid"];
  }

  @override
  String toString() {
    return 'UserModel{email: $email, firstName: $firstName, lastName: $lastName, uid: $uid}';
  }


}