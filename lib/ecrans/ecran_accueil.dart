import 'dart:io';
import 'package:flutter/material.dart';
import '../modeles/annonce.dart';
import '../services/service_firebase.dart';
import 'ecran_detail.dart';

class EcranAccueil extends StatefulWidget {
  const EcranAccueil({super.key});

  @override
  State<EcranAccueil> createState() => _EcranAccueilState();
}

class _EcranAccueilState extends State<EcranAccueil> {
  String recherche = '';

  Widget _construireImageMiniature(String cheminImage) {
    if (cheminImage.startsWith('http')) {
      return Image.network(cheminImage, width: 60, height: 60, fit: BoxFit.cover);
    } else {
      return Image.file(File(cheminImage), width: 60, height: 60, fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SunuMarché'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Rechercher un article...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (valeur) {
                setState(() {
                  recherche = valeur;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Annonce>>(
              stream: ServiceFirebase().obtenirAnnonces(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Aucune annonce disponible.'));
                }

                
                final annoncesFiltrees = snapshot.data!.where((annonce) {
                  return annonce.titre.toLowerCase().contains(recherche.toLowerCase()) && !annonce.estVendu;
                }).toList();

                if (annoncesFiltrees.isEmpty) {
                  return const Center(child: Text('Aucun article correspondant.'));
                }

                return ListView.builder(
                  itemCount: annoncesFiltrees.length,
                  itemBuilder: (context, index) {
                    final annonce = annoncesFiltrees[index];
                    final premiereImage = annonce.images.isNotEmpty
                        ? annonce.images.first
                        : 'https://via.placeholder.com/150';

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: _construireImageMiniature(premiereImage),
                        ),
                        title: Text(annonce.titre, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${annonce.prix.toStringAsFixed(0)} FCFA • ${annonce.localisation}'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EcranDetail(annonce: annonce),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}