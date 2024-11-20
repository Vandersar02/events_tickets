import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> events = [];
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _fetchBookmarks();
  }

  void _fetchBookmarks() async {
    // Fetch bookmarks with associated event data
    final response = await supabase
        .from('bookmarks')
        .select('id, event_id, events!inner(*)')
        .filter('user_id', 'eq', supabase.auth.currentUser!.id);

    setState(() {
      events = List<Map<String, dynamic>>.from(response);
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  Future<void> _removeBookmark(String bookmarkId) async {
    try {
      // Remove the bookmark from the database
      await supabase.from('bookmarks').delete().eq('id', bookmarkId);

      // Refresh the UI after deletion
      _fetchBookmarks();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bookmark removed successfully')),
      );
    } catch (error) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to remove bookmark')),
      );
    }
  }

  void _showRemoveDialog(Map<String, dynamic> event) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Details in the Modal
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      event['events']['image_url'],
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['events']['title'],
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _formatDate(event['events']['date']),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Remove from your bookmark?',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the modal
                      _removeBookmark(event['id']); // Call remove function
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: const Text('Yes, Remove'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('dd MMM').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = selectedCategory == 'All'
        ? events
        : events
            .where((e) => e['events']['category'] == selectedCategory)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmark'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchBookmarks,
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryButton('All'),
                _buildCategoryButton('Art'),
                _buildCategoryButton('Music'),
                _buildCategoryButton('Sport'),
              ],
            ),
          ),
          const Divider(),
          // Events List
          Expanded(
            child: ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                return _buildEventCard(event);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark), label: 'Bookmark'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    final isSelected = selectedCategory == category;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: () => _filterByCategory(category),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blueAccent : Colors.grey[200],
          foregroundColor: isSelected ? Colors.white : Colors.black,
        ),
        child: Text(category),
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              event['events']['image_url'],
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Date
                Align(
                  alignment: Alignment.topRight,
                  child: Chip(
                    label: Text(
                      _formatDate(event['events']['date']),
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                ),
                // Event Title
                Text(
                  event['events']['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Event Category and Attendees
                Row(
                  children: [
                    Text(
                      event['events']['category'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[700],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text('${event['events']['attendees_count']}+ Going'),
                  ],
                ),
                // Event Location
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16),
                        Text(
                          event['events']['location'],
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    // Bookmark Remove Icon
                    IconButton(
                      onPressed: () => _showRemoveDialog(event),
                      icon:
                          const Icon(Icons.bookmark_remove, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
