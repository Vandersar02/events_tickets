import 'package:supabase_flutter/supabase_flutter.dart';

class EventsServices {
  final supabase = Supabase.instance.client;

  Future<void> createEvents(User? user, String events) async {}
}
