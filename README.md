# Event Ticket - Application Mobile pour la Gestion d'Événements

**Event Ticket** est une application mobile développée en Flutter, conçue pour faciliter la gestion et l'achat de tickets pour divers événements. L’application offre aux utilisateurs la possibilité de découvrir des événements, d’acheter des tickets, et de partager leurs expériences. Les administrateurs peuvent valider les tickets des participants via un scanner QR intégré.

## Fonctionnalités

- **Inscription et Connexion Sécurisées** : Authentification via Firebase.
- **Personnalisation des Préférences d'Événements** : Les utilisateurs peuvent sauvegarder leurs préférences.
- **Paiement Intégré** : Intégration de MonCash pour un paiement sécurisé.
- **Gestion des Tickets** : Génération de QR codes pour les tickets achetés, et validation par scan.
- **Thème Adaptatif** : Prise en charge du mode sombre et clair en fonction des paramètres de l’appareil.
- **Partage Social** : Les utilisateurs peuvent partager des photos et des vidéos de leurs événements.

## Prérequis

- Flutter SDK (dernière version stable) [Installation Flutter](https://flutter.dev/docs/get-started/install)
- Compte Firebase configuré pour l'authentification, Firestore et le stockage
- Clés d’API MonCash pour le paiement

## Installation

1. **Clone le dépôt (pour usage interne uniquement)** :

   ```bash
   git clone https://your-repository-url.git
   cd event_ticket
   ```

2. **Installer les dépendances Flutter** :

   ```bash
   flutter pub get
   ```

3. **Configurer Firebase** :

   - Crée un projet Firebase et télécharge les fichiers `google-services.json` (pour Android) et `GoogleService-Info.plist` (pour iOS).
   - Place ces fichiers dans `android/app` et `ios/Runner`, respectivement.

4. **Ajouter les Identifiants MonCash dans un fichier `.env`** :
   Crée un fichier `.env` à la racine du projet avec les informations d’authentification MonCash.

   ```plaintext
   MONCASH_CLIENT_ID=your_client_id
   MONCASH_CLIENT_SECRET=your_client_secret
   ```

5. **Lancer l’application** :
   ```bash
   flutter run
   ```

## Utilisation de l'Application

1. **Connexion Utilisateur** :
   Les utilisateurs peuvent s’inscrire et se connecter avec Firebase Authentication.

2. **Achat de Tickets** :
   En utilisant l’intégration MonCash, les utilisateurs peuvent acheter des tickets pour des événements. Une fois le paiement effectué, un QR code unique est généré pour chaque ticket.

3. **Gestion des Thèmes** :
   L’application s’adapte automatiquement aux modes sombre et clair de l’appareil. Une option de changement de thème est disponible dans les paramètres.

4. **Vérification des Tickets** :
   Les administrateurs peuvent scanner les QR codes des participants pour vérifier leur validité.

## Architecture du Code

Le projet est structuré pour être modulaire et extensible.

```plaintext
lib/
├── main.dart
├── config/
│   ├── routes/
│   └── themes/
├── core/
│   ├── services/
│   │   ├── auth/
│   │   ├── messaging/
│   │   ├── storage/
│   │   └── ticket/
│   ├── models/
│   └── utils/
├── data/
│   ├── models/
│   ├── providers/
│   └── repositories/
└── presentation/
    ├── screens/
    │   ├── auth/
    │   ├── events/
    │   ├── ticket/
    │   └── social/
    └── widgets/
```

## Gestion des Thèmes

L’application détecte automatiquement le mode sombre ou clair de l’appareil. Les utilisateurs peuvent également basculer manuellement entre les thèmes dans les paramètres. La configuration des thèmes se trouve dans le fichier `app_themes.dart`.

## Technologies Utilisées

- **Flutter** : Développement multiplateforme.
- **Firebase** : Backend pour l'authentification, la base de données et le stockage.
- **MonCash API** : Système de paiement pour les tickets.
- **Provider** : Gestion de l’état global de l’application.
- **SharedPreferences** : Pour sauvegarder la session utilisateur en local.

## Sécurité des Données

Les informations sensibles (identifiants d'API et clés de sécurité) sont stockées dans un fichier `.env` non inclus dans le dépôt.

## Support

Pour toute question ou assistance technique, merci de contacter l'équipe de développement interne.

## Licence et Confidentialité

Cette application est strictement privée et non open-source. Toute utilisation, distribution, ou modification du code sans autorisation explicite est interdite.
