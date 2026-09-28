import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../content/pilares.dart';
import '../../core/config/api_config.dart';
import '../../core/config/app_links.dart';
import '../../core/router/rotas.dart';
import '../../core/theme/at_theme.dart';
import '../../core/widgets/at_button.dart';
import '../../core/widgets/at_foto.dart';
import '../../core/widgets/at_icon.dart';
import '../../core/widgets/at_tag.dart';
import '../../core/widgets/video_slot.dart';
import '../../core/widgets/video_youtube.dart';
import '../../data/services/analytics_service.dart';
import '../widgets/interesse_dialog.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  @override
  void initState() {
    super.initState();
    // Denominador da validação: sem saber quantos viram a página, um
    // número de cliques sozinho não diz nada.
    context.read<AnalyticsService>().registrar(
          Eventos.paginaVista,
          pagina: Rotas.inicio,
        );
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _Hero(),
        _Pilares(),
        _BandaInteresse(),
        _BandaDiy(),
      ],
    );
  }
}

/// Abaixo de 900px as segundas colunas viram uma coluna só.
bool _estreito(BuildContext context) => MediaQuery.sizeOf(context).width < 900;

class _Secao extends StatelessWidget {
  final EdgeInsets padding;
  final Widget child;

  const _Secao({required this.padding, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AtSpacing.maxWidth),
          child: child,
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final analytics = context.read<AnalyticsService>();

    final texto = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const AtTag('Projeto AeroTower'),
        const SizedBox(height: 14),
        Text(
          'Hidroponia que cabe na sua casa — e cresce até virar produção',
          style: AtText.heading(44),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Text(
            'Somos um projeto de torres hidropônicas modulares: você começa '
            'com um módulo e vai empilhando conforme a planta, o espaço e a '
            'vontade. Assista ao pitch de 5 minutos para entender a ideia '
            'inteira.',
            style: AtText.body(17, color: AtColors.neutral800),
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            AtButton(
              'Ver produtos',
              onPressed: () {
                analytics.registrar(Eventos.verProdutos,
                    pagina: Rotas.inicio);
                context.go(Rotas.loja);
              },
            ),
            AtButton(
              'Fazer a minha própria',
              variant: AtButtonVariant.secondary,
              onPressed: () {
                analytics.registrar(Eventos.diy, pagina: Rotas.inicio);
                context.go(Rotas.diy);
              },
            ),
          ],
        ),
      ],
    );

    const video = _FiguraVideo();

    return _Secao(
      padding: const EdgeInsets.fromLTRB(24, 38, 24, 10),
      child: _estreito(context)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [texto, const SizedBox(height: 34), video],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 100, child: texto),
                const SizedBox(width: 34),
                const Expanded(flex: 105, child: video),
              ],
            ),
    );
  }
}

class _FiguraVideo extends StatelessWidget {
  const _FiguraVideo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (AppLinks.temVideoPitch)
          VideoYoutube(videoId: AppLinks.videoPitchId)
        else
          const VideoSlot(
            titulo: 'Pitch do projeto',
            caminhoArquivo: 'VIDEO_URL',
          ),
        const SizedBox(height: 10),
        Text(
          AppLinks.temVideoPitch
              ? 'Em 5 minutos: a ideia, o protótipo e onde queremos chegar.'
              : 'Espaço reservado para o vídeo do pitch.',
          style: AtText.body(12, color: AtColors.neutral700, height: 1.5),
        ),
      ],
    );
  }
}

class _Pilares extends StatelessWidget {
  const _Pilares();

  @override
  Widget build(BuildContext context) {
    return _Secao(
      padding: const EdgeInsets.fromLTRB(24, 34, 24, 0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const gap = 18.0;
          final colunas =
              ((constraints.maxWidth + gap) / (240 + gap)).floor().clamp(1, 3);
          final largura =
              (constraints.maxWidth - gap * (colunas - 1)) / colunas;

          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              for (final pilar in pilares)
                SizedBox(width: largura, child: _CardPilar(pilar)),
            ],
          );
        },
      ),
    );
  }
}

class _CardPilar extends StatelessWidget {
  final Pilar pilar;

  const _CardPilar(this.pilar);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AtColors.surface,
        borderRadius: BorderRadius.circular(AtRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AtColors.accent2_200,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                pilar.numero,
                style: AtText.heading(18, color: AtColors.accent2_800),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(pilar.titulo, style: AtText.h4),
          const SizedBox(height: 8),
          Text(
            pilar.texto,
            style: AtText.body(14, color: AtColors.neutral800),
          ),
        ],
      ),
    );
  }
}

/// Faixa de validação: mede quantas pessoas realmente querem o produto.
///
/// O clique já é um sinal; o e-mail, deixado no diálogo, é um sinal bem
/// mais forte — e diz *qual* produto atraiu a pessoa.
class _BandaInteresse extends StatelessWidget {
  const _BandaInteresse();

  @override
  Widget build(BuildContext context) {
    final estreito = _estreito(context);

    final texto = Column(
      crossAxisAlignment:
          estreito ? CrossAxisAlignment.start : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // accent-2 de propósito: a tag accent tem fundo accent-100, igual
        // ao da faixa, e sumiria dentro dela.
        const AtTag('Pré-lançamento', variant: AtTagVariant.accent2),
        const SizedBox(height: 12),
        Text(
          'Você usaria uma torre AeroTower em casa?',
          style: AtText.heading(28, color: AtColors.accent800),
        ),
        const SizedBox(height: 8),
        Text(
          'Estamos na fase de protótipo: as peças das fotos são as que já '
          'imprimimos e testamos. Deixe seu contato para acompanhar o '
          'lançamento — é o interesse de vocês que decide o que fabricamos '
          'primeiro.',
          style: AtText.body(15, color: AtColors.accent800),
        ),
      ],
    );

    final botao = AtButton(
      'Me avise sobre o produto!',
      height: 48,
      leading: const AtIcon(AtIcons.check, size: 17, color: AtColors.bg),
      onPressed: () {
        context.read<AnalyticsService>().registrar(
              Eventos.interesse,
              pagina: Rotas.inicio,
            );
        // Com FORM_URL definido, manda para o Google Forms: funciona num
        // site publicado sem backend nenhum. Sem ele, abre o formulario
        // embutido, que depende do backend local.
        if (AppLinks.temFormularioExterno) {
          launchUrl(
            Uri.parse(AppLinks.formularioInteresse),
            webOnlyWindowName: '_blank',
          );
        } else {
          InteresseDialog.abrir(context);
        }
      },
    );

    return _Secao(
      padding: const EdgeInsets.fromLTRB(24, 34, 24, 0),
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: AtColors.accent100,
          borderRadius: BorderRadius.circular(AtRadius.card),
        ),
        child: estreito
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [texto, const SizedBox(height: 20), botao],
              )
            : Row(
                children: [
                  Expanded(child: texto),
                  const SizedBox(width: 26),
                  botao,
                ],
              ),
      ),
    );
  }
}

class _BandaDiy extends StatelessWidget {
  const _BandaDiy();

  @override
  Widget build(BuildContext context) {
    final texto = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Sem orçamento? Comece pelo faça você mesmo',
          style: AtText.heading(25, color: AtColors.accent2_800),
        ),
        const SizedBox(height: 8),
        Text(
          'Reunimos guias com vídeo e passo a passo para montar uma '
          'hidroponia com cano, garrafa e bomba de aquário. Se depois você '
          'quiser escalar, os módulos estão ali.',
          style: AtText.body(15, color: AtColors.accent2_800),
        ),
        const SizedBox(height: 12),
        AtButton(
          'Ver os guias',
          onPressed: () {
            context.read<AnalyticsService>().registrar(
                  Eventos.verGuias,
                  pagina: Rotas.inicio,
                );
            context.go(Rotas.diy);
          },
        ),
      ],
    );

    // A foto e 960x1280 (retrato) e a caixa fica em ~2,5:1. Com cover, so
    // uma faixa horizontal sobra; alinhar acima do centro e o que mantem o
    // modulo no recorte em vez da mesa.
    const imagem = AtFoto(
      'modulo-verde.jpg',
      height: 260,
      radius: 26,
      alignment: Alignment(0, -0.3),
    );

    return _Secao(
      padding: const EdgeInsets.fromLTRB(24, 34, 24, 64),
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: AtColors.accent2_100,
          borderRadius: BorderRadius.circular(AtRadius.card),
        ),
        child: _estreito(context)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [texto, const SizedBox(height: 26), imagem],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: texto),
                  const SizedBox(width: 26),
                  const Expanded(child: imagem),
                ],
              ),
      ),
    );
  }
}
