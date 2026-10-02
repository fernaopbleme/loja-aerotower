import 'package:flutter_test/flutter_test.dart';

import 'package:aerotower_site/core/config/api_config.dart';
import 'package:aerotower_site/core/config/app_links.dart';

/// O botão "Entrar" da loja só navega quando `AppLinks.painel` tem valor:
/// vazio, ele mostra "o painel ainda não está publicado" e não vai a lugar
/// nenhum. Ficou assim por semanas sem ninguém notar, porque o aviso
/// parece uma resposta e não um defeito.
void main() {
  group('AppLinks', () {
    test('o painel tem endereço — sem isso o botão Entrar não navega', () {
      expect(AppLinks.painelPublicado, isTrue);
      expect(AppLinks.painel, isNotEmpty);
    });

    test('o endereço do painel é absoluto e aponta para outro domínio', () {
      final uri = Uri.parse(AppLinks.painel);

      // A loja e o painel são dois sites, em hosts diferentes. Um caminho
      // relativo aqui resolveria contra o domínio da loja e daria 404.
      expect(uri.hasScheme, isTrue, reason: 'faltou https:// no endereço');
      expect(uri.host, isNotEmpty);
    });

    test('resolve() devolve o endereço absoluto intacto', () {
      // O botão passa o valor por Uri.base.resolve(). Com endereço
      // absoluto isso tem de ser identidade, senão o destino muda.
      final base = Uri.parse('https://fernaopbleme.github.io/loja-aerotower/');
      expect(base.resolve(AppLinks.painel).toString(), AppLinks.painel);
    });

    test('o backend de eventos está configurado', () {
      // Mesma falha do painel, com consequência pior: vazio, o
      // AnalyticsService retorna na primeira linha e NADA é coletado —
      // sem erro, sem aviso, sem log. O teste de validação inteiro
      // produziria zero e ninguém saberia por quê.
      expect(ApiConfig.temBackend, isTrue);
      expect(Uri.parse(ApiConfig.baseUrl).hasScheme, isTrue);
    });

    test('o registro de evento espera mais que o formulário', () {
      // O backend está no F1 e dorme: acordar leva uns 18s. O registro é
      // disparado e esquecido, então pode esperar; o formulário tem gente
      // olhando para a tela e não pode.
      expect(ApiConfig.timeoutEvento, greaterThan(ApiConfig.timeout));
      expect(ApiConfig.timeoutEvento.inSeconds, greaterThanOrEqualTo(20));
    });

    test('formulário e vídeo continuam preenchidos', () {
      // Mesma classe de falha: já quebrou uma vez quando o valor dependia
      // de variável no GitHub Actions e ninguém a configurou.
      expect(AppLinks.temFormularioExterno, isTrue);
      expect(AppLinks.temVideoPitch, isTrue);
      expect(AppLinks.videoPitchId, isNotEmpty);
    });
  });
}
