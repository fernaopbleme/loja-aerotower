/// Endereço do backend que recebe os eventos de validação.
class ApiConfig {
  /// Backend FastAPI no Azure.
  ///
  /// Trocar aqui se o App Service mudar de nome. Para testar contra um
  /// backend rodando na sua máquina, use 'http://localhost:8000'.
  static const String baseUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue:
        'https://aerotowersystem-eqatd2e6d8fghhbj.eastus-01.azurewebsites.net',
  );

  static const String eventos = '$baseUrl/eventos';
  static const String interesse = '$baseUrl/eventos/interesse';

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
