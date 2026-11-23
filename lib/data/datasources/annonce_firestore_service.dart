import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/annonce_model.dart';

class AnnonceException implements Exception {
  final String message;
  AnnonceException(this.message);

  @override
  String toString() => message;
}

class AnnonceFirestoreService {
  final FirebaseFirestore? _db;

  AnnonceFirestoreService({FirebaseFirestore? firestore}) : _db = firestore;

  CollectionReference<Map<String, dynamic>> get _annonces =>
      (_db ?? FirebaseFirestore.instance).collection('annonces');

  static const _statutsValides = [
    AnnonceModel.statutDisponible,
    AnnonceModel.statutVendue,
  ];

  /// Ajoute une annonce et retourne son identifiant.
  Future<String> ajouter(AnnonceModel annonce) async {
    if (annonce.vendeurId.isEmpty) {
      throw AnnonceException("Le vendeur est obligatoire.");
    }
    if (!_statutsValides.contains(annonce.statut)) {
      throw AnnonceException("Statut invalide : ${annonce.statut}.");
    }
    try {
      final ref = _annonces.doc();
      await ref.set({...annonce.toMap(), 'id': ref.id});
      return ref.id;
    } on FirebaseException catch (e) {
      throw AnnonceException("Erreur d'écriture : ${e.message}");
    }
  }

  /// Retourne les annonces, la plus récente d'abord (liste vide s'il n'y en a aucune).
  /// Avec [seulementDisponibles], les annonces vendues sont exclues.
  Future<List<AnnonceModel>> recupererTout({
    bool seulementDisponibles = false,
  }) async {
    try {
      final snap = await _annonces
          .orderBy('datePublication', descending: true)
          .get();
      final liste = snap.docs
          .map((d) => AnnonceModel.fromMap({...d.data(), 'id': d.id}))
          .toList();
      if (seulementDisponibles) {
        return liste
            .where((a) => a.statut == AnnonceModel.statutDisponible)
            .toList();
      }
      return liste;
    } on FirebaseException catch (e) {
      throw AnnonceException("Erreur de lecture : ${e.message}");
    }
  }

  /// Retourne une annonce par son identifiant.
  Future<AnnonceModel> recupererParId(String id) async {
    try {
      final doc = await _annonces.doc(id).get();
      final data = doc.data();
      if (!doc.exists || data == null) {
        throw AnnonceException("Annonce introuvable.");
      }
      return AnnonceModel.fromMap({...data, 'id': doc.id});
    } on FirebaseException catch (e) {
      throw AnnonceException("Erreur de lecture : ${e.message}");
    }
  }

  /// Modifie les champs donnés (l'id et le vendeur ne sont jamais modifiés).
  Future<void> modifier(String id, Map<String, dynamic> champs) async {
    final modifs = Map<String, dynamic>.from(champs)
      ..remove('id')
      ..remove('vendeurId');
    if (modifs.isEmpty) {
      throw AnnonceException("Aucun champ à modifier.");
    }
    if (modifs.containsKey('statut') &&
        !_statutsValides.contains(modifs['statut'])) {
      throw AnnonceException("Statut invalide : ${modifs['statut']}.");
    }
    try {
      await _annonces.doc(id).update(modifs);
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        throw AnnonceException("Annonce introuvable.");
      }
      throw AnnonceException("Erreur d'écriture : ${e.message}");
    }
  }

  /// Marque une annonce comme vendue.
  Future<void> marquerVendue(String id) =>
      modifier(id, {'statut': AnnonceModel.statutVendue});

  /// Supprime une annonce.
  Future<void> supprimer(String id) async {
    try {
      final ref = _annonces.doc(id);
      final doc = await ref.get();
      if (!doc.exists) {
        throw AnnonceException("Annonce introuvable.");
      }
      await ref.delete();
    } on FirebaseException catch (e) {
      throw AnnonceException("Erreur d'écriture : ${e.message}");
    }
  }
}
//CRUD
