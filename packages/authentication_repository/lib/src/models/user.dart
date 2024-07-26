import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? uid;
  bool? isVerified;
  final String? email;
  String? password;
  final String? displayName;
  final int? age;

  User({
    this.uid,
    this.isVerified,
    this.email,
    this.password,
    this.displayName,
    this.age,
  });

  User copyWith({
    String? uid,
    bool? isVerified,
    String? email,
    String? password,
    String? displayName,
    int? age,
  }) {
    return User(
      uid: uid ?? this.uid,
      isVerified: isVerified ?? this.isVerified,
      email: email ?? this.email,
      password: password ?? this.password,
      displayName: displayName ?? this.displayName,
      age: age ?? this.age,
    );
  }
  
  @override
  List<Object?> get props => [uid, isVerified, email, password, displayName, age];
}