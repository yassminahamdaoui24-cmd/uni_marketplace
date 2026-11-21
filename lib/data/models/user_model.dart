class UserModel {
  final String uid;
  final String nomComplet;
  final String email;
  final String filiere;
  final String telephone;

  UserModel({
    required this.uid,
    required this.nomComplet,
    required this.email,
    required this.filiere,
    required this.telephone,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nomComplet': nomComplet,
      'email': email,
      'filiere': filiere,
      'telephone': telephone,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      nomComplet: map['nomComplet'] ?? '',
      email: map['email'] ?? '',
      filiere: map['filiere'] ?? '',
      telephone: map['telephone'] ?? '',
    );
  }
}
