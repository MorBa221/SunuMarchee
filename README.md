# SunuMarche 📱🛒

**SunuMarche** est une application mobile de type marketplace développée avec **Flutter** et **Firebase**. Elle permet aux utilisateurs de publier des annonces de vente ou de recherche, de consulter les offres en temps réel, d'effectuer des appels téléphoniques et de contacter directement les vendeurs sur WhatsApp.

---

## 🎥 Démonstration Vidéo
La vidéo de démonstration de l'application (durée < 5 min) présentant les différentes fonctionnalités en cours d'utilisation est disponible ici :
👉 **[Lien de la vidéo de démonstration (Google Drive)](https://drive.google.com/file/d/1x9xlnqsIoidwBQwJcms1N4Q-j6ruLMjN/view?usp=sharing)**

---

## 🚀 Fonctionnalités Principales
* **Authentification sécurisée :** Inscription et connexion des utilisateurs via Firebase Auth.
* **Gestion des annonces :** Publication d'annonces comportant un titre, un prix, une description, une localisation et plusieurs photos (avec optimisation et compression pour éviter les surcharges mémoire sur l'appareil).
* **Consultation dynamique :** Affichage en temps réel des annonces grâce à Cloud Firestore.
* **Intégration native :** 
  * Lancement d'appels téléphoniques directs.
  * Ouverture automatique de **WhatsApp** avec un message pré-rempli et le numéro du vendeur.

---

## 🛠️ Stack Technique & Outils
* **Frontend :** Flutter / Dart (UI multi-plateforme, Material Design)
* **Backend & Base de données :** Firebase Authentication & Cloud Firestore
* **Packages clés :** `firebase_core`, `cloud_firestore`, `firebase_auth`, `image_picker`, `url_launcher`
* **Environnement de développement :** Visual Studio Code, Git & GitHub, Test sur appareil physique Android (Samsung SM-A055F).

---

## 📂 Structure du Projet
```text
SunuMarchee/
│
├── lib/
│   ├── ecrans/         # Écrans de l'application (Auth, Accueil, Publication, Détails, Profil)
│   ├── modeles/        # Modèles de données (Annonce, Utilisateur)
│   ├── services/       # Logique métier et interactions avec Firebase
│   └── main.dart       # Point d'entrée de l'application
│
├── android/            # Configuration native Android (AndroidManifest, requêtes WhatsApp)
├── test/               # Tests unitaires et de widgets
└── pubspec.yaml        # Dépendances et gestion des assets
