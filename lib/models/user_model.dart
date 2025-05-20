class UserModel {
  String? id;
  String email;
  String fullName;
  String? dateOfBirth;
  String? phoneNumber;
  String? avatarUrl;

  UserModel({
    this.id,
    required this.email,
    required this.fullName,
    this.dateOfBirth,
    this.phoneNumber,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      email: json['email'],
      fullName: json['fullName'],
      dateOfBirth: json['dateOfBirth'],
      phoneNumber: json['phoneNumber'],
      avatarUrl: json['avatarUrl'],
    );
  }
}
