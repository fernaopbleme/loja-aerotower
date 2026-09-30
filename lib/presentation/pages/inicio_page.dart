import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../content/home.dart';
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
        _Evidencias(),
        _ComoFunciona(),
        _DaTorreAoPrato(),
        _Personalidades(),
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

// ─────────────────────────────────────────────────────────
class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final analytics = context.read<AnalyticsService>();

    final texto = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const AtTag('Protótipo funcionando'),
        const SizedBox(height: 14),
        Text(
          'E se a sua horta tivesse uma coluna vertebral?',
          style: AtText.heading(44),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Text(
            'Cultivo hidropônico vertical, modular e conectado — feito para '
            'apartamento. A horta que pensa, rega e te avisa.',
            style: AtText.body(17, color: AtColors.neutral800),
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            AtButton(
              'Ver a torre',
              onPressed: () {
                analytics.registrar(Eventos.verProdutos, pagina: Rotas.inicio);
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
              ? 'O pitch completo: o problema, o protótipo e onde queremos '
                  'chegar.'
              : 'Espaço reservado para o vídeo do pitch.',
          style: AtText.body(12, color: AtColors.neutral700, height: 1.5),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
/// O problema em números. Vem logo depois do hero porque é o que justifica
/// a torre existir — sem isso a página é só um produto bonito.
class _Evidencias extends StatelessWidget {
  const _Evidencias();

  @override
  Widget build(BuildContext context) {
    return _Secao(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Morar na cidade nos afastou da nossa própria comida',
            style: AtText.heading(28),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(
              'Queremos comer fresco e saber a origem do que comemos. Mas no '
              'apartamento faltam espaço, tempo e técnica para plantar.',
              style: AtText.body(16, color: AtColors.neutral800),
            ),
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = 18.0;
              final colunas = ((constraints.maxWidth + gap) / (240 + gap))
                  .floor()
                  .clamp(1, 3);
              final largura =
                  (constraints.maxWidth - gap * (colunas - 1)) / colunas;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final e in evidencias)
                    SizedBox(width: largura, child: _CardEvidencia(e)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CardEvidencia extends StatelessWidget {
  final Evidencia evidencia;

  const _CardEvidencia(this.evidencia);

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
          Text(evidencia.numero, style: AtText.heading(34)),
          const SizedBox(height: 8),
          Text(
            evidencia.descricao,
            style: AtText.body(14, color: AtColors.neutral800),
          ),
          const SizedBox(height: 10),
          Text(
            evidencia.fonte,
            style: AtText.body(11, color: AtColors.neutral600),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
/// "Da raiz ao seu celular": os quatro passos. É a seção que explica a
/// tecnologia sem jargão.
class _ComoFunciona extends StatelessWidget {
  const _ComoFunciona();

  @override
  Widget build(BuildContext context) {
    return _Secao(
      padding: const EdgeInsets.fromLTRB(24, 44, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AtTag('Como funciona', variant: AtTagVariant.accent2),
          const SizedBox(height: 12),
          Text('Da raiz ao seu celular', style: AtText.h2),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = 18.0;
              final colunas = ((constraints.maxWidth + gap) / (250 + gap))
                  .floor()
                  .clamp(1, 4);
              final largura =
                  (constraints.maxWidth - gap * (colunas - 1)) / colunas;

              final linhas = <List<Passo>>[];
              for (var i = 0; i < comoFunciona.length; i += colunas) {
                linhas.add(comoFunciona.sublist(
                    i, (i + colunas).clamp(0, comoFunciona.length)));
              }

              return Column(
                children: [
                  for (final linha in linhas)
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: linha == linhas.last ? 0 : gap),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (var i = 0; i < linha.length; i++) ...[
                              if (i > 0) const SizedBox(width: gap),
                              SizedBox(
                                width: largura,
                                child: _CardPasso(linha[i]),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          // Roadmap, dito como roadmap. Vender atomizador que ainda nao
          // existe seria promessa que o prototipo nao cumpre.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 3),
                child: AtIcon(AtIcons.play,
                    size: 13, color: AtColors.neutral600),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Próximo passo do projeto: trocar a bomba por atomizadores '
                  '— menos barulho dentro de casa, e menos água ainda.',
                  style:
                      AtText.body(13, color: AtColors.neutral700, height: 1.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardPasso extends StatelessWidget {
  final Passo passo;

  const _CardPasso(this.passo);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AtColors.accent2_100,
        borderRadius: BorderRadius.circular(AtRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AtColors.accent2_200,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                passo.numero,
                style: AtText.heading(16, color: AtColors.accent2_800),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(passo.titulo,
              style: AtText.heading(18, color: AtColors.accent2_800)),
          const SizedBox(height: 8),
          Text(
            passo.texto,
            style: AtText.body(14, color: AtColors.accent2_800),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
/// A prova. O manjericão da foto cresceu na torre e foi comido — é o
/// argumento mais forte da página, e o único que nenhum concorrente
/// consegue copiar com render.
class _DaTorreAoPrato extends StatelessWidget {
  const _DaTorreAoPrato();

  @override
  Widget build(BuildContext context) {
    final estreito = _estreito(context);

    final texto = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const AtTag('Validação'),
        const SizedBox(height: 12),
        Text('Da torre ao prato', style: AtText.heading(32)),
        const SizedBox(height: 10),
        Text(
          'Não é protótipo de vitrine: já colhemos e comemos o que a torre '
          'produziu. O manjericão da foto cresceu sem uma grama de terra, '
          'num cano de PVC, na varanda.',
          style: AtText.body(16, color: AtColors.neutral800),
        ),
        const SizedBox(height: 16),
        const _Marcador('Cresceu na torre — sem solo'),
        const _Marcador('Colhido em casa, fresco, no dia'),
        const _Marcador('Foi direto para a refeição'),
      ],
    );

    const foto = AtFoto(
      'diy-torre-manjericao.jpg',
      height: 320,
      radius: AtRadius.lg,
      alignment: Alignment.center,
    );

    return _Secao(
      padding: const EdgeInsets.fromLTRB(24, 44, 24, 0),
      child: estreito
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [texto, const SizedBox(height: 24), foto],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 95, child: texto),
                const SizedBox(width: 30),
                const Expanded(flex: 105, child: foto),
              ],
            ),
    );
  }
}

class _Marcador extends StatelessWidget {
  final String texto;

  const _Marcador(this.texto);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 3),
            child:
                AtIcon(AtIcons.check, size: 15, color: AtColors.accent2_700),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(texto, style: AtText.body(14)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
/// "Uma torre, quatro personalidades". Usa as peças que já foram
/// impressas — cada cor é uma foto real, não uma amostra de tinta.
class _Personalidades extends StatelessWidget {
  const _Personalidades();

  @override
  Widget build(BuildContext context) {
    return _Secao(
      padding: const EdgeInsets.fromLTRB(24, 44, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AtTag('Design'),
          const SizedBox(height: 12),
          Text('Uma torre, quatro personalidades', style: AtText.h2),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              'A torre fica na sala, não no quintal. Então ela combina com o '
              'ambiente — e não o contrário.',
              style: AtText.body(15, color: AtColors.neutral800),
            ),
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = 18.0;
              final colunas = ((constraints.maxWidth + gap) / (230 + gap))
                  .floor()
                  .clamp(1, 4);
              final largura =
                  (constraints.maxWidth - gap * (colunas - 1)) / colunas;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final p in personalidades)
                    SizedBox(width: largura, child: _CardCor(p)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CardCor extends StatelessWidget {
  final Personalidade personalidade;

  const _CardCor(this.personalidade);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (personalidade.foto != null)
          AtFoto(personalidade.foto!, height: 190, radius: 20)
        else
          Container(
            height: 190,
            decoration: BoxDecoration(
              color: Color(personalidade.cor),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Color(personalidade.cor),
                shape: BoxShape.circle,
                border: Border.all(color: AtColors.divider),
              ),
            ),
            const SizedBox(width: 8),
            Text(personalidade.nome, style: AtText.heading(17)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          personalidade.descricao,
          style: AtText.body(13, color: AtColors.neutral700),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
class _BandaInteresse extends StatelessWidget {
  const _BandaInteresse();

  @override
  Widget build(BuildContext context) {
    final estreito = _estreito(context);

    final texto = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
      padding: const EdgeInsets.fromLTRB(24, 44, 24, 0),
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

// ─────────────────────────────────────────────────────────
/// Fecha a página com o propósito do pitch: "hidroponia para todos" —
/// ensinar a montar com material do dia a dia.
class _BandaDiy extends StatelessWidget {
  const _BandaDiy();

  @override
  Widget build(BuildContext context) {
    final estreito = _estreito(context);

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
          'Nosso propósito não é só vender torre: é levar comida fresca — e '
          'o poder de cultivá-la — a mais gente. Os guias ensinam a montar '
          'com cano, garrafa e bomba de aquário, de graça.',
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

    const imagem = AtFoto(
      'diy-cano-furos.jpg',
      height: 260,
      radius: 26,
      alignment: Alignment.center,
    );

    return _Secao(
      padding: const EdgeInsets.fromLTRB(24, 44, 24, 64),
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: AtColors.accent2_100,
          borderRadius: BorderRadius.circular(AtRadius.card),
        ),
        child: estreito
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
