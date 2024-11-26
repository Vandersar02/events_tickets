class UserModel {
  final String userId;
  final String? name;
  final String? email;
  final String profilePictureUrl;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? phoneNumber;
  final DateTime? lastActive;
  final DateTime createdAt;

  UserModel({
    required this.userId,
    this.name,
    this.email,
    this.profilePictureUrl = '',
    this.dateOfBirth,
    this.gender,
    this.phoneNumber,
    this.lastActive,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Conversion de JSON en objet UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profilePictureUrl: json['profile_picture_url'] as String? ?? '',
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      gender: json['gender'] as String?,
      phoneNumber: json['phone_number'] as String?,
      lastActive: json['last_active'] != null
          ? DateTime.parse(json['last_active'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Conversion de l'objet User en JSON pour la base de données
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'profile_picture_url': profilePictureUrl,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'phone_number': phoneNumber,
      'last_active': lastActive?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
