import 'package:flutter/material.dart';
import '../modeles/annonce.dart';
import '../modeles/utilisateur.dart';
import '../services/service_firebase.dart';
import 'ecran_detail.dart';

class EcranTableauDeBord extends StatelessWidget {
  const EcranTableauDeBord({super.key});

  void _confirmerSuppression(BuildContext context, Annonce annonce) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: Text('Voulez-vous vraiment supprimer l\'annonce "${annonce.titre}" ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                bool succes = await ServiceFirebase().supprimerAnnonce(annonce.id);
                if (succes && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Annonce supprimée avec succès !'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              child: const Text(
                'Supprimer',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (utilisateurConnecte == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mes Annonces')),
        body: const Center(
          child: Text('Veuillez vous connecter pour voir vos annonces.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Annonces'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Annonce>>(
        stream: ServiceFirebase().obtenirAnnonces(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Vous n\'avez publié aucune annonce.'));
          }

          
          final mesAnnonces = snapshot.data!
              .where((annonce) => annonce.idVendeur == utilisateurConnecte!.id)
              .toList();

          if (mesAnnonces.isEmpty) {
            return const Center(child: Text('Vous n\'avez encore publié aucune annonce.'));
          }

          return ListView.builder(
            itemCount: mesAnnonces.length,
            itemBuilder: (context, index) {
              final annonce = mesAnnonces[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  title: Text(
                    annonce.titre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${annonce.prix.toStringAsFixed(0)} FCFA • ${annonce.localisation}'),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            annonce.estVendu ? 'Statut : VENDU' : 'Statut : DISPONIBLE',
                            style: TextStyle(
                              color: annonce.estVendu ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          
                          Switch(
                            value: annonce.estVendu,
                            activeColor: Colors.red,
                            inactiveThumbColor: Colors.green,
                            onChanged: (bool nouvelleValeur) async {
                              await ServiceFirebase().changerStatutAnnonce(
                                annonce.id,
                                nouvelleValeur,
                              );
                            },
                          ),
                          // Bouton de suppression
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _confirmerSuppression(context, annonce),
                            tooltip: 'Supprimer l\'annonce',
                          ),
                        ],
                      )
                    ],
                  ),
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
    );
  }
}