class PreferencesModel {
  final String id;
  final String title;
  final String icon;

  PreferencesModel({required this.id, required this.title, required this.icon});

  // Factory to create a PreferencesModel from a Supabase response
  factory PreferencesModel.fromMap(Map<String, dynamic> data) {
    return PreferencesModel(
      id: data['id'],
      title: data['title'],
      icon: data['icon'],
    );
  }
}
