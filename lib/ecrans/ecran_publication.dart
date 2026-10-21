import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../modeles/utilisateur.dart';
import '../services/service_firebase.dart';

class EcranPublication extends StatefulWidget {
  const EcranPublication({super.key});

  @override
  State<EcranPublication> createState() => _EcranPublicationState();
}

class _EcranPublicationState extends State<EcranPublication> {
  final _cleFormulaire = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  
  List<XFile> _imagesSelectionnees = [];
  String titre = '';
  double prix = 0;
  String description = '';
  String categorie = 'Téléphones & Tablettes'; // Valeur sélectionnée par défaut
  String localisation = '';
  bool _estEnCours = false;

  // Liste des catégories disponibles pour l'utilisateur
  final List<String> _categories = [
    'Téléphones & Tablettes',
    'Électronique & Informatique',
    'Véhicules & Immo',
    'Mode & Beauté',
    'Maison & Jardin',
    'Autres'
  ];

  Future<void> _choisirDepuisGalerie() async {
  final List<XFile> images = await _picker.pickMultiImage(
    maxWidth: 1000,
    maxHeight: 1000,
    imageQuality: 80,
  );

  if (images.isNotEmpty) {
    setState(() {
      _imagesSelectionnees.addAll(images);
    });
  }
}

  Future<void> _prendrePhoto() async {
  // Capture de la photo avec réduction de résolution pour préserver la RAM
  final XFile? photo = await _picker.pickImage(
    source: ImageSource.camera,
    maxWidth: 1000,      // Limite la largeur (évite les photos trop lourdes)
    maxHeight: 1000,     // Limite la hauteur
    imageQuality: 80,    // Compresse la qualité à 80%
  );

  if (photo != null) {
    setState(() {
      // Ajoute la photo capturée à la liste existante (permet d'en prendre plusieurs)
      _imagesSelectionnees.add(photo);
    });
  }
}

  Future<void> _publierAnnonce() async {
    if (utilisateurConnecte == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez vous connecter pour publier une annonce.')),
      );
      return;
    }

    if (_cleFormulaire.currentState!.validate()) {
      _cleFormulaire.currentState!.save();
      setState(() { _estEnCours = true; });

      List<String> cheminsImages = _imagesSelectionnees.map((e) => e.path).toList();

      bool succes = await ServiceFirebase().publierAnnonce(
        titre: titre,
        prix: prix,
        description: description,
        categorie: categorie,
        localisation: localisation,
        images: cheminsImages,
        numeroTelephone: utilisateurConnecte!.numeroTelephone,
        idVendeur: utilisateurConnecte!.id,
      );

      setState(() { _estEnCours = false; });

      if (succes) {
        setState(() {
          _imagesSelectionnees.clear();
        });
        _cleFormulaire.currentState!.reset();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Annonce publiée sur Firebase avec succès !')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur lors de la publication sur Firebase.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (utilisateurConnecte == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Publier une Annonce')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 60, color: Colors.grey),
              SizedBox(height: 10),
              Text('Vous devez avoir un compte pour publier.'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Publier une Annonce'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _cleFormulaire,
          child: ListView(
            children: [
              const Text(
                'Photos du produit (Prise directe ou Galerie)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _prendrePhoto,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Prendre photo'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _choisirDepuisGalerie,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Galerie'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (_imagesSelectionnees.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _imagesSelectionnees.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(File(_imagesSelectionnees[index].path)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _imagesSelectionnees.removeAt(index);
                                });
                              },
                              child: const CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.red,
                                child: Icon(Icons.close, size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Titre de l\'annonce'),
                validator: (val) => val == null || val.isEmpty ? 'Veuillez entrer un titre' : null,
                onSaved: (val) => titre = val!,
              ),
              
              // Menu déroulant pour le choix de la catégorie
              DropdownButtonFormField<String>(
                value: categorie,
                decoration: const InputDecoration(labelText: 'Catégorie'),
                items: _categories.map((String cat) {
                  return DropdownMenuItem<String>(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (valeur) {
                  if (valeur != null) {
                    setState(() {
                      categorie = valeur;
                    });
                  }
                },
                onSaved: (valeur) {
                  if (valeur != null) {
                    categorie = valeur;
                  }
                },
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Prix (FCFA)'),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.isEmpty ? 'Veuillez entrer un prix' : null,
                onSaved: (val) => prix = double.parse(val!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Localisation'),
                validator: (val) => val == null || val.isEmpty ? 'Veuillez entrer une localisation' : null,
                onSaved: (val) => localisation = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description détaillée'),
                maxLines: 3,
                validator: (val) => val == null || val.isEmpty ? 'Veuillez entrer une description' : null,
                onSaved: (val) => description = val!,
              ),
              const SizedBox(height: 20),
              _estEnCours
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _publierAnnonce,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('Publier l\'annonce', style: TextStyle(fontSize: 16)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}