class AnnonceModel {
  final String id;
  final String titre;
  final String description;
  final double prix;
  final String categorie;
  final String imageUrl;
  final String vendeurId;
  final DateTime datePublication;

  AnnonceModel({
    required this.id,
    required this.titre,
    required this.description,
    required this.prix,
    required this.categorie,
    required this.imageUrl,
    required this.vendeurId,
    required this.datePublication,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'prix': prix,
      'categorie': categorie,
      'imageUrl': imageUrl,
      'vendeurId': vendeurId,
      'datePublication': datePublication.toIso8601String(),
    };
  }

  factory AnnonceModel.fromMap(Map<String, dynamic> map) {
    return AnnonceModel(
      id: map['id'] ?? '',
      titre: map['titre'] ?? '',
      description: map['description'] ?? '',
      prix: (map['prix'] ?? 0).toDouble(),
      categorie: map['categorie'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      vendeurId: map['vendeurId'] ?? '',
      datePublication:
          DateTime.tryParse(map['datePublication'] ?? '') ?? DateTime.now(),
    );
  }
}
