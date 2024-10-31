class UserModel {
  final String id;
  final String name;
  final String email;
  final String profilePictureUrl;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      this.profilePictureUrl = ''});

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      id: documentId,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profilePictureUrl: data['profilePictureUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}
