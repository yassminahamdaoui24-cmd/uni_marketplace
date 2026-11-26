import 'package:flutter/material.dart';

import '../../data/models/annonce_model.dart';
import '../../services/mock_annonces.dart';
import '../widgets/annonce_card.dart';
import 'detail_annonce_screen.dart';

class RechercheScreen extends StatefulWidget {
  const RechercheScreen({super.key});

  @override
  State<RechercheScreen> createState() => _RechercheScreenState();
}

class _RechercheScreenState extends State<RechercheScreen> {
  bool isLoading = false;
  bool hasError = false;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();

  String selectedCategory = 'Toutes';
  String selectedSort = 'Aucun';

  final List<String> categories = [
    'Toutes',
    'Matériel informatique',
    'Livres et documents',
    'Polycopiés',
    'Fournitures',
  ];

  List<AnnonceModel> get filteredAnnonces {
    List<AnnonceModel> results = mockAnnonces.where((annonce) {
      final search = searchController.text.toLowerCase();

      final matchesName = annonce.titre.toLowerCase().contains(search);

      final matchesCategory =
          selectedCategory == 'Toutes' ||
          annonce.categorie.toLowerCase() == selectedCategory.toLowerCase();

      final minPrice = double.tryParse(minPriceController.text) ?? 0;

      final maxPrice =
          double.tryParse(maxPriceController.text) ?? double.infinity;

      final matchesPrice = annonce.prix >= minPrice && annonce.prix <= maxPrice;

      return matchesName && matchesCategory && matchesPrice;
    }).toList();

    if (selectedSort == 'Prix croissant') {
      results.sort((a, b) => a.prix.compareTo(b.prix));
    } else if (selectedSort == 'Prix décroissant') {
      results.sort((a, b) => b.prix.compareTo(a.prix));
    }

    return results;
  }

  @override
  void dispose() {
    searchController.dispose();
    minPriceController.dispose();
    maxPriceController.dispose();
    super.dispose();
  }

  static const Color brun = Color(0xFF3E2922);
  static const Color terracotta = Color(0xFF824C35);
  static const Color creme = Color(0xFFEFE2CB);
  static const Color beige = Color(0xFFF5EBDD);

  @override
  Widget build(BuildContext context) {
    final annonces = filteredAnnonces;

    return Scaffold(
      backgroundColor: beige,
      appBar: AppBar(
        title: const Text('Recherche'),
        backgroundColor: terracotta,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Rechercher un produit...',
                prefixIcon: const Icon(Icons.search, color: terracotta),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Catégorie',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: brun,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'Prix (DH)',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: brun,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minPriceController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Prix minimum',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: maxPriceController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Prix maximum',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              'Trier par',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: brun,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedSort,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'Aucun', child: Text('Aucun')),
                DropdownMenuItem(
                  value: 'Prix croissant',
                  child: Text('Prix croissant'),
                ),
                DropdownMenuItem(
                  value: 'Prix décroissant',
                  child: Text('Prix décroissant'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedSort = value!;
                });
              },
            ),

            const SizedBox(height: 24),

            Text(
              'Résultats (${annonces.length})',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: brun,
              ),
            ),

            const SizedBox(height: 12),

            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: CircularProgressIndicator(color: terracotta),
                ),
              )
            else if (hasError)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 55,
                        color: terracotta,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Une erreur est survenue.',
                        style: TextStyle(color: brun, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            hasError = false;
                          });
                        },
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                ),
              )
            else if (annonces.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Icon(Icons.search_off, size: 55, color: terracotta),
                      SizedBox(height: 10),
                      Text(
                        'Aucun résultat trouvé',
                        style: TextStyle(fontSize: 16, color: brun),
                      ),
                    ],
                  ),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: annonces.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final annonce = annonces[index];

                  return AnnonceCard(
                    annonce: annonce,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailAnnonceScreen(annonce: annonce),
                        ),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
