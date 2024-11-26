import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

class EncryptionUtils {
  // Fonction pour générer des données signées et chiffrées à partir d'un dictionnaire
  static String generateSignedAndEncryptedQrDataFromMap(
      Map<String, dynamic> data, String secretKey) {
    // Convertir le dictionnaire en JSON
    String jsonData = jsonEncode(data);

    // Générer une signature en utilisant SHA-256
    var bytes = utf8.encode(jsonData + secretKey);
    var signature = sha256.convert(bytes).toString();

    // Chiffrer les données avec AES
    final key = encrypt.Key.fromUtf8(secretKey);
    final iv = encrypt.IV.fromSecureRandom(16); // Génère un IV aléatoire
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    // Combiner les données JSON avec la signature
    final combinedData = "$jsonData|signature=$signature";
    final encrypted = encrypter.encrypt(combinedData, iv: iv);

    // Retourner la combinaison de l'IV et des données chiffrées
    return iv.base64 + encrypted.base64;
  }

  // Fonction pour déchiffrer et vérifier les données chiffrées en tant que dictionnaire
  static Map<String, dynamic>? decryptAndVerifyQrDataToMap(
      String? encryptedData, String secretKey) {
    try {
      if (encryptedData == null || encryptedData.length < 24) {
        throw Exception("Invalid encrypted data format");
      }

      // Extraire l'IV et les données chiffrées
      final ivData = encryptedData.substring(0, 24);
      final encryptedDataWithoutIv = encryptedData.substring(24);

      final iv = encrypt.IV.fromBase64(ivData);
      final key = encrypt.Key.fromUtf8(secretKey);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      // Déchiffrer les données
      final decrypted = encrypter.decrypt64(encryptedDataWithoutIv, iv: iv);

      // Séparer les données et la signature
      final parts = decrypted.split("|signature=");
      if (parts.length != 2) {
        throw Exception("Invalid data format");
      }
      final jsonData = parts[0];
      final providedSignature = parts[1];

      // Vérifier la signature
      var bytes = utf8.encode(jsonData + secretKey);
      var recalculatedSignature = sha256.convert(bytes).toString();

      if (providedSignature != recalculatedSignature) {
        throw Exception("Signature mismatch");
      }

      // Convertir les données JSON en dictionnaire
      return jsonDecode(jsonData);
    } catch (e) {
      print("Decryption or verification failed: $e");
      return null;
    }
  }
}
