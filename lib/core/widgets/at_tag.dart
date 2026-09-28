import 'package:flutter/material.dart';

import '../theme/at_theme.dart';

enum AtTagVariant { accent, accent2, neutral, outline }

/// `.tag` + variantes. 11px, padding 3x10, raio pílula.
class AtTag extends StatelessWidget {
  final String label;
  final AtTagVariant variant;

  const AtTag(this.label, {super.key, this.variant = AtTagVariant.accent});

  @override
  Widget build(BuildContext context) {
    final (fundo, cor) = switch (variant) {
      AtTagVariant.accent => (AtColors.accent100, AtColors.accent800),
      AtTagVariant.accent2 => (AtColors.accent2_100, AtColors.accent2_800),
      AtTagVariant.neutral => (AtColors.neutral100, AtColors.neutral800),
      AtTagVariant.outline => (Colors.transparent, AtColors.accent),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(AtRadius.pill),
        border: variant == AtTagVariant.outline
            ? Border.all(color: AtColors.accent)
            : null,
      ),
      child: Text(
        label,
        style: AtText.body(11, color: cor, letterSpacing: 11 * 0.02, height: 1.4),
      ),
    );
  }
}
