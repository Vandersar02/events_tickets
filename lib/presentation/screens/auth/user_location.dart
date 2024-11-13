// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

// class UserLocationScreen extends StatefulWidget {
//   @override
//   _UserLocationScreenState createState() => _UserLocationScreenState();
// }

// class _UserLocationScreenState extends State<UserLocationScreen> {
//   String? _locationName;

//   // Méthode pour obtenir la position actuelle et faire le géocodage inverse
//   Future<void> _getCurrentLocation() async {
//     try {
//       // Obtenir la position actuelle
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);

//       // Utiliser geocoding pour convertir les coordonnées en une adresse
//       List<Placemark> placemarks =
//           await placemarkFromCoordinates(position.latitude, position.longitude);

//       if (placemarks.isNotEmpty) {
//         // Utiliser les informations du premier résultat de géocodage inverse
//         Placemark place = placemarks.first;
//         setState(() {
//           _locationName = "${place.locality}, ${place.country}";
//         });
//       }
//     } catch (e) {
//       print("Erreur lors de la récupération de la localisation : $e");
//       setState(() {
//         _locationName = "Localisation inconnue";
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation(); // Appeler la fonction pour obtenir la localisation
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Localisation de l'utilisateur")),
//       body: Center(
//         child: Text(
//           _locationName ?? "Chargement de la localisation...",
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//     );
//   }
// }
