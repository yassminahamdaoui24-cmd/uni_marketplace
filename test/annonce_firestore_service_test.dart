import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uni_marketplace/data/datasources/annonce_firestore_service.dart';
import 'package:uni_marketplace/data/models/annonce_model.dart';

AnnonceModel fictive(
  String titre,
  double prix,
  String vendeur,
  DateTime date, {
  String statut = AnnonceModel.statutDisponible,
}) {
  return AnnonceModel.fromMap({
    'titre': titre,
    'description': 'Description de $titre',
    'prix': prix,
    'categorie': 'Livres',
    'imageUrl': '',
    'vendeurId': vendeur,
    'datePublication': date.toIso8601String(),
    'statut': statut,
  });
}

void main() {
  late FakeFirebaseFirestore fakeDb;
  late AnnonceFirestoreService service;

  setUp(() {
    fakeDb = FakeFirebaseFirestore();
    service = AnnonceFirestoreService(firestore: fakeDb);
  });

  test('liste vide quand il n\'y a aucune annonce', () async {
    expect(await service.recupererTout(), isEmpty);
  });

  test('cycle complet : créer, lister, lire, modifier, supprimer', () async {
    final id1 = await service.ajouter(
      fictive('Livre Algo', 50, 'vendeur1', DateTime(2026, 11, 1)),
    );
    await service.ajouter(
      fictive('Calculatrice', 120, 'vendeur2', DateTime(2026, 11, 2)),
    );
    await service.ajouter(
      fictive('Cours C++', 30, 'vendeur1', DateTime(2026, 11, 3)),
    );

    final liste = await service.recupererTout();
    expect(liste.length, 3);
    expect(liste.first.titre, 'Cours C++');

    final une = await service.recupererParId(id1);
    expect(une.titre, 'Livre Algo');
    expect(une.vendeurId, 'vendeur1');
    expect(une.prix, 50);
    expect(une.statut, AnnonceModel.statutDisponible);

    await service.modifier(id1, {'prix': 40.0, 'vendeurId': 'pirate'});
    final modifiee = await service.recupererParId(id1);
    expect(modifiee.prix, 40);
    expect(modifiee.vendeurId, 'vendeur1');

    await service.supprimer(id1);
    expect((await service.recupererTout()).length, 2);
    expect(service.recupererParId(id1), throwsA(isA<AnnonceException>()));
  });

  test('statut : marquer vendue et filtrer les disponibles', () async {
    final id1 = await service.ajouter(
      fictive('Livre Algo', 50, 'vendeur1', DateTime(2026, 11, 1)),
    );
    await service.ajouter(
      fictive('Calculatrice', 120, 'vendeur2', DateTime(2026, 11, 2)),
    );

    await service.marquerVendue(id1);

    expect(
      (await service.recupererParId(id1)).statut,
      AnnonceModel.statutVendue,
    );
    expect((await service.recupererTout()).length, 2);

    final dispo = await service.recupererTout(seulementDisponibles: true);
    expect(dispo.length, 1);
    expect(dispo.first.titre, 'Calculatrice');
  });

  test('statut invalide refusé', () async {
    expect(
      service.ajouter(
        fictive('X', 10, 'v1', DateTime(2026, 11, 1), statut: 'perdue'),
      ),
      throwsA(isA<AnnonceException>()),
    );

    final id = await service.ajouter(
      fictive('Y', 10, 'v1', DateTime(2026, 11, 1)),
    );
    expect(
      service.modifier(id, {'statut': 'perdue'}),
      throwsA(isA<AnnonceException>()),
    );
  });

  test('annonce introuvable', () async {
    expect(
      service.recupererParId('inexistant'),
      throwsA(isA<AnnonceException>()),
    );
    expect(
      service.modifier('inexistant', {'prix': 1.0}),
      throwsA(isA<AnnonceException>()),
    );
    expect(service.supprimer('inexistant'), throwsA(isA<AnnonceException>()));
  });

  test('un vendeur est obligatoire', () async {
    expect(
      service.ajouter(fictive('Sans vendeur', 10, '', DateTime(2026, 11, 1))),
      throwsA(isA<AnnonceException>()),
    );
  });
}
