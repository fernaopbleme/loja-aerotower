import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aerotower_site/content/guias.dart';
import 'package:aerotower_site/data/services/analytics_service.dart';
import 'package:aerotower_site/presentation/pages/diy_page.dart';
import 'package:aerotower_site/state/loja_store.dart';

/// A tela do "faça você mesmo" é longa, tem figuras de proporções
/// diferentes e muda de arranjo em três larguras. Renderizar de verdade em
/// cada uma é o que pega estouro de layout e asset faltando — erros que
/// não aparecem no `flutter analyze` e só dariam as caras na página
/// publicada.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Widget montar() {
    return MultiProvider(
      providers: [
        Provider<AnalyticsService>.value(
          value: AnalyticsService(
            // Sem backend configurado o serviço pula a chamada; o
            // MockClient é só uma rede de segurança.
            baseUrl: '',
            cliente: MockClient((_) async => http.Response('{}', 201)),
          ),
        ),
        ChangeNotifierProvider(create: (_) => LojaStore()),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: DiyPage()),
        ),
      ),
    );
  }

  /// Renderiza na largura pedida e devolve a exceção de layout, se houve.
  Future<void> renderizarEm(WidgetTester tester, double largura) async {
    tester.view.physicalSize = Size(largura, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(montar());
    await tester.pump();
  }

  group('DiyPage', () {
    testWidgets('mostra o guia direto, sem indice, quando existe um so',
        (tester) async {
      await renderizarEm(tester, 1280);

      expect(guias.length, 1, reason: 'o teste abaixo supoe um guia so');
      expect(find.text(guias.first.titulo), findsOneWidget);

      // O indice tem este botao em cada card. Com um guia, nao deve existir
      // nem o botao nem o "voltar para os guias".
      expect(find.text('Abrir guia'), findsNothing);
      expect(find.text('← Voltar para os guias'), findsNothing);
    });

    testWidgets('traz as seis etapas, as dicas e o fecho', (tester) async {
      await renderizarEm(tester, 1280);

      final guia = guias.first;
      expect(guia.secoes.length, 6);
      for (final secao in guia.secoes) {
        expect(find.text(secao.titulo), findsOneWidget,
            reason: 'etapa "${secao.titulo}" nao apareceu');
      }

      expect(find.text('Como montar, em linhas gerais'), findsOneWidget);
      expect(find.text('Dicas de quem já montou'), findsOneWidget);
      expect(find.text(guia.fecho.titulo), findsOneWidget);
      expect(find.text('Conheça o AeroTower →'), findsOneWidget);
    });

    testWidgets('lista todos os materiais', (tester) async {
      await renderizarEm(tester, 1280);

      expect(find.text('O que você vai precisar'), findsOneWidget);
      for (final material in guias.first.materiais) {
        expect(find.text(material), findsOneWidget,
            reason: 'material "$material" nao apareceu');
      }
    });

    // As quebras ficam em 900 (materiais saem da lateral) e 640 (o numero
    // da etapa sai de ao lado do texto).
    for (final largura in [1440.0, 1280.0, 899.0, 700.0, 639.0, 390.0]) {
      testWidgets('renderiza sem estouro de layout em ${largura.toInt()}px',
          (tester) async {
        await renderizarEm(tester, largura);

        expect(tester.takeException(), isNull);
        expect(find.text(guias.first.titulo), findsOneWidget);
      });
    }
  });
}
