import 'package:events_ticket/core/services/auth/preferences_services.dart';
import 'package:events_ticket/core/services/auth/user_services.dart';
import 'package:events_ticket/core/services/auth/users_manager.dart';
import 'package:flutter/material.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Todo: Get userId from SessionManager
  final userId = SessionManager().getPreference("user_id").toString();

  String? fullName;
  DateTime? birthDate;
  String? gender;
  String? language;
  String? phoneNumber;
  List<String> interests = [];

  final List<String> availableInterests = [
    'Art',
    'Music',
    'Sport',
    'Food',
    'Party',
    'Technology',
    'Books',
    'Photography'
  ];

  final Map<String, IconData> interestIcons = {
    'Art': Icons.palette,
    'Music': Icons.music_note,
    'Sport': Icons.sports_soccer,
    'Food': Icons.fastfood,
    'Party': Icons.people,
    'Technology': Icons.smartphone,
    'Books': Icons.menu_book,
    'Photography': Icons.camera_alt,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Personal Information")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nom complet
              TextFormField(
                decoration: const InputDecoration(labelText: 'Full name'),
                onChanged: (value) => fullName = value,
                validator: (value) =>
                    value!.isEmpty ? "Enter your full name" : null,
              ),

              // Date de naissance
              TextFormField(
                decoration: const InputDecoration(
                    labelText: ' Birth date (JJ/MM/AAAA)'),
                keyboardType: TextInputType.datetime,
                onChanged: (value) {
                  birthDate = DateTime.tryParse(value);
                },
              ),

              // Genre
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Gender'),
                items: ['Male', 'Female', 'Unspecified'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => gender = value,
              ),

              // Langue préférée
              DropdownButtonFormField<String>(
                decoration:
                    const InputDecoration(labelText: 'Preferred language'),
                items: ['Français', 'English', 'Espagnol'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => language = value,
              ),

              // Numéro de téléphone
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Phone number (for payments)'),
                keyboardType: TextInputType.phone,
                onChanged: (value) => phoneNumber = value,
                validator: (value) =>
                    value!.isEmpty ? "Enter your phone number" : null,
              ),

              const Divider(),

              // Intérêts et préférences événementielles
              const Text("Select your interests"),
              Wrap(
                spacing: 10,
                children: availableInterests.map((interest) {
                  return ChoiceChip(
                    label: Text(interest),
                    selected: interests.contains(interest),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          interests.add(interest);
                        } else {
                          interests.remove(interest);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const Divider(),

              const SizedBox(height: 20),

              // Bouton de soumission
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    print("Info saved for user $fullName ");
                    print(interests);

                    await UserServices()
                        .updateUserField(userId, 'name', fullName ?? '');

                    // Obtenez l'ID des préférences sélectionnées
                    final selectedPreferenceIds = interests.map((interest) {
                      return availableInterests.indexOf(interest).toString();
                    }).toList();

                    // Appel à la fonction de mise à jour des préférences
                    await PreferencesServices()
                        .updateUserPreferences(userId, selectedPreferenceIds);

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Preferences updated successfully!')),
                    );
                    // Save user data in SessionManager
                    SessionManager().savePreference(
                        "user", UserServices().getUserData(userId));
                    // Navigate to the entry point screen
                    Navigator.of(context).popAndPushNamed('/entryPoint');
                  }
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
