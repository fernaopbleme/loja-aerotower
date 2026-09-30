import 'package:go_router/go_router.dart';

import '../../presentation/pages/diy_page.dart';
import '../../presentation/pages/em_breve_page.dart';
import '../../presentation/pages/guia_page.dart';
import '../../presentation/pages/inicio_page.dart';
import '../../presentation/pages/loja_page.dart';
import '../../presentation/shell/at_shell.dart';
import 'rotas.dart';

/// As oito rotas do handoff. Início, loja e os guias estão construídos;
/// as demais
/// respondem no endereço certo e mostram o placeholder até serem feitas.
final appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => AtShell(child: child),
      routes: [
        GoRoute(
          path: Rotas.inicio,
          builder: (context, state) => const InicioPage(),
        ),
        GoRoute(
          path: Rotas.diy,
          builder: (context, state) => const DiyPage(),
        ),
        GoRoute(
          path: Rotas.guia,
          builder: (context, state) => GuiaPage(
            slug: state.pathParameters['slug'] ?? '',
          ),
        ),
        GoRoute(
          path: Rotas.loja,
          builder: (context, state) => const LojaPage(),
        ),
        GoRoute(
          path: Rotas.produto,
          builder: (context, state) => EmBrevePage(
            titulo: 'Produto: ${state.pathParameters['id'] ?? ''}',
          ),
        ),
        GoRoute(
          path: Rotas.carrinho,
          builder: (context, state) => const EmBrevePage(titulo: 'Carrinho'),
        ),
        GoRoute(
          path: Rotas.checkout,
          builder: (context, state) =>
              const EmBrevePage(titulo: 'Finalizar compra'),
        ),
        GoRoute(
          path: Rotas.pedido,
          builder: (context, state) => EmBrevePage(
            titulo: 'Pedido ${state.pathParameters['id'] ?? ''}',
          ),
        ),
      ],
    ),
  ],
);
