// Guia do "faça você mesmo" — conteúdo editorial, fora dos widgets.
//
// O texto é do dono do projeto, que montou a torre à mão antes de existir
// o AeroTower. Fica aqui, em texto puro, para ele poder reescrever sem
// abrir código de interface.
//
// Hoje existe UM guia. Os quatro anteriores eram rascunho meu, de
// marcador, e saíram — não se publica guia de montagem que ninguém montou.
// A lista continua sendo lista: ao entrar um segundo guia, a página volta
// a mostrar o índice sozinha (ver DiyPage).

/// Ilustração de uma seção. `vetor` escolhe entre SvgPicture e Image, que
/// são widgets diferentes no Flutter.
class Figura {
  /// Arquivo em assets/diy/.
  final String arquivo;

  /// Texto alternativo — vira legenda e rótulo de acessibilidade. Veio
  /// escrito no material original; não inventar nem resumir.
  final String alt;

  final bool vetor;

  /// Largura dividida pela altura, tirada do viewBox do SVG. Explicito
  /// porque o Dart nao abre o arquivo para descobrir: sem isto, o esquema
  /// em retrato (520x640) esticaria para ~760px de altura na coluna de
  /// texto e empurraria o resto do artigo para fora da tela.
  final double aspecto;

  const Figura({
    required this.arquivo,
    required this.alt,
    this.vetor = true,
    this.aspecto = 1,
  });
}

class SecaoGuia {
  final String titulo;
  final String texto;

  /// Entra depois do texto, quando a etapa é mais fácil de ver que de ler.
  final Figura? figura;

  const SecaoGuia({
    required this.titulo,
    required this.texto,
    this.figura,
  });
}

/// Um destaque do bloco "dicas de quem já montou": frase curta em negrito
/// e a explicação.
class Dica {
  final String titulo;
  final String texto;

  const Dica({required this.titulo, required this.texto});
}

class Guia {
  final String id;
  final String titulo;
  final String nivel;
  final String duracao;

  /// Uma frase, usada no card do índice e abaixo do título do artigo.
  final String resumo;

  /// Abre o artigo: por que esta página existe.
  final String intro;

  /// Foto de destaque, no topo.
  final Figura capa;

  /// "A ideia em uma frase" — o resumo do funcionamento, com o esquema.
  final SecaoGuia ideia;

  final List<String> materiais;

  /// As etapas numeradas.
  final List<SecaoGuia> secoes;

  final List<Dica> dicas;

  /// Fecha o artigo ligando o faça-você-mesmo ao produto.
  final SecaoGuia fecho;

  const Guia({
    required this.id,
    required this.titulo,
    required this.nivel,
    required this.duracao,
    required this.resumo,
    required this.intro,
    required this.capa,
    required this.ideia,
    required this.materiais,
    required this.secoes,
    required this.dicas,
    required this.fecho,
  });

  String get etiqueta => '$nivel · $duracao';
}

const guias = <Guia>[
  Guia(
    id: 'torre-caseira',
    titulo: 'Faça você mesmo: sua torre hidropônica caseira',
    nivel: 'Iniciante',
    duracao: 'Um fim de semana',
    resumo: 'Cultive em casa sem terra, com peças de loja de material de '
        'construção e um fim de semana livre.',
    intro: 'Antes de existir o AeroTower, existiu uma torre montada à mão, '
        'com tubo de PVC, algumas curvas e muita tentativa e erro. Esta '
        'página conta como ela funciona e o caminho geral para você montar '
        'a sua. Não é um manual milimétrico: é um ponto de partida para '
        'quem quer entender a lógica do sistema e adaptar ao próprio '
        'espaço.',
    capa: Figura(
      arquivo: 'diy-materiais.jpg',
      aspecto: 447 / 596,
      alt: 'Materiais usados na montagem: tubo de PVC furado, curvas de '
          '45°, serra, temporizador de tomada e acessórios',
      vetor: false,
    ),
    ideia: SecaoGuia(
      titulo: 'A ideia em uma frase',
      texto: 'Um tubo em pé, com plantas encaixadas nas laterais, recebe '
          'uma "chuva" de água com nutrientes no topo. A água escorre por '
          'dentro, molha as raízes, volta para um balde na base e é '
          'bombeada de novo. Sem terra, sem desperdício, ocupando o espaço '
          'de um balde.',
      figura: Figura(
        arquivo: 'diy-visao-geral.svg',
        aspecto: 520 / 640,
        alt: 'Esquema geral da torre: distribuidor no topo, tubo com curvas '
            'e mudas, balde com solução e bomba',
      ),
    ),
    materiais: [
      'Tubo de PVC branco (o branco esquenta menos ao sol e protege as '
          'raízes)',
      'Curvas de PVC de 45°, uma para cada planta',
      'Um balde que servirá de reservatório',
      'Bomba pequena de aquário e mangueira opaca (a transparente favorece '
          'algas)',
      'Um vaso plástico para virar o distribuidor de água no topo',
      'Temporizador de tomada, para a bomba ligar e desligar sozinha',
      'Cola para PVC, silicone, serra, furadeira e broca',
      'Solução nutritiva para hidroponia e mudas de folhosas ou ervas',
    ],
    secoes: [
      SecaoGuia(
        titulo: 'Planeje pela luz',
        texto: 'Observe onde a torre vai ficar. Se recebe luz de todos os '
            'lados, dá para furar o tubo em quatro fileiras. Encostada numa '
            'parede, três fileiras bastam; o lado sem sol produz plantas '
            'fracas.',
      ),
      SecaoGuia(
        titulo: 'Fure de forma escalonada',
        texto: 'Distribua os furos em fileiras verticais e alterne a altura '
            'entre elas. Assim, cada planta recebe luz sem ficar na sombra '
            'da vizinha de cima.',
        figura: Figura(
          arquivo: 'diy-furacao.svg',
        aspecto: 560 / 420,
          alt: 'Tubo planificado mostrando fileiras de furos alternados',
        ),
      ),
      SecaoGuia(
        titulo: 'Encaixe as curvas',
        texto: 'Cada furo recebe uma curva de 45°, que vira o "vasinho" da '
            'planta. Furos justos seguram melhor as peças. Se as curvas se '
            'encontrarem por dentro do tubo, apare a ponta interna para não '
            'bloquear a passagem da água.',
      ),
      SecaoGuia(
        titulo: 'Prepare a base e o topo',
        texto: 'O tubo fica apoiado dentro do balde, firme e bem vedado. No '
            'topo, um vaso com pequenos furos funciona como chuveiro, '
            'espalhando a água em gotas sobre as raízes.',
      ),
      SecaoGuia(
        titulo: 'Ligue a água',
        texto: 'A bomba, dentro do balde, leva a solução até o topo pela '
            'mangueira. O temporizador cuida dos ciclos de irrigação. '
            'Ligue, observe a água descendo e ajuste até todas as raízes '
            'ficarem úmidas.',
        figura: Figura(
          arquivo: 'diy-ciclo-agua.svg',
        aspecto: 560 / 300,
          alt: 'Ciclo da água: reservatório, bomba, distribuidor, raízes e '
              'retorno ao balde',
        ),
      ),
      SecaoGuia(
        titulo: 'Plante e acompanhe',
        texto: 'Coloque as mudas nas curvas, dê um apoio ao caule até as '
            'raízes firmarem e acompanhe a solução nutritiva de perto. Duas '
            'medidas importam mais: o pH, que deve ficar levemente ácido, e '
            'a condutividade (EC), que indica a concentração de nutrientes. '
            'Com o tempo, as plantas consomem nutrientes e esses valores '
            'mudam.',
      ),
    ],
    dicas: [
      Dica(
        titulo: 'Branco por fora, escuro por dentro',
        texto: 'tubo claro para não aquecer, mangueira opaca para não criar '
            'algas.',
      ),
      Dica(
        titulo: 'Proteja os furos do topo',
        texto: 'com uma tela fina; folhas e sujeira entopem o sistema.',
      ),
      Dica(
        titulo: 'Crie uma saída de emergência',
        texto: 'no distribuidor, para a água não transbordar se algo '
            'entupir.',
      ),
      Dica(
        titulo: 'Comece com ervas e folhosas',
        texto: 'como manjericão e alface: elas se adaptam muito bem.',
      ),
    ],
    fecho: SecaoGuia(
      titulo: 'E depois do "faça você mesmo"?',
      texto: 'Montar a torre é a parte divertida. Medir pH, conferir a '
          'condutividade e lembrar do nível da água toda semana é a parte '
          'que cansa. Foi exatamente dessa rotina que nasceu o AeroTower: a '
          'mesma ideia de cultivo vertical, agora com sensores que '
          'acompanham a solução e avisam quando algo sai do ideal.',
    ),
  ),
];

Guia? guiaPorId(String id) {
  for (final g in guias) {
    if (g.id == id) return g;
  }
  return null;
}
