import 'package:flutter/material.dart';
import '../modeles/utilisateur.dart';

class EcranProfil extends StatefulWidget {
  const EcranProfil({super.key});

  @override
  State<EcranProfil> createState() => _EcranProfilState();
}

class _EcranProfilState extends State<EcranProfil> {
  final _cleFormulaire = GlobalKey<FormState>();
  String _nom = '';
  String _email = '';
  String _telephone = '';

  void _creerCompte() {
    if (_cleFormulaire.currentState!.validate()) {
      _cleFormulaire.currentState!.save();
      setState(() {
        utilisateurConnecte = Utilisateur(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          nomComplet: _nom,
          email: _email,
          numeroTelephone: _telephone,
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compte créé avec succès !')),
      );
    }
  }

  void _deconnecter() {
    setState(() {
      utilisateurConnecte = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: utilisateurConnecte != null
            ? ListView(
                children: [
                  const SizedBox(height: 20),
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      utilisateurConnecte!.nomComplet,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Text(
                      utilisateurConnecte!.estVerifie ? 'Vendeur Vérifié' : 'Compte Standard',
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: Text(utilisateurConnecte!.email),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Téléphone'),
                    subtitle: Text(utilisateurConnecte!.numeroTelephone),
                  ),
                  const ListTile(
                    leading: Icon(Icons.star, color: Colors.amber),
                    title: Text('Note vendeur'),
                    subtitle: Text('5.0 / 5.0'),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: _deconnecter,
                    icon: const Icon(Icons.logout),
                    label: const Text('Se déconnecter'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              )
            : Form(
                key: _cleFormulaire,
                child: ListView(
                  children: [
                    const Text(
                      'Créer votre Profil',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nom complet',
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Entrez votre nom' : null,
                      onSaved: (val) => _nom = val!,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) => val == null || val.isEmpty ? 'Entrez votre email' : null,
                      onSaved: (val) => _email = val!,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Numéro de téléphone',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (val) => val == null || val.isEmpty ? 'Entrez votre numéro' : null,
                      onSaved: (val) => _telephone = val!,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _creerCompte,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('S\'inscrire', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}