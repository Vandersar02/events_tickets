import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Champs pour stocker les informations de l'utilisateur
  String? fullName;
  DateTime? birthDate;
  String? gender;
  String? language;
  String? phoneNumber;
  List<String> interests = [];
  String? location;
  bool isWheelchairAccessible = false;
  bool isVegan = false;

  // Liste des catégories d'intérêt
  List<String> availableInterests = [
    "Art",
    "Music",
    "Sports",
    "Food",
    "Party",
    "Technology"
  ];

  // Méthode pour obtenir la localisation actuelle
  // Future<void> _getCurrentLocation() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);
  //     setState(() {
  //       location = "${position.latitude}, ${position.longitude}";
  //     });
  //   } catch (e) {
  //     print("Erreur lors de la récupération de la localisation: $e");
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // _getCurrentLocation();
  }

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

              // Localisation actuelle
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Text(location != null
                        ? "Location: $location"
                        : "Location not defined"),
                    IconButton(
                      icon: const Icon(Icons.location_on),
                      onPressed: () {},
                      // onPressed: _getCurrentLocation,
                    ),
                  ],
                ),
              ),

              Divider(),

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

              Divider(),

              // Accessibilité et exigences spéciales
              const Text("Accessibility and special requirements"),
              SwitchListTile(
                title: const Text("Access to wheelchair"),
                value: isWheelchairAccessible,
                onChanged: (value) {
                  setState(() {
                    isWheelchairAccessible = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text("Food preferences (vegetarian)"),
                value: isVegan,
                onChanged: (value) {
                  setState(() {
                    isVegan = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Bouton de soumission
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: ajouter la logique pour sauvegarder les informations utilisateur dans la base de données
                    print("Info saved");
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
