import 'package:flutter/material.dart';

import '../theme/at_theme.dart';
import 'at_icon.dart';

/// Estado vazio do vídeo — o padrão que o handoff pede: nunca renderizar
/// um `<video>` sem `src`, e nomear o arquivo exato a salvar.
class VideoSlot extends StatelessWidget {
  final String titulo;
  final String caminhoArquivo;
  final double circleSize;
  final double iconSize;
  final Color circleColor;
  final Color iconColor;

  const VideoSlot({
    super.key,
    required this.titulo,
    required this.caminhoArquivo,
    this.circleSize = 66,
    this.iconSize = 30,
    this.circleColor = AtColors.accent200,
    this.iconColor = AtColors.accent700,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AtColors.surface,
          borderRadius: BorderRadius.circular(AtRadius.lg),
          boxShadow: AtShadows.md,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                color: circleColor,
                borderRadius: BorderRadius.circular(AtRadius.pill),
              ),
              child: Center(
                child: AtIcon(AtIcons.play, size: iconSize, color: iconColor),
              ),
            ),
            const SizedBox(height: 12),
            Text(titulo, style: AtText.h5, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Text.rich(
                TextSpan(
                  style: AtText.body(13, color: AtColors.neutral700, height: 1.5),
                  children: [
                    const TextSpan(text: 'Salve o arquivo como '),
                    TextSpan(
                      text: caminhoArquivo,
                      style: AtText.heading(13, color: AtColors.neutral700,
                          height: 1.5),
                    ),
                    const TextSpan(
                      text: ' na pasta do site — o player aparece aqui '
                          'automaticamente.',
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
