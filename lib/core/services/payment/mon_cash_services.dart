import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// URL pour récupérer le token d'authentification
const String authUrl =
    'https://sandbox.moncashbutton.digicelgroup.com/MerChantApi/oauth/token';
const String initiatePaymentUrl =
    'https://sandbox.moncashbutton.digicelgroup.com/MerChantApi/V1/InitiatePayment';
const String confirmPaymentUrl =
    'https://sandbox.moncashbutton.digicelgroup.com/MerChantApi/V1/Payment';
const String checkPaymentUrl =
    'https://sandbox.moncashbutton.digicelgroup.com/MerChantApi/V1/CheckPayment';

// Récupérer les identifiants MonCash du fichier .env
// final String clientId = dotenv.env['MONCASH_CLIENT_ID']!;
// final String clientSecret = dotenv.env['MONCASH_CLIENT_SECRET']!;

const String clientId = 'ee1609349d7d1076730c1daa7a1a112a';
const String clientSecret =
    'oHrr4tbnB1PH0uz6VQNUvXroyjrsA3qhrSHZrzddx5rmrgMQXfSqB2uAn8uHcdJR';

// Function to get access token
Future<String?> getAccessToken() async {
  try {
    var headers = {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    var body = {'scope': 'read,write', 'grant_type': 'client_credentials'};

    var response = await http.post(
      Uri.parse(authUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      print(
          "Erreur lors de la récupération du token : ${response.statusCode} - ${response.reasonPhrase}");
      return null;
    }
  } on SocketException {
    print('Pas de connexion Internet ou le serveur est inaccessible.');
    return null;
  } catch (e) {
    print('Erreur lors de la récupération du token : $e');
    return null;
  }
}

// Fonction pour initier un paiement
Future<void> initiatePayment(
    String reference, String account, double amount) async {
  String? accessToken = await getAccessToken();
  if (accessToken == null) {
    print("Impossible d'obtenir le token d'accès.");
    return;
  }

  var headers = {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json'
  };

  var body = jsonEncode(
      {"reference": reference, "account": account, "amount": amount});

  var response = await http.post(
    Uri.parse(initiatePaymentUrl),
    headers: headers,
    body: body,
  );

  if (response.statusCode == 201) {
    // Initiate Payment usually returns 201
    var data = jsonDecode(response.body);
    print("Paiement initié avec succès : $data");
  } else {
    print(
        "Erreur lors de l'initiation du paiement : ${response.statusCode} - ${response.reasonPhrase}");
  }
}

// Fonction pour confirmer un paiement
Future<void> confirmPayment(
    String reference, String account, double amount) async {
  String? accessToken = await getAccessToken();
  if (accessToken == null) {
    print("Impossible d'obtenir le token d'accès.");
    return;
  }

  var headers = {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json'
  };

  var body = jsonEncode(
      {"reference": reference, "account": account, "amount": amount});

  var response = await http.post(
    Uri.parse(confirmPaymentUrl),
    headers: headers,
    body: body,
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    print("Paiement confirmé : $data");
  } else {
    print(
        "Erreur lors de la confirmation du paiement : ${response.statusCode} - ${response.reasonPhrase}");
  }
}

// Fonction pour vérifier le statut du paiement
Future<void> checkPaymentStatus(
    {String? transactionId, String? reference}) async {
  String? accessToken = await getAccessToken();
  if (accessToken == null) {
    print("Impossible d'obtenir le token d'accès.");
    return;
  }

  var headers = {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json'
  };

  var body = jsonEncode({
    if (transactionId != null) "transactionId": transactionId,
    if (reference != null) "reference": reference,
  });

  var response = await http.post(
    Uri.parse(checkPaymentUrl),
    headers: headers,
    body: body,
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    print("Statut du paiement : $data");
  } else {
    print(
        "Erreur lors de la vérification du paiement : ${response.statusCode} - ${response.reasonPhrase}");
  }
}
