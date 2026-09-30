import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../content/guias.dart';
import '../../core/config/api_config.dart';
import '../../core/router/rotas.dart';
import '../../core/theme/at_theme.dart';
import '../../core/widgets/at_button.dart';
import '../../core/widgets/at_foto.dart';
import '../../core/widgets/at_tag.dart';
import '../../core/widgets/image_slot.dart';
import '../../data/services/analytics_service.dart';

/// Índice dos guias: conteúdo gratuito que ensina a montar a hidroponia
/// com o que a pessoa já tem. O produto aparece depois, como atalho.
class DiyPage extends StatefulWidget {
  const DiyPage({super.key});

  @override
  State<DiyPage> createState() => _DiyPageState();
}

class _DiyPageState extends State<DiyPage> {
  @override
  void initState() {
    super.initState();
    context.read<AnalyticsService>().registrar(
          Eventos.paginaVista,
          pagina: Rotas.diy,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AtSpacing.maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AtTag('Faça você mesmo', variant: AtTagVariant.accent2),
              const SizedBox(height: 14),
              Text(
                'Monte a sua hidroponia com o que você já tem',
                style: AtText.h2,
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Text(
                  'Cano, garrafa e uma bomba de aquário resolvem muito. '
                  'Estes guias são os que usamos aqui — e as fotos são das '
                  'nossas montagens, não de catálogo.',
                  style: AtText.body(15, color: AtColors.neutral800),
                ),
              ),
              const SizedBox(height: 22),
              LayoutBuilder(
                builder: (context, constraints) {
                  const gap = 18.0;
                  final colunas = ((constraints.maxWidth + gap) / (300 + gap))
                      .floor()
                      .clamp(1, 4);
                  final largura =
                      (constraints.maxWidth - gap * (colunas - 1)) / colunas;

                  // Como no CSS grid: os cards de uma linha esticam até a
                  // altura do mais alto, senão o botão de cada um fica em
                  // altura diferente.
                  final linhas = <List<Guia>>[];
                  for (var i = 0; i < guias.length; i += colunas) {
                    linhas.add(guias.sublist(
                        i, (i + colunas).clamp(0, guias.length)));
                  }

                  return Column(
                    children: [
                      for (final linha in linhas)
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: linha == linhas.last ? 0 : gap),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (var i = 0; i < linha.length; i++) ...[
                                  if (i > 0) const SizedBox(width: gap),
                                  SizedBox(
                                    width: largura,
                                    child: _CardGuia(linha[i]),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardGuia extends StatelessWidget {
  final Guia guia;

  const _CardGuia(this.guia);

  void _abrir(BuildContext context) {
    context.read<AnalyticsService>().registrar(
          Eventos.verGuias,
          pagina: Rotas.diy,
        );
    context.go('/diy/${guia.id}');
  }

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
              onTap: () => _abrir(context),
              child: guia.capa != null
                  ? AtFoto(guia.capa!, height: 180, radius: 20)
                  : ImageSlot(
                      descricao: guia.descricaoCapa,
                      height: 180,
                      radius: 20,
                    ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            guia.etiqueta.toUpperCase(),
            style: AtText.body(10,
                color: AtColors.accent, letterSpacing: 10 * 0.1, height: 1.4),
          ),
          const SizedBox(height: 10),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _abrir(context),
              child: Text(guia.titulo, style: AtText.heading(17, height: 1.2)),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Text(
              guia.resumo,
              style: AtText.body(13, color: AtColors.mix(AtColors.text, 0.8)),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: AtButton(
              'Abrir guia',
              variant: AtButtonVariant.secondary,
              onPressed: () => _abrir(context),
            ),
          ),
        ],
      ),
    );
  }
}
