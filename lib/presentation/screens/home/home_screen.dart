import 'package:events_ticket/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:events_ticket/data/models/events.dart';
import 'components/event_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    int getCrossAxisCount() {
      if (screenWidth >= 1200) {
        return 4;
      } else if (screenWidth >= 1000) {
        return 3;
      } else if (screenWidth >= 600) {
        return 2;
      } else {
        return 1;
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Upcoming Events",
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
                  "Nearest events",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  shrinkWrap: true, // Limite la hauteur du GridView
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: getCrossAxisCount(),
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                    childAspectRatio: 2.0,
                  ),
                  itemCount: popularEvents.length,
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
