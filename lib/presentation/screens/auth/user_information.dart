import 'package:events_ticket/core/services/auth/user_services.dart';
import 'package:events_ticket/core/services/auth/users_manager.dart';
import 'package:events_ticket/core/services/preferences/preferences_services.dart';
import 'package:events_ticket/data/models/preference_model.dart';
import 'package:flutter/material.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _birthDateController = TextEditingController();

  final String userId = SessionManager().getPreference("user_id").toString();

  Future<List<PreferencesModel>> preferencesResponse() async =>
      await PreferencesServices().getUserPreferences(userId);

  bool isLoading = false;

  String? fullName;
  DateTime? dateOfBirth;
  String? gender;
  String? language;
  String? phoneNumber;
  List<PreferencesModel> interests = [];

  List<PreferencesModel> availableInterests = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() {
    availableInterests = (preferencesResponse() as List<dynamic>)
        .map((data) => PreferencesModel.fromMap(data))
        .toList();
    // availableInterests = [
    //   PreferencesModel(id: "", title: "Art"),
    //   PreferencesModel(id: "", title: "Music"),
    //   PreferencesModel(id: "", title: "Sports"),
    //   PreferencesModel(id: "", title: "Party"),
    //   PreferencesModel(id: "", title: "Movies"),
    // ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Information"),
      ),
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
                controller: _birthDateController,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Birth Date'),
                validator: (value) =>
                    value!.isEmpty ? "Enter your birth date" : null,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      dateOfBirth = pickedDate;
                      // Mettre à jour le texte du contrôleur
                      _birthDateController.text =
                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    });
                  }
                },
              ),

              // Genre
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Gender'),
                validator: (value) =>
                    value == null ? 'Please select a gender' : null,
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

              const SizedBox(height: 20),

              // Intérêts et préférences événementielles
              const Text("Select your interests"),
              Wrap(
                spacing: 10,
                children: availableInterests.map((interest) {
                  return ChoiceChip(
                    label: Text(
                        "${interest.icon.toString()} ${interest.title.toString()}"),
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
                    setState(() => isLoading = true);

                    print("UserId: $userId");
                    print("Info saved for user $fullName ");
                    print(interests);

                    await UserServices()
                        .updateUserField(userId, 'name', fullName ?? '');
                    await UserServices()
                        .updateUserField(userId, 'gender', gender ?? '');
                    await UserServices().updateUserField(
                        userId, 'date_of_birth', dateOfBirth ?? '');
                    await UserServices()
                        .updateUserField(userId, 'language', language ?? '');
                    await UserServices().updateUserField(
                        userId, 'phone_number', phoneNumber ?? '');

                    // Obtenez l'ID des préférences sélectionnées
                    final selectedPreferenceIds =
                        interests.map((interest) => interest.id).toList();

                    // Appel à la fonction de mise à jour des préférences
                    await PreferencesServices()
                        .updateUserPreferences(userId, selectedPreferenceIds);

                    if (mounted) {
                      setState(() => isLoading = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Preferences updated successfully!')),
                      );
                      // Save user data in SessionManager
                      SessionManager().savePreference("user_id", userId);
                      // Navigate to the entry point screen
                      Navigator.of(context).popAndPushNamed('/entryPoint');
                    }
                  }
                },
                child: isLoading ? const Text("Saving...") : const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
