import 'package:flutter/material.dart';

class SearchEventsPage extends StatefulWidget {
  const SearchEventsPage({super.key});

  @override
  State<SearchEventsPage> createState() => _SearchEventsPageState();
}

class _SearchEventsPageState extends State<SearchEventsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF7553F6),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.grey),
                      ),
                      style: const TextStyle(color: Colors.black),
                      onTap: () {
                        // Logique de recherche
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_alt_outlined,
                        color: Colors.black),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const FilterModal(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text(
          "No events found.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}

class FilterModal extends StatefulWidget {
  const FilterModal({super.key});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  String selectedCategory = "Art";
  String selectedDate = "Tomorrow";
  String location = "New York, USA";
  RangeValues priceRange = const RangeValues(20, 120);

  final List<String> categories = ["Sports", "Music", "Art", "Food"];
  final List<String> dates = ["Today", "Tomorrow", "This week"];

//   void applyFilter() async {
//   List<EventModel> filteredEvents = await filterEvents(
//     category: selectedCategory,
//     date: selectedDate,
//     location: location,
//     minPrice: priceRange.start,
//     maxPrice: priceRange.end,
//   );
//   // Navigate to the results page or display the filtered events
//   print("Filtered Events: ${filteredEvents.length}");
// }

  void applyFilter() {
    // Exemple d'affichage des valeurs sélectionnées
    print("Category: $selectedCategory");
    print("Date: $selectedDate");
    print("Location: $location");
    print("Price Range: ${priceRange.start} - ${priceRange.end}");
    Navigator.pop(context); // Ferme le modal après application
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              // Titre du modal
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Filter Events",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Categories
              const Text("Category",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: categories.map((category) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: selectedCategory == category
                              ? Colors.blue
                              : Colors.grey.shade300,
                          child: Icon(
                            Icons.category,
                            color: selectedCategory == category
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(category, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Dates
              const Text("Time & Date",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: dates.map((date) {
                  return ChoiceChip(
                    label: Text(date),
                    selected: selectedDate == date,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Price Range
              const Text("Price Range",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              RangeSlider(
                values: priceRange,
                min: 0,
                max: 200,
                divisions: 20,
                onChanged: (RangeValues values) {
                  setState(() {
                    priceRange = values;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Boutons Reset et Apply
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedCategory = "Art";
                        selectedDate = "Tomorrow";
                        location = "New York, USA";
                        priceRange = const RangeValues(20, 120);
                      });
                    },
                    child: const Text("RESET"),
                  ),
                  ElevatedButton(
                    onPressed: applyFilter,
                    child: const Text("APPLY"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}




// Future<List<EventModel>> filterEvents({
//   required String category,
//   required String date,
//   required String location,
//   required double minPrice,
//   required double maxPrice,
// }) async {
//   List<EventModel> allEvents = await fetchAllEvents();

//   return allEvents.where((event) {
//     // Filter by category
//     if (event.category != category) return false;

//     // Filter by date
//     DateTime eventDate = DateTime.parse(event.date);
//     if (date == "Today" && !isToday(eventDate)) return false;
//     if (date == "Tomorrow" && !isTomorrow(eventDate)) return false;
//     if (date == "This week" && !isThisWeek(eventDate)) return false;

//     // Filter by location
//     if (event.location != location) return false;

//     // Filter by price range
//     if (event.price < minPrice || event.price > maxPrice) return false;

//     return true;
//   }).toList();
// }

// bool isToday(DateTime date) {
//   DateTime now = DateTime.now();
//   return date.year == now.year &&
//       date.month == now.month &&
//       date.day == now.day;
// }

// bool isTomorrow(DateTime date) {
//   DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
//   return date.year == tomorrow.year &&
//       date.month == tomorrow.month &&
//       date.day == tomorrow.day;
// }

// bool isThisWeek(DateTime date) {
//   DateTime now = DateTime.now();
//   DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
//   DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
//   return date.isAfter(startOfWeek) && date.isBefore(endOfWeek);
// }



