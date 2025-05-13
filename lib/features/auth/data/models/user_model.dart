import 'package:secvault/features/auth/domain/entities/user.dart';

class UserModel extends User {
  late final String uid;
  String? email;
  String? name;

  UserModel({required this.email, required this.name, required this.uid})
      : super(
          email: email,
          name: name,
          uid: uid,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        email: json['email'],
        name: json['name'],
        uid: json['uid'],
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'name': name,
      };
}
