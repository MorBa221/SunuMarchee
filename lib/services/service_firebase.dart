import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../modeles/annonce.dart';
import '../modeles/utilisateur.dart';

class ServiceFirebase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  
  Future<String?> connecterUtilisateur({
    required String email,
    required String motDePasse,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: motDePasse,
      );

      String uid = userCredential.user!.uid;

      
      DocumentSnapshot doc = await _db.collection('utilisateurs').doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        utilisateurConnecte = Utilisateur(
          id: uid,
          nomComplet: data['nomComplet'] ?? '',
          email: data['email'] ?? '',
          numeroTelephone: data['numeroTelephone'] ?? '',
          estVerifie: data['estVerifie'] ?? true,
        );
      } else {
        utilisateurConnecte = Utilisateur(
          id: uid,
          nomComplet: 'Utilisateur',
          email: email,
          numeroTelephone: '',
        );
      }

      return null; 
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Erreur lors de la connexion.';
    } catch (e) {
      return 'Erreur inattendue : ${e.toString()}';
    }
  }

  
  Future<String?> inscrireUtilisateur({
    required String email,
    required String motDePasse,
    required String nomComplet,
    required String telephone,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: motDePasse,
      );

      String uid = userCredential.user!.uid;

      await _db.collection('utilisateurs').doc(uid).set({
        'id': uid,
        'nomComplet': nomComplet,
        'email': email,
        'numeroTelephone': telephone,
        'estVerifie': true,
      });

      utilisateurConnecte = Utilisateur(
        id: uid,
        nomComplet: nomComplet,
        email: email,
        numeroTelephone: telephone,
        estVerifie: true,
      );

      return null; // Succès
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Erreur lors de l\'inscription.';
    } catch (e) {
      return 'Erreur inattendue : ${e.toString()}';
    }
  }

  
  Future<bool> changerStatutAnnonce(String idAnnonce, bool nouveauStatut) async {
    try {
      await _db.collection('annonces').doc(idAnnonce).update({
        'estVendu': nouveauStatut,
      });
      return true;
    } catch (e) {
      print('Erreur changement statut : $e');
      return false;
    }
  }

 
  Future<bool> supprimerAnnonce(String idAnnonce) async {
    try {
      await _db.collection('annonces').doc(idAnnonce).delete();
      return true;
    } catch (e) {
      print('Erreur suppression annonce : $e');
      return false;
    }
  }

  
  Future<bool> publierAnnonce({
    required String titre,
    required double prix,
    required String description,
    required String categorie,
    required String localisation,
    required List<String> images,
    required String numeroTelephone,
    required String idVendeur,
  }) async {
    try {
      await _db.collection('annonces').add({
        'titre': titre,
        'prix': prix,
        'description': description,
        'categorie': categorie,
        'localisation': localisation,
        'images': images,
        'numeroTelephone': numeroTelephone,
        'idVendeur': idVendeur,
        'estVendu': false,
        'dateCreation': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Erreur Publication : $e');
      return false;
    }
  }

  
  Stream<List<Annonce>> obtenirAnnonces() {
    return _db
        .collection('annonces')
        .orderBy('dateCreation', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Annonce(
          id: doc.id,
          titre: data['titre'] ?? '',
          prix: (data['prix'] as num).toDouble(),
          description: data['description'] ?? '',
          categorie: data['categorie'] ?? '',
          localisation: data['localisation'] ?? '',
          images: List<String>.from(data['images'] ?? []),
          numeroTelephone: data['numeroTelephone'] ?? '',
          idVendeur: data['idVendeur'] ?? '',
          estVendu: data['estVendu'] ?? false,
        );
      }).toList();
    });
  }
}