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

  /// Painel de sensores. Vazio enquanto não estiver publicado.
  static const String painel = String.fromEnvironment(
    'PAINEL_URL',
    defaultValue: '',
  );

  static bool get painelPublicado => painel.isNotEmpty;
}
