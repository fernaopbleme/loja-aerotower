import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/at_theme.dart';
import 'at_icon.dart';

/// Capa do vídeo do pitch: miniatura do YouTube com botão de play, que
/// abre o vídeo numa aba nova.
///
/// Por que não um player embutido: o Flutter web renderiza `<iframe>` como
/// elemento DOM de verdade, **acima** do canvas onde o resto da interface é
/// desenhado. Ele não respeita o recorte da área de rolagem, então ao
/// rolar a página o vídeo passava por cima do cabeçalho. Não é ajuste de
/// z-index — é a ordem entre DOM e canvas, que o Flutter não expõe.
///
/// A miniatura resolve de vez, e ainda deixa a página mais leve: ninguém
/// baixa o player do YouTube só por abrir a home.
class VideoYoutube extends StatefulWidget {
  /// Id do vídeo: o trecho depois de `v=` ou de `youtu.be/`.
  final String videoId;

  const VideoYoutube({super.key, required this.videoId});

  /// Aceita a URL inteira ou só o id, e devolve o id.
  static String extrairId(String entrada) {
    final texto = entrada.trim();
    if (texto.isEmpty) return '';

    final padroes = [
      RegExp(r'[?&]v=([A-Za-z0-9_-]{6,})'),      // youtube.com/watch?v=ID
      RegExp(r'youtu\.be/([A-Za-z0-9_-]{6,})'),  // youtu.be/ID
      RegExp(r'/embed/([A-Za-z0-9_-]{6,})'),     // youtube.com/embed/ID
      RegExp(r'/shorts/([A-Za-z0-9_-]{6,})'),    // youtube.com/shorts/ID
    ];
    for (final padrao in padroes) {
      final achou = padrao.firstMatch(texto);
      if (achou != null) return achou.group(1)!;
    }

    // Já veio só o id.
    if (RegExp(r'^[A-Za-z0-9_-]{6,}$').hasMatch(texto)) return texto;
    return '';
  }

  @override
  State<VideoYoutube> createState() => _VideoYoutubeState();
}

class _VideoYoutubeState extends State<VideoYoutube> {
  bool _hover = false;

  // maxres não existe para todo vídeo; hq existe sempre. Começa pela
  // melhor e cai para a garantida se ela falhar.
  late String _miniatura =
      'https://img.youtube.com/vi/${widget.videoId}/maxresdefault.jpg';
  bool _tentouReserva = false;

  Future<void> _abrir() async {
    await launchUrl(
      Uri.parse('https://www.youtube.com/watch?v=${widget.videoId}'),
      webOnlyWindowName: '_blank',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: _abrir,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AtRadius.lg),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(color: AtColors.neutral900),

                Image.network(
                  _miniatura,
                  fit: BoxFit.cover,
                  errorBuilder: (context, erro, pilha) {
                    if (!_tentouReserva) {
                      _tentouReserva = true;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _miniatura = 'https://img.youtube.com/vi/'
                                '${widget.videoId}/hqdefault.jpg';
                          });
                        }
                      });
                    }
                    return Container(color: AtColors.neutral900);
                  },
                ),

                // Escurece a foto para o botão de play ter contraste em
                // qualquer miniatura.
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: _hover ? 0.42 : 0.30),
                        Colors.black.withValues(alpha: _hover ? 0.52 : 0.40),
                      ],
                    ),
                  ),
                ),

                Center(
                  child: AnimatedScale(
                    scale: _hover ? 1.06 : 1.0,
                    duration: const Duration(milliseconds: 160),
                    child: Container(
                      width: 66,
                      height: 66,
                      decoration: BoxDecoration(
                        color: AtColors.accent,
                        shape: BoxShape.circle,
                        boxShadow: AtShadows.md,
                      ),
                      child: const Center(
                        child: Padding(
                          // O triângulo de play parece deslocado quando
                          // centralizado pela caixa: empurra um pouco.
                          padding: EdgeInsets.only(left: 4),
                          child: AtIcon(AtIcons.play,
                              size: 26, color: AtColors.bg),
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 14,
                  bottom: 12,
                  child: Text(
                    'Assistir no YouTube',
                    style: AtText.body(13,
                        color: Colors.white.withValues(alpha: 0.92)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
