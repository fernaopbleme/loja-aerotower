import '../widgets/video_youtube.dart';

/// Links externos do projeto.
class AppLinks {
  /// Formulário que coleta o interesse das pessoas.
  ///
  /// COLE AQUI O LINK DO SEU GOOGLE FORMS (ou passe --dart-define=FORM_URL).
  /// Vazio = o botão abre o formulário embutido, que precisa do backend
  /// local. Preenchido = abre o formulário do Google numa aba nova, e o
  /// site publicado funciona sem servidor nenhum.
  static const String formularioInteresse = String.fromEnvironment(
    'FORM_URL',
    defaultValue: '',
  );

  static bool get temFormularioExterno => formularioInteresse.isNotEmpty;

  /// Vídeo do pitch no YouTube.
  ///
  /// COLE AQUI O LINK (ou passe --dart-define=VIDEO_URL). Aceita a URL
  /// inteira ou só o id. Vazio = aparece o espaço reservado no lugar.
  static const String _videoPitchBruto = String.fromEnvironment(
    'VIDEO_URL',
    defaultValue: '',
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
