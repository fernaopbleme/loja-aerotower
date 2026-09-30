import 'package:flutter/material.dart';

import '../../content/produtos.dart';
import '../../core/theme/at_theme.dart';
import '../../core/util/moeda.dart';
import '../../core/widgets/at_button.dart';
import '../../core/widgets/at_foto.dart';
import '../../core/widgets/image_slot.dart';

/// `.card.elev-sm` — padding 16, gap 10, raio 32.
class ProdutoCard extends StatelessWidget {
  final Produto produto;
  final double preco;
  final VoidCallback onAbrir;
  final VoidCallback onAdicionar;

  const ProdutoCard({
    super.key,
    required this.produto,
    required this.preco,
    required this.onAbrir,
    required this.onAdicionar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AtColors.surface,
        borderRadius: BorderRadius.circular(AtRadius.card),
        boxShadow: AtShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onAbrir,
              child: produto.arquivo != null
                  ? AtFoto(produto.arquivo!, height: 172, radius: 20)
                  : ImageSlot(
                      descricao: produto.foto,
                      height: 172,
                      radius: 20,
                    ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            produto.kicker.toUpperCase(),
            style: AtText.body(10,
                color: AtColors.accent, letterSpacing: 10 * 0.1, height: 1.4),
          ),
          const SizedBox(height: 10),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onAbrir,
              child: Text(produto.nome, style: AtText.heading(17, height: 1.2)),
            ),
          ),
          const SizedBox(height: 10),
          // `.card-body { flex: 1 }` — empurra o preço para a base, de
          // modo que os cards da linha alinhem.
          Expanded(
            child: Text(
              produto.resumo,
              style: AtText.body(13, color: AtColors.mix(AtColors.text, 0.8)),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              if (Precos.definidos && produto.prefixo.isNotEmpty) ...[
                Text(
                  produto.prefixo,
                  style: AtText.body(12, color: AtColors.neutral700),
                ),
                const SizedBox(width: 7),
              ],
              Text(
                Precos.definidos ? formatarMoeda(preco) : '—',
                style: AtText.heading(22,
                    color: Precos.definidos
                        ? AtColors.text
                        : AtColors.neutral500),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            Precos.definidos
                ? 'preço provisório · em 12x no Pix parcelado'
                : 'preço em definição',
            style: AtText.body(11, color: AtColors.neutral600, height: 1.4),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: AtButton('Adicionar', block: true, onPressed: onAdicionar),
              ),
              const SizedBox(width: 8),
              AtButton(
                'Detalhes',
                variant: AtButtonVariant.secondary,
                onPressed: onAbrir,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
