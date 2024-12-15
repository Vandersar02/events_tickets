import 'package:events_ticket/core/services/auth/user_services.dart';
import 'package:events_ticket/core/services/auth/users_manager.dart';
import 'package:events_ticket/core/services/preferences/preferences_services.dart';
import 'package:events_ticket/data/models/preference_model.dart';
import 'package:flutter/material.dart';

class UserInformationScreen extends StatefulWidget {
  final String? userUuid;

  const UserInformationScreen({super.key, this.userUuid});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _birthDateController = TextEditingController();

  String? userUuid;
  bool isLoading = true;
  bool isSaving = false;

  String? fullName;
  DateTime? dateOfBirth;
  String? gender;
  String? phoneNumber;
  List<PreferencesModel> interests = [];
  List<PreferencesModel> availableInterests = [];

  @override
  void initState() {
    super.initState();
    userUuid = widget.userUuid;
    debugPrint("Received User UUID: $userUuid");
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    try {
      // Charger les préférences utilisateur
      availableInterests = await PreferencesServices().getAllPreferences();

      // Charger l'identifiant utilisateur
      // userUuid = await SessionManager().getPreference("user_id");
      if (userUuid == null) {
        debugPrint("Error: userUuid is null. Unable to proceed.");
        throw Exception("User ID is not available. Please log in again.");
      }
      debugPrint("User UUID fetched: $userUuid");

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      debugPrint("Error initializing user: $error");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error initializing user: $error"),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() {
        isLoading = false;
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
                              "${interest.icon ?? ''} ${interest.title ?? ''}"),
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
      if (userUuid == null) {
        debugPrint("Error: Cannot save data because userUuid is null.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User UUID is missing. Please log in again."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() => isSaving = true);
      try {
        await UserServices().updateUserField(userUuid!, 'name', fullName ?? '');
        await UserServices().updateUserField(userUuid!, 'gender', gender ?? '');
        await UserServices().updateUserField(
            userUuid!, 'date_of_birth', dateOfBirth?.toIso8601String() ?? '');
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
        Navigator.of(context).popAndPushNamed("/entryPoint");
      } catch (error) {
        debugPrint("Error saving user data: $error");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error saving data: $error"),
          backgroundColor: Colors.red,
        ));
      } finally {
        setState(() => isSaving = false);
      }
    }
  }
}
