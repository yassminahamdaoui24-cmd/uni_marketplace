import '../data/models/annonce_model.dart';

final List<AnnonceModel> mockAnnonces = [
  AnnonceModel(
    id: '1',
    titre: 'Ordinateur HP',
    description: 'Ordinateur HP en bon fonctionnement',
    prix: 2500.0,
    categorie: 'Matériel informatique',
    imageUrl: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853',
    vendeurId: 'user1',
    datePublication: DateTime.now(),
  ),

  AnnonceModel(
    id: '2',
    titre: 'Livre de programmation',
    description: 'Livre pour apprendre la programmation',
    prix: 80.0,
    categorie: 'Livres et documents',
    imageUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f',
    vendeurId: 'user2',
    datePublication: DateTime.now(),
  ),

  AnnonceModel(
    id: '3',
    titre: 'Polycopié de Java',
    description: 'Cours et exercices de Java',
    prix: 30.0,
    categorie: 'Polycopiés',
    imageUrl: 'https://images.unsplash.com/photo-1455390582262-044cdead277a',
    vendeurId: 'user3',
    datePublication: DateTime.now(),
  ),

  AnnonceModel(
    id: '4',
    titre: 'Calculatrice scientifique',
    description: 'Calculatrice pour les étudiants',
    prix: 120.0,
    categorie: 'Fournitures',
    imageUrl: 'https://images.unsplash.com/photo-1587145820266-a5951ee6f620',
    vendeurId: 'user4',
    datePublication: DateTime.now(),
  ),
];
