import 'package:flutter/material.dart';
import 'package:events_ticket/data/models/events.dart';
import 'components/event_card.dart';
import 'package:events_ticket/presentation/widgets/custom_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              // Featured Section
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
                            'assets/images/event2.jpg',
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: 15,
                            left: 15,
                            child: ElevatedButton(
                              onPressed: () {},
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
                      'Trending',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("See all"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ["All", "Summer", "Music", "Pool Party"]
                        .map((category) => Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: ChoiceChip(
                                label: Text(category),
                                selected: category == "All",
                                onSelected: (bool selected) {},
                                selectedColor: const Color(0xFF448AFF),
                                backgroundColor: Colors.grey.withOpacity(0.2),
                                side: const BorderSide(color: Colors.white),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Trending Events List
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: events.map((event) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: EventCard(
                        title: event.title,
                        date: event.date,
                        location: event.location,
                        imageUrl: event.imageUrl,
                        isFree: event.isFree,
                        attendeesCount: event.attendeesCount,
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
                      'Nearby Your Location',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("See all"),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: events.map((event) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: EventCard(
                        title: event.title,
                        date: event.date,
                        location: event.location,
                        imageUrl: event.imageUrl,
                        isFree: event.isFree,
                        attendeesCount: event.attendeesCount,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Newest Event Section
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
                      onPressed: () {},
                      child: const Text("See all"),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: events.map((event) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: EventCard(
                        title: event.title,
                        date: event.date,
                        location: event.location,
                        imageUrl: event.imageUrl,
                        isFree: event.isFree,
                        attendeesCount: event.attendeesCount,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
