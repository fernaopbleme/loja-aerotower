import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../content/guias.dart';
import '../../core/config/api_config.dart';
import '../../core/router/rotas.dart';
import '../../core/theme/at_theme.dart';
import '../../core/widgets/at_button.dart';
import '../../core/widgets/at_icon.dart';
import '../../core/widgets/at_tag.dart';
import '../../data/services/analytics_service.dart';
import '../../state/loja_store.dart';
import '../widgets/figura_guia.dart';

/// O guia de montagem. O texto é o produto aqui — a torre pronta aparece
/// só no fim, como alternativa para quem não quiser montar.
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

    // Enquanto existe um guia só, não há "voltar para os guias": a lista
    // não é uma página, e o botão levaria para o próprio artigo.
    return CorpoGuia(guia: guia, mostrarVoltar: guias.length > 1);
  }
}

/// O artigo. Separado da página porque a `DiyPage` o mostra direto quando
/// existe um guia só — sem obrigar a passar por um índice de um item.
class CorpoGuia extends StatelessWidget {
  final Guia guia;
  final bool mostrarVoltar;

  const CorpoGuia({
    super.key,
    required this.guia,
    this.mostrarVoltar = true,
  });

  @override
  Widget build(BuildContext context) {
    final estreito = MediaQuery.sizeOf(context).width < 900;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AtSpacing.maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (mostrarVoltar) ...[
                AtButton(
                  '← Voltar para os guias',
                  variant: AtButtonVariant.ghost,
                  onPressed: () => context.go(Rotas.diy),
                ),
                const SizedBox(height: 14),
              ],
              if (estreito)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Cabecalho(guia),
                    const SizedBox(height: 24),
                    _Materiais(guia),
                    const SizedBox(height: 28),
                    _Corpo(guia),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _Cabecalho(guia)),
                        const SizedBox(width: 34),
                        SizedBox(width: 340, child: _Materiais(guia)),
                      ],
                    ),
                    const SizedBox(height: 34),
                    _Corpo(guia),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Título, chamada, foto dos materiais e a introdução.
class _Cabecalho extends StatelessWidget {
  final Guia guia;

  const _Cabecalho(this.guia);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AtTag(guia.etiqueta, variant: AtTagVariant.accent2),
        const SizedBox(height: 12),
        Text(guia.titulo, style: AtText.h2),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(
            guia.resumo,
            style: AtText.heading(18, color: AtColors.accent, height: 1.45),
          ),
        ),
        const SizedBox(height: 20),
        FiguraGuia(guia.capa, maxWidth: 560),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(
            guia.intro,
            style: AtText.body(15, color: AtColors.neutral800, height: 1.7),
          ),
        ),
      ],
    );
  }
}

/// A ideia, as etapas, as dicas e o fecho.
class _Corpo extends StatelessWidget {
  final Guia guia;

  const _Corpo(this.guia);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: AtColors.divider, height: 1),
        const SizedBox(height: 28),

        Text(guia.ideia.titulo, style: AtText.h4),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(
            guia.ideia.texto,
            style: AtText.body(15, color: AtColors.neutral800, height: 1.7),
          ),
        ),
        if (guia.ideia.figura != null) ...[
          const SizedBox(height: 18),
          FiguraGuia(guia.ideia.figura!),
        ],

        const SizedBox(height: 34),
        const Divider(color: AtColors.divider, height: 1),
        const SizedBox(height: 28),

        Text('Como montar, em linhas gerais', style: AtText.h4),
        const SizedBox(height: 4),
        for (var i = 0; i < guia.secoes.length; i++)
          _Etapa(numero: i + 1, secao: guia.secoes[i]),

        const SizedBox(height: 14),
        const Divider(color: AtColors.divider, height: 1),
        const SizedBox(height: 28),

        Text('Dicas de quem já montou', style: AtText.h4),
        const SizedBox(height: 14),
        _Dicas(guia.dicas),

        const SizedBox(height: 34),
        _Fecho(guia.fecho),
      ],
    );
  }
}

/// Uma etapa numerada. O número fica numa coluna à esquerda, ligada por uma
/// linha vertical: é o que transforma seis blocos de texto em sequência.
class _Etapa extends StatelessWidget {
  final int numero;
  final SecaoGuia secao;

  const _Etapa({required this.numero, required this.secao});

  @override
  Widget build(BuildContext context) {
    final estreito = MediaQuery.sizeOf(context).width < 640;

    final conteudo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(secao.titulo, style: AtText.h5),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(
            secao.texto,
            style: AtText.body(15, color: AtColors.neutral800, height: 1.7),
          ),
        ),
        if (secao.figura != null) ...[
          const SizedBox(height: 16),
          FiguraGuia(secao.figura!, maxWidth: 580),
        ],
      ],
    );

    // Em tela estreita a coluna do número custa largura que o texto precisa.
    if (estreito) {
      return Padding(
        padding: const EdgeInsets.only(top: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Numero(numero),
            const SizedBox(height: 10),
            conteudo,
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 26),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Numero(numero),
          const SizedBox(width: 18),
          Expanded(child: conteudo),
        ],
      ),
    );
  }
}

class _Numero extends StatelessWidget {
  final int numero;

  const _Numero(this.numero);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: AtColors.accent100,
        shape: BoxShape.circle,
        border: Border.all(color: AtColors.accent300),
      ),
      alignment: Alignment.center,
      child: Text(
        numero.toString().padLeft(2, '0'),
        style: AtText.heading(14, color: AtColors.accent700),
      ),
    );
  }
}

/// As dicas em duas colunas no desktop, uma no celular.
class _Dicas extends StatelessWidget {
  final List<Dica> dicas;

  const _Dicas(this.dicas);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 14.0;
        final duasColunas = constraints.maxWidth > 760;
        final largura = duasColunas
            ? (constraints.maxWidth - gap) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final dica in dicas)
              SizedBox(width: largura, child: _CartaoDica(dica)),
          ],
        );
      },
    );
  }
}

class _CartaoDica extends StatelessWidget {
  final Dica dica;

  const _CartaoDica(this.dica);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AtColors.accent2_100,
        borderRadius: BorderRadius.circular(AtRadius.lg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: AtIcon(AtIcons.check, size: 16,
                color: AtColors.accent2_700),
          ),
          const SizedBox(width: 10),
          // Título e texto na mesma frase, como no material original:
          // "Branco por fora, escuro por dentro: tubo claro para..."
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${dica.titulo}: ',
                    style: AtText.body(14,
                        color: AtColors.accent2_900,
                        weight: FontWeight.w700,
                        height: 1.6),
                  ),
                  TextSpan(
                    text: dica.texto,
                    style: AtText.body(14,
                        color: AtColors.accent2_800, height: 1.6),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Fecha o artigo ligando o faça-você-mesmo ao produto — sem empurrar:
/// quem leu até aqui já sabe o trabalho que dá montar.
class _Fecho extends StatelessWidget {
  final SecaoGuia fecho;

  const _Fecho(this.fecho);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: AtColors.accent100,
        borderRadius: BorderRadius.circular(AtRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            fecho.titulo,
            style: AtText.heading(21, color: AtColors.accent800),
          ),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Text(
              fecho.texto,
              style: AtText.body(14, color: AtColors.accent800, height: 1.7),
            ),
          ),
          const SizedBox(height: 10),
          AtButton(
            'Conheça o AeroTower →',
            onPressed: () {
              context.read<LojaStore>().categoria = 'Todos';
              context.go(Rotas.loja);
            },
          ),
        ],
      ),
    );
  }
}

/// Lista de materiais, fixa ao lado do cabeçalho no desktop.
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
          Text('O que você vai precisar', style: AtText.h5),
          const SizedBox(height: 6),
          Text(
            'Quase tudo se encontra em loja de material de construção ou de '
            'aquarismo.',
            style: AtText.body(13, color: AtColors.neutral700, height: 1.5),
          ),
          const SizedBox(height: 14),
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
                    child: Text(material,
                        style: AtText.body(14, height: 1.5)),
                  ),
                ],
              ),
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
              Text('Guia não encontrado',
                  style: AtText.h2, textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Text(
                'Não existe um guia chamado "$slug".',
                style: AtText.body(15, color: AtColors.neutral700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              AtButton(
                'Ir para o guia de montagem',
                onPressed: () => context.go(Rotas.diy),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
