import 'package:flutter/material.dart';

// Création d'une barre d'applications personnalisée en utilisant un widget stateless
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  // Définition de la hauteur préférée de l'AppBar
  @override
  Size get preferredSize => const Size.fromHeight(130);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Style et décoration de l'AppBar
      decoration: const BoxDecoration(
        color: Color(0xFF7553F6), // Couleur de fond bleue
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.0), // Arrondi en bas à gauche
          bottomRight: Radius.circular(30.0), // Arrondi en bas à droite
        ),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 10), // Espacement interne
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
          children: [
            // Section supérieure avec la localisation et l'icône de notifications
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Alignement à droite
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Current Location',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Catalpa 8A, Delmas 75', // Exemple d'adresse
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Gérer l'action du clic sur la flèche (filtrer ou modifier la localisation)
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 25),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.notifications_outlined,
                        color: Colors.white),
                    onPressed: () {
                      // Gérer l'action des notifications
                    },
                  ),
                )
              ],
            ),

            const Spacer(), // Espacement avant la barre de recherche

            // Barre de recherche
            Row(
              children: [
                Expanded(
                  child: Container(
                    // Style de la barre de recherche
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.white70),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 25),
                Container(
                  // Conteneur pour l'icône de filtre
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_alt_outlined,
                        color: Colors.white),
                    onPressed: () {
                      // Gérer l'action du filtre
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
