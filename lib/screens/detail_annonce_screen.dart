import 'package:flutter/material.dart';
import '../models/annonce_model.dart';

class DetailAnnonceScreen extends StatefulWidget {
  final AnnonceModel? annonce;

  const DetailAnnonceScreen({
    super.key,
    this.annonce,
  });

  @override
  State<DetailAnnonceScreen> createState() =>
      _DetailAnnonceScreenState();
}

class _DetailAnnonceScreenState extends State<DetailAnnonceScreen> {
  static const Color brun = Color(0xFF3E2922);
  static const Color terracotta = Color(0xFF824C35);
  static const Color caramel = Color(0xFFC98249);
  static const Color creme = Color(0xFFEFE2CB);
  static const Color beige = Color(0xFFF5EBDD);

  bool estFavori = false;

  @override
  Widget build(BuildContext context) {
    final produit = widget.annonce;

    if (produit == null) {
      return Scaffold(
        backgroundColor: beige,
        body: const Center(
          child: Text('Aucun produit sélectionné'),
        ),
      );
    }

    final bool disponible = produit.statut == 'Disponible';

    return Scaffold(
      backgroundColor: beige,

      // HEADER
      appBar: AppBar(
        backgroundColor: beige,
        foregroundColor: brun,
        elevation: 0,
        title: const Text(
          'Détail du produit',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Partage prochainement disponible'),
                ),
              );
            },
            icon: const Icon(Icons.share_outlined),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                estFavori = !estFavori;
              });
            },
            icon: Icon(
              estFavori ? Icons.favorite : Icons.favorite_border,
              color: terracotta,
            ),
          ),
        ],
      ),

      // CONTENU
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // IMAGE DU PRODUIT
            Stack(
              children: [
                Container(
                  height: 240,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: creme,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: produit.imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.network(
                            produit.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(
                              Icons.image_outlined,
                              size: 75,
                              color: terracotta,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.image_outlined,
                          size: 75,
                          color: terracotta,
                        ),
                ),

                // STATUT
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: disponible
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      disponible ? 'Disponible' : 'Vendu',
                      style: TextStyle(
                        color: disponible
                            ? Colors.green.shade800
                            : Colors.red.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // POINTS DECORATIFS
            const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 9, color: terracotta),
                  SizedBox(width: 7),
                  Icon(Icons.circle, size: 9, color: creme),
                  SizedBox(width: 7),
                  Icon(Icons.circle, size: 9, color: creme),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // NOM DU PRODUIT
            Text(
              produit.titre,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: brun,
              ),
            ),

            const SizedBox(height: 12),

            // PRIX
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: creme,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                '${produit.prix.toStringAsFixed(0)} DH',
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: terracotta,
                ),
              ),
            ),

            const SizedBox(height: 22),

            // CATEGORIE
            _infoCard(
              icon: Icons.laptop_outlined,
              title: 'Catégorie',
              description: produit.categorie,
            ),

            const SizedBox(height: 12),

            // DESCRIPTION
            _infoCard(
              icon: Icons.subject,
              title: 'Description du produit',
              description: produit.description,
            ),

            const SizedBox(height: 12),

            // VENDEUR
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: creme,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: terracotta,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Vendeur : ${produit.vendeurId}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: brun,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: brun,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // CONTACTER LE VENDEUR
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: disponible
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Contact vendeur prochainement disponible',
                            ),
                          ),
                        );
                      }
                    : null,
                icon: const Icon(Icons.chat_bubble_outline),
                label: Text(
                  disponible
                      ? 'Contacter le vendeur'
                      : 'Produit vendu',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: terracotta,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade400,
                  disabledForegroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: creme,
        selectedItemColor: terracotta,
        unselectedItemColor: brun,
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/catalogue');
          } else if (index == 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Recherche prochainement disponible'),
              ),
            );
          } else if (index == 2) {
            Navigator.pushNamed(context, '/publication');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/profil');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Recherche',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Publier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // WIDGET DES INFORMATIONS
  Widget _infoCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: creme,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 30,
            color: terracotta,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: brun,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: brun,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}