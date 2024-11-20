import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    // _fetchNotifications();
    // _subscribeToRealtime();
  }

  void _fetchNotifications() async {
    final response = await supabase
        .from('notifications')
        .select()
        .order('created_at', ascending: false);

    setState(() {
      notifications = List<Map<String, dynamic>>.from(response);
    });
  }

  void _subscribeToRealtime() {
    // supabase.channel('public:notifications').on(
    //   SupabaseEventTypes.insert,
    //   (payload) {
    //     setState(() {
    //       notifications.insert(0, payload['new']);
    //     });
    //   },
    // ).subscribe();
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('dd MMM, yyyy | hh:mm a').format(date);
  }

  @override
  void dispose() {
    // supabase.removeChannel('public:notifications');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
        actions: [
          IconButton(
            onPressed: _fetchNotifications,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          final isNew = notification['is_new'] as bool;
          final type = notification['type'] as String;
          final color = _getIconColor(type);

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(
                _getIcon(type),
                color: color,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    notification['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                if (isNew)
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Chip(
                      label: Text('New'),
                      backgroundColor: Colors.blueAccent,
                      labelStyle: TextStyle(color: Colors.white),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification['message']),
                const SizedBox(height: 6),
                Text(
                  _formatDate(notification['created_at']),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            onTap: () {
              // Handle notification tap
            },
          );
        },
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'success':
        return Icons.check_circle;
      case 'info':
        return Icons.info;
      case 'alert':
        return Icons.warning;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'success':
        return Colors.green;
      case 'info':
        return Colors.blue;
      case 'alert':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
