import 'package:flutter/material.dart';
import '../../models/annonce_model.dart';

class AnnonceCard extends StatelessWidget {
  final AnnonceModel annonce;
  final VoidCallback? onTap;

  const AnnonceCard({
    super.key,
    required this.annonce,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFEFE2CB),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: annonce.imageUrl.isNotEmpty
                  ? Image.network(
                      annonce.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.image, size: 45),
                      ),
                    )
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

            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      annonce.titre,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3E2922),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          '${annonce.prix.toStringAsFixed(0)} DH',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF824C35),
                          ),
                        ),
                      ],
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