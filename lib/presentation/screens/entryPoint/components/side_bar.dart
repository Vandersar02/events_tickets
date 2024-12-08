import 'package:events_ticket/core/services/auth/user_services.dart';
import 'package:events_ticket/core/services/auth/users_manager.dart';
import 'package:events_ticket/data/models/event_model.dart';
import 'package:events_ticket/data/models/user_model.dart';
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
String? userUuid;

final List<String> sidebarMenus = [
  "Home",
  "Organizer",
  "Settings",
];

final List<String> sidebarMenus2 = [
  "Contact Us",
  "About Us",
];

late List<EventModel> organizerEvents = [];
UserModel? userInfo;

class _SideBarState extends State<SideBar> {
  String selectedSideMenu = sidebarMenus.first;

  // Map associant chaque menu à sa page de destination
  final Map<String, WidgetBuilder> _menuPages = {
    "Home": (context) => const EntryPoint(),
    "Organizer": (context) => EventManagementPage(
          events: organizerEvents,
        ),
    "Settings": (context) => const SettingsPage(),
    "Contact Us": (context) => const ContactUsPage(),
    "About Us": (context) => const AboutUsPage(),
  };

  Future<void> _navigateTo(String menu) async {
    final pageBuilder = _menuPages[menu];
    if (pageBuilder != null) {
      if (menu == "Organizer") {
        try {
          organizerEvents = await fetchOrganizerEvents(userUuid!);
          if (organizerEvents.isEmpty) {
            debugPrint("No events created yet by the user");
          }
        } catch (e) {
          debugPrint("Error fetching organizer events: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to fetch organizer events.")),
          );
          return;
        }
      }

      Navigator.of(context).push(
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
  void initState() {
    super.initState();
    fetchUserId().then((_) {
      if (userUuid != null) {
        fetchUser();
      } else {
        debugPrint("User ID is null in initState; skipping fetchUser.");
      }
    });
  }

  Future<void> fetchUserId() async {
    final fetchUserId = await SessionManager().getPreference("user_id");
    if (fetchUserId != null) {
      debugPrint("User UUID fetched: $fetchUserId");
    } else {
      debugPrint("User UUID is null; make sure it's saved after login.");
    }
    if (mounted) {
      setState(() {
        userUuid = fetchUserId;
      });
    }
  }

  Future<void> fetchUser() async {
    if (userUuid == null) {
      debugPrint("fetchUser skipped: userUuid is null.");
      return;
    }
    try {
      final fetchedUser = await UserServices().getUserData(userUuid!);
      if (mounted) {
        setState(() {
          userInfo = fetchedUser;
          debugPrint("User info loaded: ${userInfo!.name}");
        });
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
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
                user: userInfo,
                onTap: () {
                  if (userInfo != null) {
                    print("Email: ${userInfo!.email}");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(user: userInfo),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("User information is not available.")),
                    );
                  }
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
