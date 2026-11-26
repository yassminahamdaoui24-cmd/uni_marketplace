import 'package:flutter/material.dart';

import '../../data/models/annonce_model.dart';
import '../../services/mock_annonces.dart';

import 'dart:io';

class MesAnnoncesScreen extends StatefulWidget {
  const MesAnnoncesScreen({super.key});

  @override
  State<MesAnnoncesScreen> createState() => _MesAnnoncesScreenState();
}

class _MesAnnoncesScreenState extends State<MesAnnoncesScreen> {
  static const Color brun = Color(0xFF3E2922);
  static const Color terracotta = Color(0xFF824C35);
  static const Color caramel = Color(0xFFC98249);
  static const Color creme = Color(0xFFEFE2CB);
  static const Color beige = Color(0xFFF5EBDD);

  // Modifier une annonce
  void modifierAnnonce(AnnonceModel annonce) {
    final titreController = TextEditingController(text: annonce.titre);
    final prixController = TextEditingController(text: annonce.prix.toString());

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: beige,
          title: const Text(
            'Modifier l’annonce',
            style: TextStyle(color: brun, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titreController,
                decoration: const InputDecoration(labelText: 'Nom du produit'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: prixController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Prix en DH'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: terracotta,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final nouveauTitre = titreController.text.trim();
                final nouveauPrix = double.tryParse(prixController.text);

                if (nouveauTitre.isEmpty ||
                    nouveauPrix == null ||
                    nouveauPrix <= 0) {
                  return;
                }

                final index = mockAnnonces.indexWhere(
                  (item) => item.id == annonce.id,
                );

                if (index != -1) {
                  mockAnnonces[index] = AnnonceModel(
                    id: annonce.id,
                    titre: nouveauTitre,
                    description: annonce.description,
                    prix: nouveauPrix,
                    categorie: annonce.categorie,
                    imageUrl: annonce.imageUrl,
                    vendeurId: annonce.vendeurId,
                    datePublication: annonce.datePublication,
                    statut: annonce.statut,
                  );
                }

                Navigator.pop(dialogContext);
                setState(() {});

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Annonce modifiée avec succès !'),
                  ),
                );
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    ).then((_) {
      titreController.dispose();
      prixController.dispose();
    });
  }

  // Supprimer une annonce
  void supprimerAnnonce(AnnonceModel annonce) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: beige,
          title: const Text('Supprimer l’annonce ?'),
          content: const Text('Voulez-vous vraiment supprimer cette annonce ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Annuler'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                mockAnnonces.removeWhere((item) => item.id == annonce.id);

                Navigator.pop(dialogContext);
                setState(() {});

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Annonce supprimée !')),
                );
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('Supprimer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget carteAnnonce(AnnonceModel annonce) {
    final disponible = annonce.statut == 'Disponible';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: creme,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: brun.withOpacity(0.08),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 105,
                  height: 110,
                  color: beige,
                  child: annonce.imageUrl.isEmpty
                      ? const Icon(
                          Icons.image_outlined,
                          size: 40,
                          color: terracotta,
                        )
                      : annonce.imageUrl.startsWith('http')
                      ? Image.network(
                          annonce.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_outlined,
                            size: 40,
                            color: terracotta,
                          ),
                        )
                      : Image.file(
                          File(annonce.imageUrl),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_outlined,
                            size: 40,
                            color: terracotta,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      annonce.titre,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: brun,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '${annonce.prix.toStringAsFixed(0)} DH',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: terracotta,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: disponible
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        annonce.statut,
                        style: TextStyle(
                          color: disponible
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => modifierAnnonce(annonce),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Modifier'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: terracotta,
                    side: const BorderSide(color: terracotta),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => supprimerAnnonce(annonce),
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Supprimer'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade700,
                    side: BorderSide(color: Colors.red.shade700),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: beige,
      appBar: AppBar(
        backgroundColor: brun,
        foregroundColor: Colors.white,
        title: const Text(
          'MES ANNONCES',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Row(
              children: [
                const Icon(
                  Icons.shopping_bag_outlined,
                  color: terracotta,
                  size: 26,
                ),
                const SizedBox(width: 9),
                const Expanded(
                  child: Text(
                    'Liste des produits',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: brun,
                    ),
                  ),
                ),
                Text(
                  '${mockAnnonces.length} annonces',
                  style: const TextStyle(
                    color: terracotta,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: mockAnnonces.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 65,
                          color: caramel,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Aucune annonce pour le moment',
                          style: TextStyle(color: brun, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: mockAnnonces.length,
                    itemBuilder: (context, index) {
                      return carteAnnonce(mockAnnonces[index]);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/publication').then((_) {
                    setState(() {});
                  });
                },
                icon: const Icon(Icons.add_circle_outline),
                label: const Text(
                  'Ajouter une annonce',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: terracotta,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        backgroundColor: creme,
        selectedItemColor: terracotta,
        unselectedItemColor: brun,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/catalogue');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/publication');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/favoris');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/profil');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Ajouter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
