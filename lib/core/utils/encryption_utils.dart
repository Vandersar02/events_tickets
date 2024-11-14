import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

class EncryptionUtils {
// Function to decrypt and verify the signed data
  static String? decryptAndVerifyQrDataReal(
      String? encryptedData, String secretKey) {
    try {
      // Step 1: Extract IV and encrypted data
      final ivData = encryptedData!
          .substring(0, 24); // Assume que l'IV fait 16 octets encodés en base64
      final encryptedDataWithoutIv =
          encryptedData.substring(24); // Le reste est le message chiffré

      final iv = encrypt.IV.fromBase64(ivData);
      final key = encrypt.Key.fromUtf8(secretKey);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      // Step 2: Decrypt the data
      final decrypted = encrypter.decrypt64(encryptedDataWithoutIv, iv: iv);

      // Step 3: Separate ticketData and signature
      final parts = decrypted.split("|signature=");
      if (parts.length != 2) {
        return null; // Invalid data format
      }
      final ticketData = parts[0];
      final providedSignature = parts[1];

      // Step 4: Recalculate and verify the signature
      var bytes =
          utf8.encode(ticketData + secretKey); // Combine data and secret key
      var recalculatedSignature =
          sha256.convert(bytes).toString(); // Generate SHA-256 hash

      if (providedSignature == recalculatedSignature) {
        return ticketData; // Data is valid
      } else {
        return null; // Signature mismatch, data might be corrupted or tampered with
      }
    } catch (e) {
      print("Decryption or verification failed: $e");
      return null;
    }
  }

  static String generateSignedAndEncryptedQrData(
      String ticketData, String secretKey) {
    // Step 1: Create a signature using SHA-256
    var bytes = utf8.encode(ticketData + secretKey);
    var signature = sha256.convert(bytes).toString(); // Generate SHA-256 hash

    // Step 2: Encrypt the data with AES
    final key = encrypt.Key.fromUtf8(secretKey);
    final iv = encrypt.IV.fromSecureRandom(16); // Génère un IV aléatoire
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    // Combine ticketData with the signature
    final combinedData = "$ticketData|signature=$signature";
    final encrypted = encrypter.encrypt(combinedData, iv: iv);

    return iv.base64 + encrypted.base64; // Return IV + encrypted data
  }
}
