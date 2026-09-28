import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';

import 'core/router/app_router.dart';
import 'core/theme/at_theme.dart';
import 'data/services/analytics_service.dart';
import 'state/carrinho_store.dart';
import 'state/loja_store.dart';

void main() {
  // Sem isto o Flutter web usa URLs com hash (/#/loja) e os endereços
  // reais das rotas nunca casam.
  usePathUrlStrategy();
  runApp(const LojaAeroTowerApp());
}

class LojaAeroTowerApp extends StatelessWidget {
  const LojaAeroTowerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CarrinhoStore()),
        ChangeNotifierProvider(create: (_) => LojaStore()),
        Provider(create: (_) => AnalyticsService()),
      ],
      child: MaterialApp.router(
        title: 'AeroTower — Hidroponia modular',
        debugShowCheckedModeBanner: false,
        theme: AtTheme.theme,
        routerConfig: appRouter,
      ),
    );
  }
}
