import 'package:events_ticket/data/models/preference_model.dart';
import 'package:events_ticket/presentation/screens/home/components/events_details_page.dart';
import 'package:events_ticket/presentation/screens/seeAll/see_all_event_page.dart';
import 'package:flutter/material.dart';
import 'package:events_ticket/data/models/event_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'components/event_card.dart';
import 'package:events_ticket/presentation/widgets/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;

  late List<EventModel> newestEvents = [];
  late List<EventModel> recommendedEvents = [];
  late List<EventModel> freeEvents = [];
  List<EventModel> upcomingEvents = [];

  List<PreferencesModel> userPreferences = [];

  bool isLoading = false;
  var selectedCategory = "All";

  void filterEventsByCategory(String selectedCategory) {
    setState(() {
      if (selectedCategory == "All") {
        recommendedEvents = events; // Afficher tous les événements
      } else {
        recommendedEvents = events.where((event) {
          // TODO: we' ll have to give th true eventype
          return event.eventType == selectedCategory;
        }).toList();
      }
    });
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // recommendedEvents = await fetchRecommendedEvents();
      // freeEvents = await fetchFreeEvents();
      // newestEvents = await fetchNewestEvents();
      // userPreferences = await preferencesResponse();

      recommendedEvents = freeEvents = newestEvents = events;
      userPreferences =
          events.map((event) => event.eventType) as List<PreferencesModel>;
    } catch (error) {
      debugPrint("Erreur lors de la récupération des données : $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // TODO: Add Featured Section
              if (newestEvents.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Featured',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          children: [
                            Image.asset(
                              newestEvents[2].coverImg.toString(),
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: 15,
                              left: 15,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventDetailsPage(
                                        // TODO: will be replaced with the actual event
                                        event: newestEvents[2],
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text('Book Now'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),

              // Trending Section with Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recommended Events',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeeAllEventsPage(
                              events: recommendedEvents,
                              title: 'Recommended Events',
                            ),
                          ),
                        );
                      },
                      child: const Text("See all"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  // Row for all the categories
                  child: Row(
                    children: userPreferences
                        .map(
                          (category) => Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ChoiceChip(
                              label: Text(category.title),
                              selected: category.title == selectedCategory,
                              onSelected: (bool selected) async {
                                if (selected) {
                                  setState(() {
                                    selectedCategory = category.title;
                                    filterEventsByCategory(selectedCategory);
                                  });
                                }
                              },
                              selectedColor: const Color(0xFF448AFF),
                              backgroundColor: Colors.grey.withOpacity(0.2),
                              side: const BorderSide(color: Colors.white),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Recommended Events List
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: recommendedEvents.map((event) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: EventCard(
                        event: event,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Nearby Your Location Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Newest Event',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeeAllEventsPage(
                              events: newestEvents,
                              title: 'Newest Events',
                            ),
                          ),
                        );
                      },
                      child: const Text("See all"),
                    ),
                  ],
                ),
              ),

              // Newest Event List
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: newestEvents.map((event) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: EventCard(
                        event: event,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Free Events Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Free Events',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeeAllEventsPage(
                              events: freeEvents,
                              title: 'Free Events',
                            ),
                          ),
                        );
                      },
                      child: const Text("See all"),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: freeEvents.map((event) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: EventCard(
                        event: event,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
