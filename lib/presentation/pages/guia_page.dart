import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../content/guias.dart';
import '../../core/config/api_config.dart';
import '../../core/router/rotas.dart';
import '../../core/theme/at_theme.dart';
import '../../core/widgets/at_button.dart';
import '../../core/widgets/at_foto.dart';
import '../../core/widgets/at_icon.dart';
import '../../core/widgets/at_tag.dart';
import '../../core/widgets/image_slot.dart';
import '../../data/services/analytics_service.dart';
import '../../state/loja_store.dart';

/// Um guia aberto. O texto é o produto aqui — o módulo pronto aparece só
/// no fim, como alternativa para quem não quiser montar.
class GuiaPage extends StatefulWidget {
  final String slug;

  const GuiaPage({super.key, required this.slug});

  @override
  State<GuiaPage> createState() => _GuiaPageState();
}

class _GuiaPageState extends State<GuiaPage> {
  @override
  void initState() {
    super.initState();
    context.read<AnalyticsService>().registrar(
          Eventos.paginaVista,
          pagina: '/diy/${widget.slug}',
        );
  }

  @override
  Widget build(BuildContext context) {
    final guia = guiaPorId(widget.slug);
    if (guia == null) return _NaoEncontrado(slug: widget.slug);

    final estreito = MediaQuery.sizeOf(context).width < 900;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AtSpacing.maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AtButton(
                '← Voltar para os guias',
                variant: AtButtonVariant.ghost,
                onPressed: () => context.go(Rotas.diy),
              ),
              const SizedBox(height: 14),
              if (estreito)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Artigo(guia),
                    const SizedBox(height: 26),
                    _Materiais(guia),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _Artigo(guia)),
                    const SizedBox(width: 34),
                    SizedBox(width: 320, child: _Materiais(guia)),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Artigo extends StatelessWidget {
  final Guia guia;

  const _Artigo(this.guia);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AtTag(guia.etiqueta, variant: AtTagVariant.accent2),
        const SizedBox(height: 12),
        Text(guia.titulo, style: AtText.h2),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(
            guia.resumo,
            style: AtText.body(16, color: AtColors.neutral800),
          ),
        ),
        const SizedBox(height: 20),

        if (guia.capa != null)
          AtFoto(guia.capa!, height: 340, radius: AtRadius.lg)
        else
          ImageSlot(
            descricao: guia.descricaoCapa,
            height: 260,
            radius: AtRadius.lg,
          ),

        // Segunda foto: o meio da montagem. Só o guia do cano tem.
        if (guia.id == 'cano') ...[
          const SizedBox(height: 14),
          const AtFoto(
            'diy-cano-furos.jpg',
            height: 300,
            radius: AtRadius.lg,
            alignment: Alignment.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Furos em espiral feitos com serra copo, joelhos de 45° e o '
            'temporizador que liga a bomba em ciclo.',
            style: AtText.body(12, color: AtColors.neutral700, height: 1.5),
          ),
        ],

        for (final secao in guia.secoes) ...[
          const SizedBox(height: 28),
          Text(secao.titulo, style: AtText.h4),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(
              secao.texto,
              style: AtText.body(15, color: AtColors.neutral800),
            ),
          ),
        ],

        const SizedBox(height: 32),
        const _Upsell(),
      ],
    );
  }
}

/// Fecha o artigo oferecendo o módulo pronto — sem empurrar: quem chegou
/// até aqui já sabe o trabalho que dá montar.
class _Upsell extends StatelessWidget {
  const _Upsell();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AtColors.accent100,
        borderRadius: BorderRadius.circular(AtRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Quando vale trocar pelo módulo pronto',
            style: AtText.heading(20, color: AtColors.accent800),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              'Se você já montou a sua e quer crescer sem refazer tudo, o '
              'HidroModular encaixa por pressão e sobe um andar por vez — '
              'sem serra, sem cola e sem refazer a base.',
              style: AtText.body(14, color: AtColors.accent800),
            ),
          ),
          const SizedBox(height: 6),
          AtButton(
            'Ver o HidroModular →',
            variant: AtButtonVariant.ghost,
            onPressed: () {
              context.read<LojaStore>().categoria = 'HidroModular';
              context.go(Rotas.loja);
            },
          ),
        ],
      ),
    );
  }
}

class _Materiais extends StatelessWidget {
  final Guia guia;

  const _Materiais(this.guia);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AtColors.surface,
        borderRadius: BorderRadius.circular(AtRadius.card),
        boxShadow: AtShadows.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Lista de materiais', style: AtText.h5),
          const SizedBox(height: 12),
          for (final material in guia.materiais)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: AtIcon(AtIcons.check,
                        size: 15, color: AtColors.accent2_700),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(material, style: AtText.body(14)),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 6),
          const Divider(color: AtColors.divider, height: 1),
          const SizedBox(height: 14),
          Text(
            'Travou em alguma etapa? A gente responde — foi assim que '
            'aprendemos também.',
            style: AtText.body(13, color: AtColors.neutral700),
          ),
          const SizedBox(height: 12),
          AtButton(
            'Falar com o suporte',
            variant: AtButtonVariant.secondary,
            block: true,
            onPressed: () => context.go(Rotas.inicio),
          ),
        ],
      ),
    );
  }
}

class _NaoEncontrado extends StatelessWidget {
  final String slug;

  const _NaoEncontrado({required this.slug});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 96),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Guia não encontrado', style: AtText.h2,
                  textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Text(
                'Não existe um guia chamado "$slug".',
                style: AtText.body(15, color: AtColors.neutral700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              AtButton(
                'Ver todos os guias',
                onPressed: () => context.go(Rotas.diy),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
