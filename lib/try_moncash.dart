import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

const String clientId = 'your_client_id';
const String clientSecret = 'your_client_secret';

// Function to get access token
Future<String?> getAccessToken() async {
  try {
    final response = await http.post(
      Uri.parse(
          'https://sandbox.moncashbutton.digicelgroup.com/MerChantApi/oauth/token'),
      body: {'grant_type': 'client_credentials', 'scope': 'read,write'},
      encoding: Encoding.getByName('utf-8'),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      print('Failed to get access token: ${response.reasonPhrase}');
      return null;
    }
  } on SocketException {
    print('No Internet connection or server is down.');
    return null;
  } catch (e) {
    print('Error fetching access token: $e');
    return null;
  }
}

// Function to create a payment
Future<void> createPayment(
    String accessToken, String reference, String account, double amount) async {
  try {
    final response = await http.post(
      Uri.parse(
          'https://sandbox.moncashbutton.digicelgroup.com/MerChantApi/V1/InitiatePayment'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(
          {'reference': reference, 'account': account, 'amount': amount}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Payment created successfully: ${data}');
    } else {
      print('Failed to create payment: ${response.reasonPhrase}');
    }
  } on SocketException {
    print('No Internet connection or server is down.');
  } catch (e) {
    print('Error creating payment: $e');
  }
}

// Function to check payment status
Future<void> checkPayment(String accessToken, String transactionId) async {
  try {
    final response = await http.post(
      Uri.parse(
          'https://sandbox.moncashbutton.digicelgroup.com/MerChantApi/V1/CheckPayment'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({'transactionId': transactionId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Payment details: ${data}');
    } else {
      print('Failed to check payment: ${response.reasonPhrase}');
    }
  } on SocketException {
    print('No Internet connection or server is down.');
  } catch (e) {
    print('Error checking payment status: $e');
  }
}


// import 'package:events_ticket/try_moncash.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text('MonCash API Integration')),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () async {
//               final accessToken = await getAccessToken();
//               if (accessToken != null) {
//                 await createPayment(
//                     accessToken, 'reference123', '50938662809', 100.0);
//                 await checkPayment(accessToken, 'transaction_id');
//               } else {
//                 print('Failed to retrieve access token.');
//               }
//             },
//             child: Text('Start Payment Process'),
//           ),
//         ),
//       ),
//     );
//   }
// }
