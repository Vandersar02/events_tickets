import 'package:events_ticket/presentation/screens/auth/login_screen.dart';
import 'package:events_ticket/presentation/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String eventList = '/events';
  static const String eventDetails = '/event-details';
  static const String ticket = '/ticket';
  static const String socialFeed = '/social';
  static const String postDetails = '/post-details';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      // case eventList:
      //   return MaterialPageRoute(builder: (_) => EventListScreen());
      // case eventDetails:
      //   var eventId = settings.arguments as String;
      //   return MaterialPageRoute(builder: (_) => EventDetailsScreen(eventId: eventId));
      // case ticket:
      //   return MaterialPageRoute(builder: (_) => TicketScreen());
      // case socialFeed:
      //   return MaterialPageRoute(builder: (_) => SocialFeedScreen());
      // case postDetails:
      //   var postId = settings.arguments as String;
      //   return MaterialPageRoute(builder: (_) => PostDetailScreen(postId: postId));
      default:
        return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }
}
