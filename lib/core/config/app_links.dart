import '../widgets/video_youtube.dart';

/// Links externos do projeto.
///
/// Ficam como padrão no código de propósito: são endereços públicos, não
/// segredos. Depender de variável no GitHub Actions já quebrou uma vez —
/// esquecer de configurar derrubava o vídeo e o formulário sem nenhum
/// aviso no build.
class AppLinks {
  /// Google Forms que coleta o interesse.
  static const String formularioInteresse = String.fromEnvironment(
    'FORM_URL',
    defaultValue: 'https://docs.google.com/forms/d/e/'
        '1FAIpQLSe2GtSgQOI6vsBLDIFH9FuF7pMmzgPEbH1Q-eZSp0WvZSH-7Q/viewform',
  );

  static bool get temFormularioExterno => formularioInteresse.isNotEmpty;

  /// Vídeo do pitch no YouTube. Aceita a URL inteira ou só o id.
  static const String _videoPitchBruto = String.fromEnvironment(
    'VIDEO_URL',
    defaultValue: 'https://youtu.be/ai9nwWyfzMs',
  );

  static String get videoPitchId => VideoYoutube.extrairId(_videoPitchBruto);

  static bool get temVideoPitch => videoPitchId.isNotEmpty;

  /// Painel de sensores — outra aplicação, em outro domínio.
  ///
  /// O plano antigo era servir os dois no mesmo site, com o painel em
  /// "/projeto_aeroponia/painel/", e por isso este valor já foi um caminho
  /// relativo. Não aconteceu: a loja ficou em fernaopbleme.github.io e o
  /// painel no repositório do projeto. Agora é o endereço completo.
  ///
  /// Estava vazio, e com ele vazio o botão "Entrar" não ia a lugar nenhum
  /// — só mostrava "o painel ainda não está publicado". Ele está.
  static const String painel = String.fromEnvironment(
    'PAINEL_URL',
    defaultValue: 'https://ribeirocaio11.github.io/projeto_aeroponia/',
  );

  static bool get painelPublicado => painel.isNotEmpty;
}
