import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aerotower_site/data/services/analytics_service.dart';
import 'package:aerotower_site/presentation/widgets/interesse_dialog.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('AnalyticsService - registro de clique', () {
    test('envia nome, pagina e sessao', () async {
      Map<String, dynamic>? enviado;

      final servico = AnalyticsService(
        cliente: MockClient((req) async {
          enviado = jsonDecode(req.body) as Map<String, dynamic>;
          return http.Response('{"sucesso":true}', 201);
        }),
      );

      await servico.registrar('cta_diy', pagina: '/');

      expect(enviado!['nome'], 'cta_diy');
      expect(enviado!['pagina'], '/');
      expect(enviado!['sessao'], isNotEmpty);
    });

    test('reaproveita a mesma sessao entre cliques', () async {
      final sessoes = <String>[];

      final servico = AnalyticsService(
        cliente: MockClient((req) async {
          sessoes.add((jsonDecode(req.body) as Map)['sessao'] as String);
          return http.Response('{}', 201);
        }),
      );

      await servico.registrar('cta_diy');
      await servico.registrar('cta_interesse');

      expect(sessoes.length, 2);
      expect(sessoes[0], sessoes[1],
          reason: 'um visitante clicando duas vezes e uma sessao so');
    });

    test('backend fora do ar nao lanca excecao', () async {
      final servico = AnalyticsService(
        cliente: MockClient((_) async => throw const SocketExceptionFake()),
      );

      // O clique se perde, mas a loja nao pode quebrar por causa disso.
      await expectLater(servico.registrar('cta_diy'), completes);
    });

    test('resposta de erro tambem nao lanca', () async {
      final servico = AnalyticsService(
        cliente: MockClient((_) async => http.Response('erro', 500)),
      );

      await expectLater(servico.registrar('cta_diy'), completes);
    });
  });

  group('AnalyticsService - interesse', () {
    test('envia email e produto', () async {
      Map<String, dynamic>? enviado;

      final servico = AnalyticsService(
        cliente: MockClient((req) async {
          enviado = jsonDecode(req.body) as Map<String, dynamic>;
          return http.Response('{"sucesso":true}', 201);
        }),
      );

      await servico.registrarInteresse(
        email: 'fulano@exemplo.com',
        produto: 'HidroModular',
      );

      expect(enviado!['email'], 'fulano@exemplo.com');
      expect(enviado!['produto'], 'HidroModular');
    });

    test('422 vira erro de e-mail invalido', () async {
      final servico = AnalyticsService(
        cliente: MockClient((_) async => http.Response('{}', 422)),
      );

      expect(
        () => servico.registrarInteresse(email: 'x', produto: 'y'),
        throwsA(isA<InteresseInvalido>()),
      );
    });

    test('500 vira erro visivel', () async {
      final servico = AnalyticsService(
        cliente: MockClient((_) async => http.Response('{}', 500)),
      );

      expect(
        () => servico.registrarInteresse(email: 'a@b.com', produto: 'y'),
        throwsA(isA<InteresseInvalido>()),
      );
    });
  });

  group('InteresseDialog', () {
    Widget montar(AnalyticsService servico) {
      return Provider<AnalyticsService>.value(
        value: servico,
        child: const MaterialApp(
          home: Scaffold(body: InteresseDialog()),
        ),
      );
    }

    testWidgets('mostra o formulario com e-mail e produtos', (tester) async {
      await tester.pumpWidget(montar(AnalyticsService(
        cliente: MockClient((_) async => http.Response('{}', 201)),
      )));

      expect(find.text('Me interesso pelo produto'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('HidroModular'), findsOneWidget);
      expect(find.text('HidroFullkit'), findsOneWidget);
    });

    testWidgets('envia e mostra confirmacao', (tester) async {
      Map<String, dynamic>? enviado;

      await tester.pumpWidget(montar(AnalyticsService(
        cliente: MockClient((req) async {
          enviado = jsonDecode(req.body) as Map<String, dynamic>;
          return http.Response('{"sucesso":true}', 201);
        }),
      )));

      await tester.enterText(find.byType(TextField), 'fulano@exemplo.com');
      await tester.tap(find.text('Quero ser avisado'));
      await tester.pumpAndSettle();

      expect(enviado!['email'], 'fulano@exemplo.com');
      expect(find.text('Anotado!'), findsOneWidget);
    });

    testWidgets('e-mail recusado mostra o erro, sem fechar', (tester) async {
      await tester.pumpWidget(montar(AnalyticsService(
        cliente: MockClient((_) async => http.Response('{}', 422)),
      )));

      await tester.enterText(find.byType(TextField), 'invalido');
      await tester.tap(find.text('Quero ser avisado'));
      await tester.pumpAndSettle();

      expect(find.text('Confira o e-mail digitado.'), findsOneWidget);
      expect(find.text('Anotado!'), findsNothing);
    });

    testWidgets('troca o produto escolhido', (tester) async {
      Map<String, dynamic>? enviado;

      await tester.pumpWidget(montar(AnalyticsService(
        cliente: MockClient((req) async {
          enviado = jsonDecode(req.body) as Map<String, dynamic>;
          return http.Response('{}', 201);
        }),
      )));

      await tester.enterText(find.byType(TextField), 'a@b.com');
      await tester.tap(find.text('HidroFullkit Pro'));
      await tester.pump();
      await tester.tap(find.text('Quero ser avisado'));
      await tester.pumpAndSettle();

      expect(enviado!['produto'], 'HidroFullkit Pro');
    });
  });
}

class SocketExceptionFake implements Exception {
  const SocketExceptionFake();
}
