import 'package:flutter/material.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  String eventName = '';
  String eventLocation = '';
  int ticketsAvailable = 0;
  DateTime eventDate = DateTime.now();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Enregistrer les informations de l'événement dans la base de données.
      // Vous pouvez intégrer une API ou une base de données pour gérer ces informations.

      // Exemple de console print pour tester :
      print("Nom de l'événement: $eventName");
      print("Lieu de l'événement: $eventLocation");
      print("Nombre de tickets disponibles: $ticketsAvailable");
      print("Date de l'événement: $eventDate");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un événement"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration:
                    const InputDecoration(labelText: "Nom de l'événement"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un nom d'événement.";
                  }
                  return null;
                },
                onSaved: (value) {
                  eventName = value!;
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: "Lieu de l'événement"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un lieu.";
                  }
                  return null;
                },
                onSaved: (value) {
                  eventLocation = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: "Nombre de tickets disponibles"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return "Veuillez entrer un nombre valide.";
                  }
                  return null;
                },
                onSaved: (value) {
                  ticketsAvailable = int.parse(value!);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text("Enregistrer l'événement"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
