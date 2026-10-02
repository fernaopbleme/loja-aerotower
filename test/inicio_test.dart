import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aerotower_site/data/services/analytics_service.dart';
import 'package:aerotower_site/presentation/pages/inicio_page.dart';
import 'package:aerotower_site/state/loja_store.dart';

/// O retorno de quem usou foi que o botão do formulário era difícil de
/// achar: ele existia só no fecho da página, depois de cinco seções.
///
/// "Está visível" não é coisa que `flutter analyze` verifique, e o teste
/// abaixo não substitui olhar a tela — mas mede a parte objetiva do
/// pedido: o botão existe perto do topo, antes das seções que antes o
/// escondiam. Se alguém reordenar a home e empurrar o botão para baixo de
/// novo, isto falha.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  const rotulo = 'Me avise sobre o produto!';

  Widget montar() {
    return MultiProvider(
      providers: [
        Provider<AnalyticsService>.value(
          value: AnalyticsService(
            baseUrl: '',
            cliente: MockClient((_) async => http.Response('{}', 201)),
          ),
        ),
        ChangeNotifierProvider(create: (_) => LojaStore()),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: InicioPage()),
        ),
      ),
    );
  }

  Future<void> renderizarEm(WidgetTester tester, double largura) async {
    // Alta o bastante para a home inteira caber sem recorte, senão os
    // widgets de baixo nem entram na árvore e a medida de posição mente.
    tester.view.physicalSize = Size(largura, 6000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(montar());
    await tester.pump();
  }

  group('Botão do formulário na home', () {
    testWidgets('aparece duas vezes: embaixo do vídeo e no fecho',
        (tester) async {
      await renderizarEm(tester, 1280);
      expect(find.text(rotulo), findsNWidgets(2));
    });

    testWidgets('o primeiro fica logo abaixo do vídeo', (tester) async {
      await renderizarEm(tester, 1280);

      final video = tester.getBottomLeft(find.byType(AspectRatio).first).dy;
      final botao = tester.getTopLeft(find.text(rotulo).first).dy;

      expect(botao, greaterThan(video),
          reason: 'o botão deve vir depois do vídeo, não antes');
      // Vídeo, legenda de uma linha e o espaçamento. Mais que isto quer
      // dizer que alguma coisa entrou no meio.
      expect(botao - video, lessThan(120),
          reason: 'o botão descolou do vídeo: ${botao - video}px de distância');
    });

    testWidgets('o primeiro vem antes das seções que o escondiam',
        (tester) async {
      await renderizarEm(tester, 1280);

      final botao = tester.getTopLeft(find.text(rotulo).first).dy;

      // A primeira seção depois da hero. Se o botão estiver abaixo dela,
      // voltamos ao problema que o pedido mandou corrigir.
      final evidencias =
          tester.getTopLeft(find.text('11 mi').first).dy;

      expect(botao, lessThan(evidencias),
          reason: 'o botão voltou para depois das evidências');
    });

    for (final largura in [1440.0, 1280.0, 899.0, 390.0]) {
      testWidgets('renderiza sem estouro em ${largura.toInt()}px',
          (tester) async {
        await renderizarEm(tester, largura);
        expect(tester.takeException(), isNull);
        expect(find.text(rotulo), findsNWidgets(2));
      });
    }
  });
}
