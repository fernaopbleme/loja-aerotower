import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/config/api_config.dart';
import '../../core/config/app_links.dart';
import '../../core/router/rotas.dart';
import '../../core/theme/at_theme.dart';
import '../../core/widgets/at_button.dart';
import '../../core/widgets/at_icon.dart';
import '../../data/services/analytics_service.dart';
import '../../state/carrinho_store.dart';
import '../../state/loja_store.dart';

class AtHeader extends StatelessWidget {
  const AtHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final estreito = MediaQuery.sizeOf(context).width < 900;

    return Container(
      color: AtColors.bg,
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(boxShadow: AtShadows.sm),
            child: Container(
              color: AtColors.bg,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: AtSpacing.maxWidth),
                  child: Row(
                    children: [
                      const _Marca(),
                      const SizedBox(width: 20),
                      if (!estreito) ...[
                        const Expanded(child: _CampoBusca()),
                        const SizedBox(width: 20),
                      ] else
                        const Spacer(),
                      const _NavDireita(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const _FaixaCategorias(),
        ],
      ),
    );
  }
}

class _Marca extends StatelessWidget {
  const _Marca();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(Rotas.inicio),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: AtColors.accent200,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: AtIcon(AtIcons.droplet,
                    size: 20, color: AtColors.accent700),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('AeroTower', style: AtText.heading(20, height: 1.1)),
                Text(
                  'Hidroponia modular',
                  style: AtText.body(11,
                      color: AtColors.neutral700,
                      letterSpacing: 11 * 0.04,
                      height: 1.3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Filtra a grade da loja a cada tecla. Digitar fora de /loja leva
/// para lá, senão o resultado da busca ficaria invisível.
class _CampoBusca extends StatefulWidget {
  const _CampoBusca();

  @override
  State<_CampoBusca> createState() => _CampoBuscaState();
}

class _CampoBuscaState extends State<_CampoBusca> {
  late final TextEditingController _controller =
      TextEditingController(text: context.read<LojaStore>().busca);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _aoDigitar(String valor) {
    context.read<LojaStore>().busca = valor;
    if (valor.trim().isNotEmpty &&
        GoRouterState.of(context).uri.path != Rotas.loja) {
      context.go(Rotas.loja);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 6, 8, 6),
        decoration: BoxDecoration(
          color: AtColors.surface,
          borderRadius: BorderRadius.circular(AtRadius.pill),
        ),
        child: Row(
          children: [
            const AtIcon(AtIcons.search, size: 17, color: AtColors.neutral700),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: _aoDigitar,
                style: AtText.body(14),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'Buscar módulos, kits e bombas',
                  hintStyle:
                      AtText.body(14, color: AtColors.mix(AtColors.text, 0.5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavDireita extends StatelessWidget {
  const _NavDireita();

  @override
  Widget build(BuildContext context) {
    final estreito = MediaQuery.sizeOf(context).width < 900;
    final quantidade =
        context.select<CarrinhoStore, int>((c) => c.quantidadeTotal);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!estreito) ...[
          _Link('Início', () => context.go(Rotas.inicio)),
          const SizedBox(width: 16),
          _Link('Loja', () => context.go(Rotas.loja)),
          const SizedBox(width: 16),
          _Link('Faça você mesmo', () => context.go(Rotas.diy)),
          const SizedBox(width: 16),
        ],
        const _BotaoEntrar(),
        const SizedBox(width: 10),
        AtButton(
          'Carrinho',
          variant: AtButtonVariant.secondary,
          onPressed: () => context.go(Rotas.carrinho),
          leading: const AtIcon(AtIcons.cart, size: 17, color: AtColors.text),
          trailing: Container(
            constraints: const BoxConstraints(minWidth: 20),
            height: 20,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: AtColors.accent,
              borderRadius: BorderRadius.circular(AtRadius.pill),
            ),
            child: Center(
              child: Text(
                '$quantidade',
                style: AtText.body(11, color: AtColors.bg, height: 1.2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Leva da loja para o painel de monitoramento (sensores, dashboard, IA),
/// que é outra aplicação, em outro endereço. Abre em nova aba para não
/// derrubar o carrinho, que só existe em memória.
class _BotaoEntrar extends StatelessWidget {
  const _BotaoEntrar();

  Future<void> _abrirPainel(BuildContext context) async {
    context.read<AnalyticsService>().registrar(Eventos.entrarPainel);

    if (!AppLinks.painelPublicado) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'O painel ainda não está publicado.',
              style: AtText.body(14, color: AtColors.bg),
            ),
            backgroundColor: AtColors.neutral900,
            behavior: SnackBarBehavior.floating,
            width: 320,
            duration: const Duration(seconds: 3),
          ),
        );
      return;
    }

    // AppLinks.painel é um caminho ("/projeto_aeroponia/painel/"), sem
    // esquema nem host. Uri.base é a página atual, então resolve() monta o
    // endereço absoluto certo tanto no localhost quanto no GitHub Pages.
    final destino = Uri.base.resolve(AppLinks.painel);
    final abriu = await launchUrl(destino, webOnlyWindowName: '_blank');

    if (!abriu && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'Não foi possível abrir o painel.',
              style: AtText.body(14, color: AtColors.bg),
            ),
            backgroundColor: AtColors.neutral900,
            behavior: SnackBarBehavior.floating,
            width: 320,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AtButton(
      'Entrar',
      variant: AtButtonVariant.ghost,
      onPressed: () => _abrirPainel(context),
      leading: const AtIcon(AtIcons.login, size: 16, color: AtColors.accent700),
    );
  }
}

class _Link extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _Link(this.label, this.onTap);

  @override
  State<_Link> createState() => _LinkState();
}

class _LinkState extends State<_Link> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.label,
          style:
              AtText.body(14, color: _hover ? AtColors.accent : AtColors.text),
        ),
      ),
    );
  }
}

class _FaixaCategorias extends StatelessWidget {
  const _FaixaCategorias();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AtColors.divider)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AtSpacing.maxWidth),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Cada link define a categoria da barra lateral e volta à loja.
              void verCategoria(String categoria) {
                context.read<LojaStore>().categoria = categoria;
                context.go(Rotas.loja);
              }

              final categorias = [
                _LinkCategoria(
                    'HidroModular', () => verCategoria('HidroModular')),
                _LinkCategoria(
                    'Kits completos', () => verCategoria('Kits completos')),
                _LinkCategoria('Add-ons', () => verCategoria('Add-ons')),
              ];

              // Como no CSS: a faixa quebra em vez de esconder o frete.
              if (constraints.maxWidth < 620) {
                return Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 18,
                  runSpacing: 8,
                  children: [...categorias, const _FreteGratis()],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 18,
                      runSpacing: 8,
                      children: categorias,
                    ),
                  ),
                  const SizedBox(width: 18),
                  const _FreteGratis(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FreteGratis extends StatelessWidget {
  const _FreteGratis();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AtIcon(AtIcons.truck, size: 15, color: AtColors.accent2_700),
        const SizedBox(width: 7),
        Text(
          'Frete grátis acima de 3 módulos',
          style: AtText.body(13, color: AtColors.accent2_700),
        ),
      ],
    );
  }
}

class _LinkCategoria extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _LinkCategoria(this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(label, style: AtText.body(13, color: AtColors.neutral700)),
      ),
    );
  }
}
