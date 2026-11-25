import 'package:flutter/material.dart';
import '../models/annonce_model.dart';
import '../services/mock_annonces.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PublicationScreen extends StatefulWidget {
  const PublicationScreen({super.key});

  @override
  State<PublicationScreen> createState() => _PublicationScreenState();
}

class _PublicationScreenState extends State<PublicationScreen> {

  final ImagePicker picker = ImagePicker();
File? imageSelectionnee;

  static const Color brun = Color(0xFF3E2922);
  static const Color terracotta = Color(0xFF824C35);
  static const Color caramel = Color(0xFFC98249);
  static const Color creme = Color(0xFFEFE2CB);
  static const Color beige = Color(0xFFF5EBDD);

  final _formKey = GlobalKey<FormState>();

  final titreController = TextEditingController();
  final descriptionController = TextEditingController();
  final prixController = TextEditingController();

  String? categorieSelectionnee;

  Future<void> choisirImage() async {
  final XFile? image = await picker.pickImage(
    source: ImageSource.gallery,
  );

  if (image != null) {
    setState(() {
      imageSelectionnee = File(image.path);
    });
  }
}

  final List<String> categories = [
    'Matériel informatique',
    'Livres et documents',
    'Polycopiés',
    'Fournitures',
  ];

  @override
  void dispose() {
    titreController.dispose();
    descriptionController.dispose();
    prixController.dispose();
    super.dispose();
  }

  void publierAnnonce() {
    if (!_formKey.currentState!.validate()) return;

    final nouvelleAnnonce = AnnonceModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titre: titreController.text.trim(),
      description: descriptionController.text.trim(),
      prix: double.parse(prixController.text.trim()),
      categorie: categorieSelectionnee!,
      imageUrl: imageSelectionnee?.path ?? '',
      vendeurId: 'user1',
      datePublication: DateTime.now(),
      statut: 'Disponible',
    );

    mockAnnonces.add(nouvelleAnnonce);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Annonce publiée avec succès !'),
      ),
    );

    titreController.clear();
    descriptionController.clear();
    prixController.clear();

    setState(() {
  categorieSelectionnee = null;
  imageSelectionnee = null;
});
  }

  InputDecoration decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: terracotta),
      filled: true,
      fillColor: creme,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: terracotta, width: 1.5),
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
          'PUBLIER UNE ANNONCE',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ajouter un produit',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: brun,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Remplissez les informations de votre annonce.',
                style: TextStyle(color: brun),
              ),
              const SizedBox(height: 22),

              GestureDetector(
  onTap: choisirImage,
  child: Container(
    width: double.infinity,
    height: 180,
    decoration: BoxDecoration(
      color: creme,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: caramel),
    ),
    child: imageSelectionnee != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.file(
              imageSelectionnee!,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          )
        : const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_a_photo_outlined,
                size: 38,
                color: terracotta,
              ),
              SizedBox(height: 8),
              Text(
                'Ajouter une photo',
                style: TextStyle(color: brun),
              ),
              SizedBox(height: 4),
              Text(
                'Choisir depuis la galerie',
                style: TextStyle(color: terracotta, fontSize: 12),
              ),
            ],
          ),
  ),
),
              const SizedBox(height: 20),

              TextFormField(
                controller: titreController,
                decoration: decoration(
                  'Nom du produit',
                  Icons.shopping_bag_outlined,
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Entrez le nom du produit'
                        : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                decoration: decoration(
                  'Description',
                  Icons.description_outlined,
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Entrez une description'
                        : null,
              ),
              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: categorieSelectionnee,
                decoration: decoration(
                  'Catégorie',
                  Icons.category_outlined,
                ),
                items: categories.map((categorie) {
                  return DropdownMenuItem(
                    value: categorie,
                    child: Text(categorie),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    categorieSelectionnee = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Choisissez une catégorie' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: prixController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: decoration(
                  'Prix en DH',
                  Icons.payments_outlined,
                ),
                validator: (value) {
                  final prix = double.tryParse(value ?? '');
                  if (prix == null || prix <= 0) {
                    return 'Entrez un prix valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: creme,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 10),
                    Text(
                      'Statut : Disponible',
                      style: TextStyle(
                        color: brun,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: publierAnnonce,
                  icon: const Icon(Icons.add),
                  label: const Text(
                    "Publier l'annonce",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: terracotta,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        backgroundColor: creme,
        selectedItemColor: terracotta,
        unselectedItemColor: brun,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/catalogue');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/favoris');
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