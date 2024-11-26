class PreferencesModel {
  final String id;
  final String? title;
  final String? icon;

  PreferencesModel({required this.id, this.title, this.icon});

  // Factory to create a PreferencesModel from a Supabase response
  factory PreferencesModel.fromMap(Map<String, dynamic> data) {
    return PreferencesModel(
      id: data['id'],
      title: data['title'],
      icon: data['icon'],
    );
  }

  // Conversion du modèle PreferencesModel en JSON pour l'envoi vers la base de données
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
    };
  }
}
