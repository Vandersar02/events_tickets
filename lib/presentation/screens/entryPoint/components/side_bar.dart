import 'package:events_ticket/data/models/events.dart';
import 'package:events_ticket/presentation/screens/about/about_us.dart';
import 'package:events_ticket/presentation/screens/contact/contact_us.dart';
import 'package:events_ticket/presentation/screens/entryPoint/entry_point.dart';
import 'package:events_ticket/presentation/screens/events/event_management.dart';
import 'package:events_ticket/presentation/screens/profil/profil_page.dart';
import 'package:events_ticket/presentation/screens/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'info_card.dart';
import 'side_menu.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

final supabase = Supabase.instance.client;

class _SideBarState extends State<SideBar> {
  String selectedSideMenu = sidebarMenus.first;

  // Map associant chaque menu à sa page de destination
  final Map<String, WidgetBuilder> _menuPages = {
    "Home": (context) => const EntryPoint(),
    "Organizer": (context) => EventManagementPage(
          events: events,
        ),
    "Settings": (context) => const SettingsPage(),
    "Contact Us": (context) => const ContactUsPage(),
    "About Us": (context) => const AboutUsPage(),
  };

  void _navigateTo(String menu) {
    final pageBuilder = _menuPages[menu];
    if (pageBuilder != null) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              pageBuilder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.easeInOut;
            final tween = Tween(begin: 0.0, end: 1.0).chain(
              CurveTween(curve: curve),
            );
            final fadeAnimation = animation.drive(tween);

            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Détection du thème actuel
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? Colors.grey[900] : const Color(0xFF7553F6);

    return SafeArea(
      child: Container(
        width: 288,
        height: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
          ),
        ),
        child: DefaultTextStyle(
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoCard(
                name: supabase.auth.currentUser?.userMetadata!['name'] ??
                    "John Doe",
                bio: supabase.auth.currentUser?.userMetadata!['bio'] ??
                    "Simple User",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "Browse".toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: isDarkMode ? Colors.white70 : Colors.black54),
                ),
              ),
              // Navigation principale
              ...sidebarMenus.map((menu) => SideMenu(
                    title: menu,
                    isSelected: menu == selectedSideMenu,
                    onTap: () {
                      setState(() {
                        selectedSideMenu = menu;
                      });
                      _navigateTo(menu);
                    },
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 40, bottom: 16),
                child: Text(
                  "History".toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: isDarkMode ? Colors.white70 : Colors.black54),
                ),
              ),
              // Navigation historique
              ...sidebarMenus2.map((menu) => SideMenu(
                    title: menu,
                    isSelected: menu == selectedSideMenu,
                    onTap: () {
                      setState(() {
                        selectedSideMenu = menu;
                      });
                      _navigateTo(menu);
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

final List<String> sidebarMenus = [
  "Home",
  "Organizer",
  "Settings",
];

final List<String> sidebarMenus2 = [
  "Contact Us",
  "About Us",
];

final List<Event> events = [
  Event(
    date: DateTime.now().add(const Duration(days: 30)),
    title: "National Music Festival",
    location: "Delmas 105",
    imageUrl: "assets/images/event1.jpg",
    isFree: true,
    attendeesCount: 100,
    category: "Music",
    ticketsAvailable: 200,
    ticketsSold: 50,
    revenue: 0.0,
    description:
        "Venez profiter d'une journée remplie de musique et de culture.",
    reviews: [],
  ),
  Event(
    date: DateTime.now().add(const Duration(days: 30)),
    title: 'Exposition Art',
    location: "Delmas 105",
    imageUrl: "assets/images/event1.jpg",
    isFree: true,
    attendeesCount: 100,
    category: "Art",
    ticketsAvailable: 150,
    ticketsSold: 75,
    revenue: 0.0,
    description: "Une exposition d'art contemporain avec des artistes locaux.",
    reviews: [],
  ),
  Event(
    date: DateTime.now().add(const Duration(days: 30)),
    title: 'Marathon',
    location: "Delmas 105",
    imageUrl: "assets/images/event3.jpg",
    isFree: true,
    attendeesCount: 100,
    category: "Marathon",
    ticketsAvailable: 300,
    ticketsSold: 150,
    revenue: 0.0,
    description: "Participez à un marathon de 5 km dans les rues de Delmas.",
    reviews: [],
  ),
  Event(
    date: DateTime.now().subtract(const Duration(days: 30)),
    title: "Art Workshop",
    location: "Catalpa 8A, Delmas 75",
    imageUrl: "assets/images/event2.jpg",
    isFree: true,
    attendeesCount: 50,
    category: "Art",
    ticketsAvailable: 30,
    ticketsSold: 20,
    revenue: 0.0,
    description:
        "Atelier d'art pour tous les niveaux, apportez votre créativité.",
    reviews: [],
  ),
  Event(
    date: DateTime.now().subtract(const Duration(days: 30)),
    title: 'Conférence Tech',
    location: "Catalpa 8A, Delmas 75",
    imageUrl: "assets/images/event3.jpg",
    isFree: true,
    attendeesCount: 50,
    category: "Tech",
    ticketsAvailable: 100,
    ticketsSold: 60,
    revenue: 0.0,
    description:
        "Discutez des dernières tendances technologiques avec des experts.",
    reviews: [],
  ),
  Event(
    date: DateTime.now().add(const Duration(days: 60)),
    title: 'Festival de Danse',
    location: "Cx Des Bouquets",
    imageUrl: "assets/images/event2.jpg",
    isFree: false,
    attendeesCount: 200,
    category: "Dance",
    ticketsAvailable: 500,
    ticketsSold: 250,
    revenue: 1250.0,
    description: "Une journée de danse avec des performances et des ateliers.",
    reviews: [],
  ),
  Event(
    date: DateTime.now().add(const Duration(days: 90)),
    title: 'Cinéma en Plein Air',
    location: "Parc de Martissant",
    imageUrl: "assets/images/event1.jpg",
    isFree: true,
    attendeesCount: 150,
    category: "Cinema",
    ticketsAvailable: 200,
    ticketsSold: 100,
    revenue: 0.0,
    description: "Venez profiter d'un film sous les étoiles.",
    reviews: [],
  ),
  Event(
    date: DateTime.now().add(const Duration(days: 45)),
    title: 'Salon de la Technologie',
    location: "Port-au-Prince",
    imageUrl: "assets/images/event3.jpg",
    isFree: false,
    attendeesCount: 300,
    category: "Tech",
    ticketsAvailable: 400,
    ticketsSold: 150,
    revenue: 750.0,
    description: "Explorez les innovations technologiques et les startups.",
    reviews: [],
  ),
  Event(
    date: DateTime.now().add(const Duration(days: 15)),
    title: 'Festival de Gastronomie',
    location: "Place de la République",
    imageUrl: "assets/images/event2.jpg",
    isFree: true,
    attendeesCount: 250,
    category: "Food",
    ticketsAvailable: 300,
    ticketsSold: 180,
    revenue: 0.0,
    description: "Dégustez des plats délicieux de chefs locaux.",
    reviews: [],
  ),
];
