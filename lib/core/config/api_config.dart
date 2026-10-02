/// Backend que recebe os eventos de validação.
class ApiConfig {
  /// O backend que recebe os eventos da validação.
  ///
  /// Ficou vazio enquanto não havia backend publicado — e com ele vazio o
  /// registro é pulado, então NADA era coletado. Agora existe backend, e o
  /// endereço vem como padrão no código, não de variável do GitHub
  /// Actions: depender de variável já derrubou o vídeo e o formulário uma
  /// vez, sem nenhum aviso no build.
  ///
  /// Se o backend sair do ar, volte este valor para '' em vez de deixar o
  /// endereço morto. Apontar para um servidor que não responde é pior que
  /// não tentar: gasta DNS, conexão e o timeout inteiro no celular de quem
  /// está visitando.
  ///
  /// Para rodar com o backend local:
  ///   flutter run -d chrome --dart-define=BACKEND_URL=http://127.0.0.1:8000
  static const String baseUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'https://aerotower-backend-bfb7frgsbccuanhf'
        '.eastus-01.azurewebsites.net',
  );

  static bool get temBackend => baseUrl.isNotEmpty;

  static String get eventos => '$baseUrl/eventos';
  static String get interesse => '$baseUrl/eventos/interesse';

  /// Para o que a pessoa está esperando na tela (o formulário de
  /// interesse). Curto de propósito: ninguém encara um botão girando.
  static const Duration timeout = Duration(seconds: 5);

  /// Para o registro de clique e de visita, que ninguém espera: é disparado
  /// e esquecido, sem bloquear nada.
  ///
  /// Generoso porque o backend está no plano F1, que descarrega a
  /// aplicação depois de ~20 min parada. O primeiro acesso depois disso
  /// leva uns 18s só para acordar — com 5s, a visita que ACORDOU o
  /// servidor seria justamente a descartada, e some do número a cada
  /// retomada.
  static const Duration timeoutEvento = Duration(seconds: 30);
}

/// Nomes dos CTAs. Precisam bater com EVENTOS_ACEITOS no backend —
/// qualquer outro nome é recusado com 422.
class Eventos {
  static const diy = 'cta_diy';
  static const interesse = 'cta_interesse';
  static const verProdutos = 'cta_ver_produtos';
  static const verGuias = 'cta_ver_guias';
  static const montarTorre = 'cta_montar_torre';
  static const verKits = 'cta_ver_kits';
  static const addCarrinho = 'cta_add_carrinho';
  static const entrarPainel = 'cta_entrar_painel';
  static const paginaVista = 'pagina_vista';
}
