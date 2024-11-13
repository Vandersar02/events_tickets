import 'package:events_ticket/presentation/screens/chats/chat_screen.dart';
import 'package:events_ticket/presentation/screens/entryPoint/components/side_bar.dart';
import 'package:events_ticket/presentation/screens/home/home_screen.dart';
import 'package:events_ticket/presentation/screens/qr_code/qr_scanner_screen.dart';
// import 'package:events_ticket/presentation/screens/social/another_screen.dart';
import 'package:events_ticket/presentation/screens/social/social_screen.dart';
import 'package:events_ticket/presentation/screens/tickets/tickets_page.dart';
import 'package:flutter/material.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint>
    with SingleTickerProviderStateMixin {
  bool isSideBarOpen = false;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SocialScreen(),
    const TicketsPage(),
    const ChatsScreen(),
    const QRScannerScreen(),
  ];

  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        setState(() {});
      });

    // Animation de la mise à l'échelle
    scalAnimation = Tween<double>(begin: 1, end: 0.85).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    // Animation de rotation en perspective
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleSideBar() {
    setState(() {
      isSideBarOpen = !isSideBarOpen;
      if (isSideBarOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Sidebar
          Positioned(
            left: isSideBarOpen ? 0 : -250, // Barre latérale coulissante
            top: 0,
            bottom: 0,
            width: 250,
            child: const SideBar(),
          ),

          // Main Content avec rotation et mise à l'échelle
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(0.1 * animation.value) // Rotation légère
              ..translate(
                  animation.value * 250), // Translation de 250px vers la droite
            child: Transform.scale(
              scale: scalAnimation.value,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(isSideBarOpen ? 24 : 0),
                child: _pages[_selectedIndex],
              ),
            ),
          ),

          // Menu Bouton pour ouvrir/fermer la Sidebar
          Positioned(
            left: isSideBarOpen ? 200 : 16, // Position dynamique selon état
            top: 35,
            child: IconButton(
              icon: Icon(
                isSideBarOpen ? Icons.close : Icons.menu,
                size: 28,
                color: Colors.white,
              ),
              onPressed: toggleSideBar,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor:
            const Color(0xFF7553F6), // Couleur de l'icône sélectionnée
        unselectedItemColor:
            Colors.grey, // Couleur des icônes non sélectionnées
        showSelectedLabels:
            true, // Affiche les labels pour les items sélectionnés
        showUnselectedLabels:
            true, // Affiche les labels pour les items non sélectionnés
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Social',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: 'Tickets',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.chat),
          //   label: 'Chats',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.portrait),
          //   label: 'Scanner',
          // ),
        ],
      ),
    );
  }
}
