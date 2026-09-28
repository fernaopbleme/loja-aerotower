import 'package:flutter/material.dart';

import '../theme/at_theme.dart';

/// `.radio` + `.dot`: círculo de 16px, borda 1.5px no divider.
/// Marcado = borda e fundo accent com anel interno de 4px na cor do fundo.
class AtRadio extends StatefulWidget {
  final String label;
  final bool selecionado;
  final VoidCallback onTap;

  const AtRadio({
    super.key,
    required this.label,
    required this.selecionado,
    required this.onTap,
  });

  @override
  State<AtRadio> createState() => _AtRadioState();
}

class _AtRadioState extends State<AtRadio> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final corBorda = widget.selecionado || _hover
        ? AtColors.accent
        : AtColors.divider;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // O CSS pinta o fundo accent e por cima um anel interno de 4px
            // na cor do fundo — sobra um ponto accent no centro.
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.selecionado ? AtColors.bg : null,
                border: Border.all(color: corBorda, width: 1.5),
              ),
              child: widget.selecionado
                  ? Center(
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AtColors.accent,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(widget.label, style: AtText.body(14)),
          ],
        ),
      ),
    );
  }
}
