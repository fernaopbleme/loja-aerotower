import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import '../theme/at_theme.dart';

/// Player do YouTube embutido na página, em 16:9.
///
/// O Flutter web não tem widget de vídeo nativo para isso: o jeito
/// suportado é registrar um `<iframe>` como platform view e posicioná-lo
/// com `HtmlElementView`. É o mesmo player do YouTube, então o streaming,
/// a qualidade adaptativa e o tela-cheia vêm de graça — e o site continua
/// leve, sem carregar centenas de MB de vídeo.
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
  // Cada id de vídeo vira um tipo de view registrado uma vez só; registrar
  // de novo o mesmo tipo lança exceção.
  static final Set<String> _registrados = {};

  late final String _viewType = 'youtube-${widget.videoId}';

  @override
  void initState() {
    super.initState();
    if (_registrados.add(_viewType)) {
      ui_web.platformViewRegistry.registerViewFactory(_viewType, (int _) {
        final iframe = web.HTMLIFrameElement()
          ..src = 'https://www.youtube-nocookie.com/embed/${widget.videoId}'
          ..allow = 'accelerometer; clipboard-write; encrypted-media; '
              'gyroscope; picture-in-picture'
          ..allowFullscreen = true
          ..width = '100%'
          ..height = '100%';
        iframe.style
          ..border = 'none'
          ..width = '100%'
          ..height = '100%';
        return iframe;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AtRadius.lg),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: AtColors.neutral900,
          child: HtmlElementView(viewType: _viewType),
        ),
      ),
    );
  }
}
