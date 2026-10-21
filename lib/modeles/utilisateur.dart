class Utilisateur {
  final String id;
  final String nomComplet;
  final String email;
  final String numeroTelephone;
  final bool estVerifie;

  Utilisateur({
    required this.id,
    required this.nomComplet,
    required this.email,
    required this.numeroTelephone,
    this.estVerifie = true,
  });
}


Utilisateur? utilisateurConnecte ;