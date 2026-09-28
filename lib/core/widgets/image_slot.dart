import 'package:flutter/material.dart';

import '../theme/at_theme.dart';
import 'at_icon.dart';

/// Substituto do `<image-slot>` do protótipo: um lugar reservado para
/// a foto, com a legenda descrevendo a imagem necessária.
///
/// Troque por `Image.network` mantendo caixa, raio e o tratamento
/// `.washed` quando as fotos existirem.
class ImageSlot extends StatelessWidget {
  final String descricao;
  final double? height;
  final double radius;
  final double? width;

  const ImageSlot({
    super.key,
    required this.descricao,
    this.height,
    this.width,
    this.radius = AtRadius.lg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AtColors.neutral200,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AtColors.divider),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const AtIcon(AtIcons.image, size: 26, color: AtColors.neutral500),
          const SizedBox(height: 8),
          Text(
            descricao,
            textAlign: TextAlign.center,
            style: AtText.body(12, color: AtColors.neutral600, height: 1.4),
          ),
        ],
      ),
    );
  }
}
