import 'dart:io';

import 'package:flutter/material.dart';

import '../../data/models/annonce_model.dart';

class AnnonceCard extends StatelessWidget {
  final AnnonceModel annonce;
  final VoidCallback? onTap;

  const AnnonceCard({super.key, required this.annonce, this.onTap});

  static const Color brun = Color(0xFF3E2922);
  static const Color terracotta = Color(0xFF824C35);
  static const Color creme = Color(0xFFEFE2CB);
  static const Color beige = Color(0xFFF5EBDD);

  @override
  Widget build(BuildContext context) {
    final bool disponible = annonce.statut == AnnonceModel.statutDisponible;

    return Card(
      color: creme,
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE DU PRODUIT
            Expanded(
              flex: 5,
              child: annonce.imageUrl.isNotEmpty
                  ? (annonce.imageUrl.startsWith('http')
                        ? Image.network(
                            annonce.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(Icons.image, size: 45),
                            ),
                          )
                        : Image.file(
                            File(annonce.imageUrl),
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(Icons.image, size: 45),
                            ),
                          ))
                  : Container(
                      width: double.infinity,
                      color: const Color(0xFFF5EBDD),
                      child: const Icon(
                        Icons.image_outlined,
                        size: 45,
                        color: Color(0xFF824C35),
                      ),
                    ),
            ),

            // INFORMATIONS DU PRODUIT
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITRE
                    Text(
                      annonce.titre,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: brun,
                      ),
                    ),

                    const SizedBox(height: 3),

                    // CATEGORIE
                    Text(
                      annonce.categorie,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10, color: terracotta),
                    ),

                    const Spacer(),

                    // PRIX
                    Text(
                      '${annonce.prix.toStringAsFixed(0)} DH',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: terracotta,
                      ),
                    ),

                    const SizedBox(height: 5),

                    // STATUT
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
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
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: disponible
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
