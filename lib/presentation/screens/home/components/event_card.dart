import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatefulWidget {
  const EventCard({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.imageUrl,
    this.isFree = false,
    this.attendeesCount = 0,
  });

  final String title, location, imageUrl;
  final DateTime date;
  final bool isFree;
  final int attendeesCount;

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  String? imageUrl; // URL de l'image téléchargée depuis Firebase Storage
  bool _imageError =
      false; // Variable pour traquer les erreurs de téléchargement

  @override
  void initState() {
    super.initState();
    _loadImageFromFirebase();
  }

  // Fonction pour obtenir l'URL de l'image depuis Firebase Storage
  Future<void> _loadImageFromFirebase() async {
    try {
      // Obtenir l'URL de téléchargement à partir du chemin de l'image
      final storageRef = FirebaseStorage.instance.ref(widget.imageUrl);
      String url = await storageRef.getDownloadURL();
      setState(() {
        imageUrl = url;
        _imageError = false; // Pas d'erreur, on peut utiliser l'URL
      });
    } catch (e) {
      // En cas d'erreur, on affiche l'image par défaut
      setState(() {
        _imageError = true; // Il y a eu une erreur, afficher l'image par défaut
      });
      print('Erreur de chargement de l\'image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dayFormatted = DateFormat('d').format(widget.date);
    final monthFormatted =
        DateFormat('MMMM').format(widget.date).substring(0, 3).toUpperCase();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Date Box
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      dayFormatted,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      monthFormatted,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_border, color: Colors.grey),
                onPressed: () {
                  // Gérer l'action du bouton de favoris
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Image de l'événement chargée depuis Firebase Storage
          Row(
            children: [
              imageUrl != null && !_imageError
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 120,
                          minWidth: double.infinity,
                        ),
                        child: Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 120,
                          minWidth: double.infinity,
                        ),
                        child: Image.asset(
                          'assets/images/error_image.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              const SizedBox(width: 12),
              // Bouton pour télécharger l'image depuis Firebase Storage
              // InkWell(
              //   onTap: () {
              //     // Gérer l'action du bouton de téléchargement
              //   },
              //   child: const Icon(Icons.download, color: Colors.grey),
              // ),
            ],
          ),

          // imageUrl != null && !_imageError
          //     ? ClipRRect(
          //         borderRadius: BorderRadius.circular(16),
          //         child: ConstrainedBox(
          //           constraints: const BoxConstraints(
          //             maxHeight: 120,
          //             minWidth: double.infinity,
          //           ),
          //           child: Image.network(
          //             imageUrl!,
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //       )
          //     : ClipRRect(
          //         borderRadius: BorderRadius.circular(16),
          //         child: ConstrainedBox(
          //           constraints: const BoxConstraints(
          //             maxHeight: 120,
          //             minWidth: double.infinity,
          //           ),
          //           child: Image.asset(
          //             'assets/images/error_image.jpg',
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //       ),

          const SizedBox(height: 12),

          // Titre de l'événement
          Text(
            widget.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),

          // Avatars des participants et nombre de participants
          Row(
            children: [
              Stack(
                children: [
                  for (var i = 0; i < 3; i++)
                    Positioned(
                      left: i * 20,
                      child: CircleAvatar(
                        radius: 26,
                        backgroundImage:
                            AssetImage('assets/images/avatar_$i.png'),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 60),
              Text(
                '+${widget.attendeesCount} Going',
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Emplacement
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.grey, size: 16),
              const SizedBox(width: 4),
              Text(
                widget.location,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
