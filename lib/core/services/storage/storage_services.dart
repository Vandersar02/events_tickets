// import 'package:firebase_storage/firebase_storage.dart';
// import 'dart:io';

// class StorageService {
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   Future<String?> uploadFile(File file, String fileName) async {
//     try {
//       Reference ref = _storage.ref().child('user_images/$fileName');
//       UploadTask uploadTask = ref.putFile(file);
//       TaskSnapshot taskSnapshot = await uploadTask;
//       return await taskSnapshot.ref.getDownloadURL();
//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }
// }
