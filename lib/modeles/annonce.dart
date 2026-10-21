class Annonce {
  final String id;
  final String titre;
  final double prix;
  final String description;
  final String categorie;
  final String localisation;
  final List<String> images;
  final String numeroTelephone;
  final String idVendeur;
  bool estVendu;

  Annonce({
    required this.id,
    required this.titre,
    required this.prix,
    required this.description,
    required this.categorie,
    required this.localisation,
    required this.images,
    required this.numeroTelephone,
    required this.idVendeur,
    this.estVendu = false,
  });
}