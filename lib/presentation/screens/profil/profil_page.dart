import 'dart:io';
import 'package:events_ticket/core/services/auth/user_services.dart';
import 'package:events_ticket/core/services/auth/users_manager.dart';
import 'package:events_ticket/core/services/preferences/preferences_services.dart';
import 'package:events_ticket/data/models/preference_model.dart';
import 'package:events_ticket/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.user});

  final UserModel? user;

  @override
  ProfilePageState createState() => ProfilePageState();
}

final userId = SessionManager().userId;

class ProfilePageState extends State<ProfilePage> {
  // Controllers pour les informations personnelles
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  String? selectedGender; // Dropdown pour le genre
  List<String> genders = ["Male", "Female", "Unspecified"];

  File? _selectedImage;

  List<PreferencesModel> preferences = [];
  List<String> selectedPreferenceIds = [];
  UserModel? userInfo;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> fetchData() async {
    final fetchedPreferences = await PreferencesServices().getAllPreferences();
    final fetchedUserPreferences =
        await PreferencesServices().getUserPreferences(userId);
    // final fetchedUser = await UserServices().getUserData(userId);

    // Set initial values
    setState(() {
      preferences = fetchedPreferences;
      selectedPreferenceIds = fetchedUserPreferences.map((p) => p.id).toList();
      userInfo = widget.user;

      nameController.text = userInfo!.name ?? "John Doe";
      emailController.text = userInfo!.email ?? "john.doe@example.com";
      phoneController.text = userInfo!.phoneNumber ?? "123456789";
      _dateOfBirthController.text =
          "${userInfo!.dateOfBirth!.year}-${userInfo!.dateOfBirth!.month.toString().padLeft(2, '0')}-${userInfo!.dateOfBirth!.day.toString().padLeft(2, '0')}";
      selectedGender = userInfo?.gender ?? "Unspecified";
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Profil
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: _selectedImage != null
                      ? CircleAvatar(
                          radius: 60,
                          backgroundImage: FileImage(_selectedImage!),
                        )
                      : CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade300,
                          child: const Icon(Icons.camera_alt, size: 40),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Personal Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),

              // Nom
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),

              // Email
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),

              // Téléphone
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 16),

              // Date de naissance
              TextField(
                controller: _dateOfBirthController,
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    _dateOfBirthController.text =
                        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Birth Date',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 16),

              // Genre
              DropdownButtonFormField<String>(
                value: selectedGender,
                decoration: const InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                items: genders
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
              ),
              const SizedBox(height: 32),

              // Section Préférences
              const Text(
                "Preferences",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: preferences.map((preference) {
                  final isActive =
                      selectedPreferenceIds.contains(preference.id);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isActive) {
                          selectedPreferenceIds.remove(preference.id);
                        } else {
                          selectedPreferenceIds.add(preference.id);
                        }
                      });
                    },
                    child: Chip(
                      label: Text(
                        "${preference.icon} ${preference.title}",
                        style: TextStyle(
                          color: isActive ? Colors.white : Colors.black,
                        ),
                      ),
                      backgroundColor:
                          isActive ? Colors.blue : Colors.grey.shade200,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              // Bouton de sauvegarde
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text("Save"),
                  onPressed: () async {
                    try {
                      // Update user data
                      await UserServices().updateUserData(userId, userInfo!);

                      // Sauvegarde des préférences
                      await PreferencesServices()
                          .updateUserPreferences(userId, selectedPreferenceIds);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Update successful'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error : $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
