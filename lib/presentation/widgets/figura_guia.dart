import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../content/guias.dart';
import '../../core/theme/at_theme.dart';
import '../../core/widgets/at_foto.dart';

/// Ilustração do guia de montagem, com legenda.
///
/// Diagrama e foto recebem tratamento diferente de propósito. A foto passa
/// pelo `.washed` do design, como todas as outras do site. O diagrama não:
/// ele foi desenhado nas cores da paleta, e dessaturar apagaria justamente
/// a distinção entre a água e a planta, que é o que o desenho explica.
class FiguraGuia extends StatelessWidget {
  final Figura figura;

  /// Largura máxima. A coluna de texto tem 620; um diagrama em retrato
  /// pede menos, senão ele domina a página inteira.
  final double maxWidth;

  const FiguraGuia(this.figura, {super.key, this.maxWidth = 620});

  @override
  Widget build(BuildContext context) {
    final retrato = figura.aspecto < 1;
    final largura = retrato ? maxWidth * 0.62 : maxWidth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: largura),
          child: figura.vetor ? _Vetor(figura) : _Foto(figura),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: largura),
          child: Text(
            figura.alt,
            style: AtText.body(12, color: AtColors.neutral700, height: 1.5),
          ),
        ),
      ],
    );
  }
}

class _Vetor extends StatelessWidget {
  final Figura figura;

  const _Vetor(this.figura);

  @override
  Widget build(BuildContext context) {
    // O fundo do SVG é a própria cor da página, então sem a borda o desenho
    // flutuaria sem limite definido.
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AtRadius.lg),
        border: Border.all(color: AtColors.divider),
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: figura.aspecto,
        child: SvgPicture.asset(
          'assets/diy/${figura.arquivo}',
          fit: BoxFit.contain,
          // Lido por leitor de tela no lugar do desenho.
          semanticsLabel: figura.alt,
          placeholderBuilder: (context) =>
              const ColoredBox(color: AtColors.neutral200),
        ),
      ),
    );
  }
}

class _Foto extends StatelessWidget {
  final Figura figura;

  const _Foto(this.figura);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: figura.aspecto,
      child: AtFoto(
        figura.arquivo,
        pasta: 'diy',
        radius: AtRadius.lg,
        alignment: Alignment.center,
      ),
    );
  }
}
