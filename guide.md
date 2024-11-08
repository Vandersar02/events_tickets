### 1. **SharedPreferences (Android) / NSUserDefaults (iOS)**

- **Package Flutter** : `shared_preferences`
- **Type de données** : Idéal pour les petites données de type clé-valeur (par exemple, les préférences utilisateur, les configurations, les paramètres).
- **Persistance** : Persistant, même après le redémarrage de l'application.
- **Sécurité** : Non sécurisé pour des informations sensibles.

#### Exemple d'utilisation

```dart
import 'package:shared_preferences/shared_preferences.dart';

// Enregistrer une valeur
Future<void> saveUserName(String username) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('username', username);
}

// Récupérer une valeur
Future<String?> getUserName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}
```

### 2. **File Storage (Système de Fichiers)**

- **Package Flutter** : `path_provider` pour obtenir le chemin d'accès aux fichiers
- **Type de données** : Utilisé pour stocker des fichiers volumineux comme des images, des PDF, ou des fichiers JSON.
- **Persistance** : Persistant, même après le redémarrage de l'application.
- **Sécurité** : Non sécurisé pour des informations sensibles.

#### Exemple d'utilisation

```dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<File> getLocalFile(String filename) async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/$filename');
}

Future<void> writeData(String filename, String data) async {
  final file = await getLocalFile(filename);
  file.writeAsString(data);
}

Future<String?> readData(String filename) async {
  try {
    final file = await getLocalFile(filename);
    return await file.readAsString();
  } catch (e) {
    return null;
  }
}
```

### 3. **SQLite**

- **Package Flutter** : `sqflite`
- **Type de données** : Idéal pour stocker des données structurées et complexes (par exemple, les informations des utilisateurs, des tickets d'événements, des messages).
- **Persistance** : Persistant, même après le redémarrage de l'application.
- **Sécurité** : Relativement sécurisé, mais pas crypté par défaut. Pour des données sensibles, tu peux envisager de chiffrer la base de données.

#### Exemple d'utilisation

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> openDB() async {
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'app.db');

  return openDatabase(
    path,
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, email TEXT)',
      );
    },
    version: 1,
  );
}

Future<void> insertUser(String name, String email) async {
  final db = await openDB();
  await db.insert('users', {'name': name, 'email': email});
}

Future<List<Map<String, dynamic>>> getUsers() async {
  final db = await openDB();
  return db.query('users');
}
```

### 4. **Secure Storage**

- **Package Flutter** : `flutter_secure_storage`
- **Type de données** : Utilisé pour stocker des informations sensibles comme les tokens, les mots de passe ou toute donnée confidentielle.
- **Persistance** : Persistant, même après le redémarrage de l'application.
- **Sécurité** : Données chiffrées et stockées en toute sécurité. Le meilleur choix pour les informations sensibles.

#### Exemple d'utilisation

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<void> saveToken(String token) async {
  await storage.write(key: 'auth_token', value: token);
}

Future<String?> getToken() async {
  return await storage.read(key: 'auth_token');
}
```

### 5. **Hive (Base de Données NoSQL)**

- **Package Flutter** : `hive` et `hive_flutter` pour la configuration
- **Type de données** : Données structurées et non structurées (idéal pour des données à la fois simples et complexes).
- **Persistance** : Persistant, même après le redémarrage de l'application.
- **Sécurité** : Prend en charge le chiffrement, ce qui en fait une bonne option pour les données sensibles.

#### Exemple d'utilisation

```dart
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  await Hive.openBox('userBox');
}

Future<void> saveUserData(String username, String email) async {
  var box = Hive.box('userBox');
  box.put('username', username);
  box.put('email', email);
}

Future<String?> getUserData(String key) async {
  var box = Hive.box('userBox');
  return box.get(key);
}
```

### Choix de la Méthode selon le Besoin

| Type de Données                                                | Solution de Stockage   |
| -------------------------------------------------------------- | ---------------------- |
| Préférences utilisateurs (clés/valeurs simples)                | **SharedPreferences**  |
| Données sensibles (tokens, mots de passe)                      | **Secure Storage**     |
| Fichiers volumineux (PDF, images)                              | **File Storage**       |
| Données structurées et complexes (listes de tickets, messages) | **SQLite** ou **Hive** |
| Base de données NoSQL avec chiffrement                         | **Hive**               |

==========================================================================================================
