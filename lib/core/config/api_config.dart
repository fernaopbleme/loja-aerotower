/// Backend que recebe os eventos de validação.
class ApiConfig {
  /// Vazio por padrão: o site publicado no GitHub Pages não tem backend.
  ///
  /// Com a URL vazia, o registro de clique é pulado — nem chega a abrir
  /// conexão. Apontar para um servidor morto seria pior que não tentar:
  /// cada clique gastaria DNS, conexão e o timeout inteiro, à toa, no
  /// celular de quem está visitando.
  ///
  /// Para rodar com o backend local:
  ///   flutter run -d chrome --dart-define=BACKEND_URL=http://127.0.0.1:8000
  static const String baseUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: '',
  );

  static bool get temBackend => baseUrl.isNotEmpty;

  static String get eventos => '$baseUrl/eventos';
  static String get interesse => '$baseUrl/eventos/interesse';

  /// Curto de propósito: o registro de clique nunca deve travar a interface.
  static const Duration timeout = Duration(seconds: 5);
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
