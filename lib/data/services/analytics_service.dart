import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/config/api_config.dart';

/// Registra os cliques de CTA no backend, para medir interesse real.
///
/// Duas regras que valem para tudo aqui:
///
/// 1. **Nunca atrapalhar o usuário.** Se o backend estiver fora do ar, o
///    clique se perde em silêncio — a loja continua funcionando igual.
/// 2. **Nada de identificar ninguém.** O que vai junto é um id de sessão
///    aleatório, guardado no navegador, que só serve para separar
///    "10 cliques de 1 pessoa" de "10 pessoas".
class AnalyticsService {
  static const _chaveSessao = 'aerotower_sessao';

  final http.Client _http;
  String? _sessao;

  AnalyticsService({http.Client? cliente}) : _http = cliente ?? http.Client();

  /// Id anônimo por navegador, criado uma vez e reaproveitado.
  Future<String> _obterSessao() async {
    if (_sessao != null) return _sessao!;

    try {
      final prefs = await SharedPreferences.getInstance();
      var sessao = prefs.getString(_chaveSessao);

      if (sessao == null || sessao.isEmpty) {
        sessao = _gerarId();
        await prefs.setString(_chaveSessao, sessao);
      }

      _sessao = sessao;
      return sessao;
    } catch (_) {
      // Navegador com armazenamento bloqueado: usa um id só desta visita.
      return _sessao ??= _gerarId();
    }
  }

  static String _gerarId() {
    final aleatorio = Random.secure();
    final bytes = List<int>.generate(16, (_) => aleatorio.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Registra um clique. Não lança: falha caladamente de propósito.
  Future<void> registrar(String evento, {String pagina = ''}) async {
    try {
      final sessao = await _obterSessao();
      await _http
          .post(
            Uri.parse(ApiConfig.eventos),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({
              'nome': evento,
              'pagina': pagina,
              'sessao': sessao,
            }),
          )
          .timeout(ApiConfig.timeout);
    } catch (e) {
      debugPrint('Evento "$evento" não registrado: $e');
    }
  }

  /// Envia o e-mail de quem se interessou. Este **pode** falhar: a pessoa
  /// preencheu um formulário e merece saber se não deu certo.
  Future<void> registrarInteresse({
    required String email,
    required String produto,
  }) async {
    final sessao = await _obterSessao();

    final resposta = await _http
        .post(
          Uri.parse(ApiConfig.interesse),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'produto': produto,
            'sessao': sessao,
          }),
        )
        .timeout(ApiConfig.timeout);

    if (resposta.statusCode == 422) {
      throw const InteresseInvalido('Confira o e-mail digitado.');
    }
    if (resposta.statusCode >= 400) {
      throw const InteresseInvalido(
        'Não conseguimos registrar agora. Tente de novo em instantes.',
      );
    }
  }
}

class InteresseInvalido implements Exception {
  final String mensagem;
  const InteresseInvalido(this.mensagem);

  @override
  String toString() => mensagem;
}
