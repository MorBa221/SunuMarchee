import 'package:flutter/material.dart';
import '../modeles/utilisateur.dart';
import '../services/service_firebase.dart';

class EcranAuth extends StatefulWidget {
  const EcranAuth({super.key});

  @override
  State<EcranAuth> createState() => _EcranAuthState();
}

class _EcranAuthState extends State<EcranAuth> {
  final _formKey = GlobalKey<FormState>();
  
  String _nom = '';
  String _email = '';
  String _motDePasse = '';
  String _telephone = '';
  
  bool _estEnCours = false;
  bool _modeConnexion = false; 

 
  Future<void> _soumettre() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() { _estEnCours = true; });

      String? messageErreur;

      if (_modeConnexion) {
        
        messageErreur = await ServiceFirebase().connecterUtilisateur(
          email: _email,
          motDePasse: _motDePasse,
        );
      } else {
        
        messageErreur = await ServiceFirebase().inscrireUtilisateur(
          email: _email,
          motDePasse: _motDePasse,
          nomComplet: _nom,
          telephone: _telephone,
        );
      }

      setState(() { _estEnCours = false; });

      if (messageErreur == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_modeConnexion ? 'Connexion réussie !' : 'Compte créé avec succès !'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur : $messageErreur'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
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
        title: Text(utilisateurConnecte != null 
            ? 'Mon Profil' 
            : (_modeConnexion ? 'Connexion' : 'Créer un Compte')),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: utilisateurConnecte != null
            
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 40, 
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    utilisateurConnecte!.nomComplet, 
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(utilisateurConnecte!.email, style: const TextStyle(color: Colors.grey, fontSize: 16)),
                  Text(utilisateurConnecte!.numeroTelephone, style: const TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _deconnecter,
                      icon: const Icon(Icons.logout),
                      label: const Text('Se déconnecter'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, 
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              )
            
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      _modeConnexion ? 'Bienvenue !' : 'Créer votre compte',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    
                    if (!_modeConnexion) ...[
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Nom complet',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Champ requis' : null,
                        onSaved: (v) => _nom = v!,
                      ),
                      const SizedBox(height: 12),
                    ],

                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => v == null || !v.contains('@') ? 'Email invalide' : null,
                      onSaved: (v) => _email = v!,
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Mot de passe',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (v) => v == null || v.length < 6 ? 'Au moins 6 caractères' : null,
                      onSaved: (v) => _motDePasse = v!,
                    ),
                    const SizedBox(height: 12),

                    if (!_modeConnexion) ...[
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Numéro de téléphone',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (v) => v == null || v.isEmpty ? 'Champ requis' : null,
                        onSaved: (v) => _telephone = v!,
                      ),
                      const SizedBox(height: 20),
                    ],

                    const SizedBox(height: 10),
                    _estEnCours
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _soumettre,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent, 
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              _modeConnexion ? 'Se connecter' : 'S\'inscrire',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                    
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _modeConnexion = !_modeConnexion;
                        });
                      },
                      child: Text(
                        _modeConnexion 
                            ? 'Pas encore de compte ? S\'inscrire' 
                            : 'Déjà un compte ? Se connecter',
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}