import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../content/produtos.dart';
import '../../core/config/api_config.dart';
import '../../core/theme/at_theme.dart';
import '../../core/widgets/at_button.dart';
import '../../core/widgets/at_radio.dart';
import '../../core/widgets/at_tag.dart';
import '../../core/router/rotas.dart';
import '../../core/widgets/at_foto.dart';
import '../../data/services/analytics_service.dart';
import '../../state/carrinho_store.dart';
import '../../state/loja_store.dart';
import '../widgets/produto_card.dart';

class LojaPage extends StatelessWidget {
  const LojaPage({super.key});

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
              const _Hero(),
              const SizedBox(height: 30),
              if (estreito)
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BarraLateral(),
                    SizedBox(height: 28),
                    _Grade(),
                  ],
                )
              else
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 236, child: _BarraLateral()),
                    SizedBox(width: 28),
                    Expanded(child: _Grade()),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final estreito = MediaQuery.sizeOf(context).width < 900;
    final loja = context.read<LojaStore>();

    final texto = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const AtTag('Cultive em casa ou em escala',
            variant: AtTagVariant.accent2),
        const SizedBox(height: 14),
        Text(
          'Uma torre hidropônica que cresce junto com você',
          style: AtText.heading(40),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Text(
            'Comece com um módulo e vá empilhando. Escolha a cor, o número de '
            'furos e adicione bomba, mangueira e reservatório quando precisar.',
            style: AtText.body(16, color: AtColors.neutral800),
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            AtButton(
              'Montar minha torre',
              onPressed: () {
                context.read<AnalyticsService>().registrar(
                    Eventos.montarTorre, pagina: Rotas.loja);
                loja.categoria = 'HidroModular';
              },
            ),
            AtButton(
              'Ver kits prontos',
              variant: AtButtonVariant.secondary,
              onPressed: () {
                context.read<AnalyticsService>().registrar(
                    Eventos.verKits, pagina: Rotas.loja);
                loja.categoria = 'Kits completos';
              },
            ),
          ],
        ),
      ],
    );

    const imagem = AtFoto(
      'modulos-empilhados.jpg',
      height: 280,
      radius: 26,
    );

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AtColors.surface,
        borderRadius: BorderRadius.circular(AtRadius.card),
      ),
      child: estreito
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [texto, const SizedBox(height: 26), imagem],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 115, child: texto),
                const SizedBox(width: 26),
                const Expanded(flex: 100, child: imagem),
              ],
            ),
    );
  }
}

class _BarraLateral extends StatelessWidget {
  const _BarraLateral();

  @override
  Widget build(BuildContext context) {
    final loja = context.watch<LojaStore>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Categorias', style: AtText.h6()),
        const SizedBox(height: 10),
        for (final categoria in categorias)
          _PilulaCategoria(
            label: categoria,
            selecionada: loja.categoria == categoria,
            onTap: () => loja.categoria = categoria,
          ),
        const SizedBox(height: 22),
        Text('Furos por módulo', style: AtText.h6()),
        const SizedBox(height: 10),
        for (final n in const [0, 2, 3, 4])
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: AtRadio(
              label: n == 0 ? 'Qualquer' : '$n furos',
              selecionado: loja.furoFiltro == n,
              onTap: () => loja.selecionarFuroFiltro(n),
            ),
          ),
        const SizedBox(height: 14),
        const _CaixaAjuda(),
      ],
    );
  }
}

class _PilulaCategoria extends StatelessWidget {
  final String label;
  final bool selecionada;
  final VoidCallback onTap;

  const _PilulaCategoria({
    required this.label,
    required this.selecionada,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: selecionada ? AtColors.accent : Colors.transparent,
              borderRadius: BorderRadius.circular(AtRadius.pill),
            ),
            child: Text(
              label,
              style: AtText.body(
                14,
                color: selecionada ? AtColors.bg : AtColors.text,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CaixaAjuda extends StatelessWidget {
  const _CaixaAjuda();

  @override
  Widget build(BuildContext context) {
    final loja = context.read<LojaStore>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AtColors.accent2_100,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Precisa de ajuda?',
              style: AtText.h6(color: AtColors.accent2_800)),
          const SizedBox(height: 6),
          Text(
            'Diga a altura que você quer e sugerimos a bomba certa.',
            style: AtText.body(13, color: AtColors.accent2_800),
          ),
          const SizedBox(height: 6),
          AtButton(
            'Ver add-ons →',
            variant: AtButtonVariant.ghost,
            onPressed: () => loja.categoria = 'Add-ons',
          ),
        ],
      ),
    );
  }
}

class _Grade extends StatelessWidget {
  const _Grade();

  @override
  Widget build(BuildContext context) {
    final loja = context.watch<LojaStore>();
    final carrinho = context.read<CarrinhoStore>();
    final lista = loja.produtosFiltrados;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Flexible(child: Text(loja.tituloLista, style: AtText.h3)),
            const SizedBox(width: 12),
            Text(
              loja.contagem,
              style: AtText.body(13, color: AtColors.neutral700),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (lista.isEmpty)
          _SemResultados(termo: loja.busca)
        else
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = 18.0;
              final colunas =
                  ((constraints.maxWidth + gap) / (238 + gap)).floor().clamp(1, 4);
              final largura =
                  (constraints.maxWidth - gap * (colunas - 1)) / colunas;

              Widget card(Produto produto) => ProdutoCard(
                    produto: produto,
                    preco: Precos.unitario(
                      produto,
                      furos: produto.furos ?? 2,
                      bomba: 'baixa',
                    ),
                    onAbrir: () => context.go('/produto/${produto.id}'),
                    onAdicionar: () =>
                        _adicionar(context, carrinho, loja, produto),
                  );

              // Como no CSS grid, os cards de uma linha esticam até a
              // altura do mais alto. Wrap deixaria cada um na altura
              // natural e o resumo mais longo desalinharia os preços.
              final linhas = <List<Produto>>[];
              for (var i = 0; i < lista.length; i += colunas) {
                linhas.add(lista.sublist(
                    i, (i + colunas).clamp(0, lista.length)));
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
                              SizedBox(width: largura, child: card(linha[i])),
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
    );
  }

  /// Igual ao protótipo: o card usa a configuração corrente da loja.
  void _adicionar(
    BuildContext context,
    CarrinhoStore carrinho,
    LojaStore loja,
    Produto produto,
  ) {
    final ehModular = produto.id == 'modular';
    final temBomba = produto.id == 'addons';

    context
        .read<AnalyticsService>()
        .registrar(Eventos.addCarrinho, pagina: Rotas.loja);

    carrinho.adicionar(
      ItemCarrinho(
        id: produto.id,
        nome: produto.nome,
        cor: ehModular ? loja.cor : null,
        furos: ehModular ? loja.furos : null,
        bomba: temBomba ? loja.bomba : null,
        precoUnitario: Precos.unitario(
          produto,
          furos: ehModular ? loja.furos : null,
          bomba: temBomba ? loja.bomba : null,
        ),
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '${produto.nome} adicionado ao carrinho',
            style: AtText.body(14, color: AtColors.bg),
          ),
          backgroundColor: AtColors.neutral900,
          behavior: SnackBarBehavior.floating,
          width: 320,
          duration: const Duration(seconds: 2),
        ),
      );
  }
}

/// O handoff lista "empty search results" como não desenhado.
/// Este é o mínimo para a tela não ficar em branco — trocar quando
/// houver desenho.
class _SemResultados extends StatelessWidget {
  final String termo;

  const _SemResultados({required this.termo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: BoxDecoration(
        color: AtColors.surface,
        borderRadius: BorderRadius.circular(AtRadius.lg),
      ),
      child: Column(
        children: [
          Text('Nada encontrado', style: AtText.h4),
          const SizedBox(height: 8),
          Text(
            termo.trim().isEmpty
                ? 'Nenhum produto nesta categoria.'
                : 'Nenhum produto para "${termo.trim()}".',
            style: AtText.body(14, color: AtColors.neutral700),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
