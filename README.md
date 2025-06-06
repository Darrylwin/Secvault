# SecVault

SecVault est une application Flutter de coffre-fort numérique multi-utilisateur permettant le stockage sécurisé et le partage de fichiers confidentiels.

## 🚀 Installation et démarrage rapide

### Prérequis
- [Flutter](https://flutter.dev/docs/get-started/install) (SDK recommandé : 3.x)
- Compte Firebase (pour l’authentification et le stockage)
- Android Studio, VS Code ou tout IDE compatible Flutter

### Configuration
1. Clonez ce dépôt :
   ```bash
   git clone https://github.com/Darrylwin/Secvault.git
   cd secvault
   ```
2. Installez les dépendances :
   ```bash
   flutter pub get
   ```
3. Configurez Firebase :
   - Ajoutez votre fichier `google-services.json` (Android) dans `android/app/`.
   - Ajoutez votre fichier `GoogleService-Info.plist` (iOS) dans `ios/Runner/`.
4. Lancez l’application :
   ```bash
   flutter run
   ```

## 🏗️ Architecture du projet

- `lib/` : Code source principal
  - `core/` : Thèmes, routes, helpers, gestion des erreurs
  - `features/` : Modules fonctionnels
    - `auth/` : Authentification (Firebase Auth)
    - `vaults/` : Gestion des coffres
    - `secured_files/` : Gestion des fichiers sécurisés (chiffrement, stockage)
    - `access_control/` : Contrôle d’accès et permissions
- `assets/` : Images et ressources statiques
- `integration_test/` : Tests d’intégration

## ✨ Fonctionnalités principales

### 🔐 Authentification
- Connexion / inscription via Firebase Auth
- Déconnexion
- Gestion du profil utilisateur

### 🏛️ Gestion des coffres
- Création de coffres personnels
- Liste des coffres accessibles
- Gestion des métadonnées (nom, description)
- Suppression d’un coffre (admin uniquement)

### 📁 Fichiers sécurisés
- Ajout, suppression et téléchargement de fichiers
- Chiffrement/déchiffrement côté client
- Stockage sécurisé dans Firebase Storage

### 👥 Contrôle d’accès
- Partage de coffres avec d’autres utilisateurs
- Gestion des rôles (propriétaire, lecteur)
- Révocation d’accès

### 🕓 Historique
- Suivi des accès et des modifications sur les fichiers et coffres

## 🧪 Tests

Lancez les tests d’intégration :
```bash
flutter test integration_test/
```

## 📚 Technologies principales
- Flutter
- Firebase Auth, Firestore & Storage
- Chiffrement côté client (ex : package `encrypt`)

---

Pour toute contribution, suggestion ou bug, merci d’ouvrir une issue ou une pull request.
