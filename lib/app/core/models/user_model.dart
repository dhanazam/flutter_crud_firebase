class UserModel {
  String? uid;
  bool? isVerified;
  final String? email;
  String? password;
  final String? displayName;
  final int? age;

  UserModel({
    this.uid,
    this.isVerified,
    this.email,
    this.password,
    this.displayName,
    this.age,
  });

  UserModel copyWith({
    String? uid,
    bool? isVerified,
    String? email,
    String? password,
    String? displayName,
    int? age,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      isVerified: isVerified ?? this.isVerified,
      email: email ?? this.email,
      password: password ?? this.password,
      displayName: displayName ?? this.displayName,
      age: age ?? this.age,
    );
  }
}
