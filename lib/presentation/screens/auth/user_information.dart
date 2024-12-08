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

  String? userUuid;
  bool isLoading =
      true; // Par défaut, l'écran affiche un indicateur de chargement
  bool isSaving = false; // Indicateur pour le bouton de sauvegarde

  String? fullName;
  DateTime? dateOfBirth;
  String? gender;
  String? language;
  String? phoneNumber;
  List<PreferencesModel> interests = [];
  List<PreferencesModel> availableInterests = [];

  @override
  void initState() {
    super.initState();
    _fetchUserId();
    _initialize();
  }

  /// Initialisation des données utilisateur et préférences
  Future<void> _initialize() async {
    try {
      // Charger les préférences
      availableInterests = await PreferencesServices().getAllPreferences();

      setState(() {
        isLoading = false; // Le chargement est terminé
      });
    } catch (error) {
      debugPrint("Error during initialization: $error");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchUserId() async {
    final fetchUserId = await SessionManager().getPreference("user_id");

    if (mounted) {
      setState(() {
        userUuid = fetchUserId.toString();
        if (userUuid != null) {
          print("User UUID fetched: $userUuid");
        } else {
          print("User UUID is null");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Personal Information")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTextField(
                      label: "Full name",
                      onChanged: (value) => fullName = value,
                      validator: (value) =>
                          value!.isEmpty ? "Enter your full name" : null,
                    ),
                    const SizedBox(height: 16),
                    _buildDateField(),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      label: "Gender",
                      value: gender,
                      items: ['Male', 'Female', 'Unspecified'],
                      onChanged: (value) => gender = value,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: "Phone number (for payments)",
                      keyboardType: TextInputType.phone,
                      onChanged: (value) => phoneNumber = value,
                      validator: (value) =>
                          value!.isEmpty ? "Enter your phone number" : null,
                    ),
                    const SizedBox(height: 20),
                    const Text("Select your interests"),
                    Wrap(
                      spacing: 10,
                      children: availableInterests.map((interest) {
                        return ChoiceChip(
                          label: Text(
                              "${interest.icon ?? 'icon'} ${interest.title ?? 'text'}"),
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
                    ElevatedButton(
                      onPressed: isSaving ? null : _saveUserData,
                      child: isSaving
                          ? const CircularProgressIndicator()
                          : const Text("Save"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required String label,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _birthDateController,
      readOnly: true,
      decoration: const InputDecoration(labelText: 'Birth Date'),
      validator: (value) => value!.isEmpty ? "Enter your birth date" : null,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          setState(() {
            print(pickedDate);
            dateOfBirth = pickedDate;
            _birthDateController.text =
                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
          });
        }
      },
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      value: value,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Future<void> _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isSaving = true);
      try {
        print(dateOfBirth!.toIso8601String());
        await UserServices().updateUserField(userUuid!, 'name', fullName ?? '');
        await UserServices().updateUserField(userUuid!, 'gender', gender ?? '');
        await UserServices().updateUserField(
            userUuid!, 'date_of_birth', dateOfBirth!.toIso8601String());
        await UserServices()
            .updateUserField(userUuid!, 'phone_number', phoneNumber ?? '');

        final selectedPreferenceIds = interests.map((i) => i.id).toList();
        await PreferencesServices()
            .updateUserPreferences(userUuid!, selectedPreferenceIds);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Preferences updated successfully!"),
          backgroundColor: Colors.green,
        ));
        await SessionManager().savePreference("isInfoUpdated", true);
        print("Passed through the if statement ");
        Navigator.of(context).popAndPushNamed("/entryPoint");
      } catch (error) {
        debugPrint("Error saving user data: $error");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error saving data."),
          backgroundColor: Colors.red,
        ));
      } finally {
        setState(() => isSaving = false);
      }
    }
  }
}
