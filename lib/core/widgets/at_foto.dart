import 'package:flutter/material.dart';

import '../theme/at_theme.dart';

/// Foto real do protótipo, com o mesmo enquadramento que o ImageSlot ocupava.
///
/// Aplica o tratamento `.washed` do design (`saturate .6, contrast .85,
/// brightness 1.1, opacity .94`): as fotos são de bancada, com fundo de
/// janela e mesa, e sem isso o contraste delas briga com a paleta calma
/// do resto da página.
class AtFoto extends StatelessWidget {
  final String arquivo;
  final double? height;
  final double radius;
  final BoxFit fit;

  /// Subpasta de assets/. As fotos do produto estao em `fotos`; as do guia
  /// de montagem, em `diy`.
  final String pasta;

  /// Que parte da foto manter quando a caixa é mais larga que alta. As
  /// fotos são em retrato e o módulo fica no meio, um pouco acima.
  final Alignment alignment;

  const AtFoto(
    this.arquivo, {
    super.key,
    this.height,
    this.radius = AtRadius.lg,
    this.fit = BoxFit.cover,
    this.alignment = const Alignment(0, -0.1),
    this.pasta = 'fotos',
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: ColorFiltered(
          // saturate(.6) em forma de matriz: mistura cada canal com o
          // cinza da luminancia, mantendo 60% da cor original.
          colorFilter: const ColorFilter.matrix(<double>[
            0.786, 0.286, 0.028, 0, 0,
            0.086, 0.986, 0.028, 0, 0,
            0.086, 0.286, 0.728, 0, 0,
            0, 0, 0, 1, 0,
          ]),
          child: Opacity(
            opacity: 0.94,
            child: Image.asset(
              'assets/$pasta/$arquivo',
              fit: fit,
              alignment: alignment,
              // Enquanto carrega, mostra a mesma cor de fundo dos cards
              // para nao piscar branco.
              frameBuilder: (context, child, frame, sincrono) {
                if (sincrono || frame != null) return child;
                return Container(color: AtColors.neutral200);
              },
              errorBuilder: (context, erro, pilha) => Container(
                color: AtColors.neutral200,
                alignment: Alignment.center,
                child: Text(
                  'foto indisponível',
                  style: AtText.body(12, color: AtColors.neutral600),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
