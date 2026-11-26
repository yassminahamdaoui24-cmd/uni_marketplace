import 'package:flutter/material.dart';

import '../widgets/annonce_card.dart';
import '../../services/mock_annonces.dart';
import 'detail_annonce_screen.dart';

class CatalogueScreen extends StatelessWidget {
  const CatalogueScreen({super.key});

  static const Color brun = Color(0xFF3E2922);
  static const Color terracotta = Color(0xFF824C35);
  static const Color caramel = Color(0xFFC98249);
  static const Color creme = Color(0xFFEFE2CB);
  static const Color beige = Color(0xFFF5EBDD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: beige,

      // HEADER
      appBar: AppBar(
        backgroundColor: terracotta,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'UniMarket',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
          IconButton(
            tooltip: 'Mes annonces',
            onPressed: () {
              Navigator.pushNamed(context, '/mes-annonces');
            },
            icon: const Icon(Icons.inventory_2_outlined),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profil');
            },
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),

      // CONTENU PRINCIPAL
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BARRE DE RECHERCHE
            TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un produit...',
                prefixIcon: const Icon(Icons.search, color: terracotta),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/recherche');
              },
            ),

            const SizedBox(height: 24),

            // CATEGORIES
            const Text(
              'Catégories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: brun,
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                _categoryItem(Icons.computer, 'Matériel\ninformatique'),
                _categoryItem(Icons.menu_book, 'Livres et\ndocuments'),
                _categoryItem(Icons.description_outlined, 'Polycopiés'),
                _categoryItem(Icons.edit, 'Fournitures'),
              ],
            ),

            const SizedBox(height: 26),

            // PRODUITS POPULAIRES
            const Text(
              'Produits populaires',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: brun,
              ),
            ),

            const SizedBox(height: 14),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mockAnnonces.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, index) {
                return AnnonceCard(
                  annonce: mockAnnonces[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailAnnonceScreen(annonce: mockAnnonces[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),

      // BARRE DE NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: creme,
        selectedItemColor: terracotta,
        unselectedItemColor: brun,
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushNamed(context, '/publication');
              break;
            case 2:
              Navigator.pushNamed(context, '/favoris');
              break;
            case 3:
              Navigator.pushNamed(context, '/profil');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
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

  // WIDGET DES CATEGORIES
  static Widget _categoryItem(IconData icon, String title) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: creme,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: terracotta, size: 27),
          ),
          const SizedBox(height: 7),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: brun,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
