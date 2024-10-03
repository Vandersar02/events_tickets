import 'package:events_ticket/presentation/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:events_ticket/data/models/events.dart';
import 'components/event_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenir la largeur de l'écran
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculer dynamiquement le nombre de colonnes en fonction de la largeur de l'écran
    int getCrossAxisCount() {
      if (screenWidth >= 1200) {
        return 4; // 4 colonnes pour les grands écrans
      } else if (screenWidth >= 1000) {
        return 3; // 3 colonnes pour les écrans moyens
      } else if (screenWidth >= 600) {
        return 2; // 2 colonnes pour les tablettes
      } else {
        return 1; // 1 colonne pour les petits écrans (téléphones)
      }
    }

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Events",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: events
                      .map(
                        (event) => Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: EventCard(
                            title: event.title,
                            date: event.date,
                            location: event.location,
                            imageUrl: event.imageUrl,
                            isFree: event.isFree,
                            attendeesCount: event.attendeesCount,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Recent Events",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  shrinkWrap: true, // Limite la hauteur du GridView
                  physics:
                      const NeverScrollableScrollPhysics(), // Désactive le scroll du GridView pour permettre au SingleChildScrollView de gérer le défilement
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: getCrossAxisCount(), // Colonnes dynamiques
                    crossAxisSpacing:
                        20.0, // Espacement horizontal entre les éléments
                    mainAxisSpacing:
                        20.0, // Espacement vertical entre les éléments
                    childAspectRatio:
                        2.0, // Ajuste le rapport d'aspect des cartes
                  ),
                  itemCount: popularEvents
                      .length, // Utiliser la liste d'événements récents ou populaires
                  itemBuilder: (context, index) {
                    final event = popularEvents[index];
                    return EventCard(
                      title: event.title,
                      date: event.date,
                      location: event.location,
                      imageUrl: event.imageUrl,
                      isFree: event.isFree,
                      attendeesCount: event.attendeesCount,
                    );
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
