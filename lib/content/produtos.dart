// Catálogo, preços e opções — conteúdo editorial, fora dos widgets.
//
// Tudo aqui é provisório: o handoff diz que preços, fotos e disponibilidade
// passam a vir do backend. Trocar esta fonte não deve exigir mexer na UI.

class Produto {
  final String id;
  final String categoria;
  final String nome;
  final String kicker;
  final String slot;
  final String foto;
  final String resumo;
  final String descricao;
  final List<(String, String)> specs;

  /// Arquivo em assets/fotos/. Nulo onde ainda não há foto do protótipo —
  /// nesses casos o card mostra o espaço reservado, que é mais honesto do
  /// que ilustrar com a peça errada.
  final String? arquivo;

  /// Furos padrão usados para calcular o preço mostrado no card.
  final int? furos;

  /// "a partir de" nos configuráveis, vazio nos kits de preço fechado.
  final String prefixo;

  const Produto({
    required this.id,
    required this.categoria,
    required this.nome,
    required this.kicker,
    required this.slot,
    required this.foto,
    required this.resumo,
    required this.descricao,
    required this.specs,
    required this.prefixo,
    this.arquivo,
    this.furos,
  });
}

class Precos {
  /// Enquanto false, a loja mostra "—" no lugar do valor.
  ///
  /// O custo de produção ainda não foi fechado, e número inventado numa
  /// página de pré-lançamento vira expectativa que depois não se cumpre.
  /// Ao definir os preços, troque para true.
  static const definidos = false;

  static const modular = 89.0;
  static const furoExtra = 12.0;
  static const fullkit = 649.0;
  static const pro = 1190.0;
  static const addons = 279.0;

  static const bomba = <String, double>{
    'baixa': 0,
    'media': 40,
    'alta': 95,
  };

  /// Preço unitário conforme a configuração escolhida.
  static double unitario(
    Produto produto, {
    int? furos,
    String? bomba,
  }) {
    switch (produto.id) {
      case 'modular':
        return modular + ((furos ?? 2) - 2) * furoExtra;
      case 'fullkit':
        return fullkit;
      case 'pro':
        return pro;
      default:
        return addons + (Precos.bomba[bomba ?? 'media'] ?? 0);
    }
  }
}

class Bomba {
  final String id;
  final String label;

  const Bomba(this.id, this.label);
}

const bombas = <Bomba>[
  Bomba('baixa', 'Até 1,2 m — bomba 400 L/h'),
  Bomba('media', 'Até 2,0 m — bomba 800 L/h'),
  Bomba('alta', 'Acima de 2,0 m — bomba 1200 L/h'),
];

class CorModulo {
  final String nome;
  final int hex;

  const CorModulo(this.nome, this.hex);
}

const coresModulo = <CorModulo>[
  CorModulo('Terracota', 0xFFC67139),
  CorModulo('Sálvia', 0xFF7A8A5E),
  CorModulo('Areia', 0xFFEBDDC5),
  CorModulo('Grafite', 0xFF474238),
  CorModulo('Branco', 0xFFF9F4ED),
];

const categorias = <String>[
  'Todos',
  'HidroModular',
  'Kits completos',
  'Add-ons',
];

const produtos = <Produto>[
  Produto(
    id: 'modular',
    categoria: 'HidroModular',
    nome: 'HidroModular',
    kicker: 'Módulo avulso',
    slot: 'p-modular',
    foto: 'Foto do módulo',
    arquivo: 'modulo-terracota.jpg',
    resumo: 'O módulo que encaixa em outro e deixa a torre mais alta. '
        '5 cores, 2, 3 ou 4 furos.',
    descricao: 'Cada HidroModular encaixa no módulo de baixo por pressão, sem '
        'ferramenta. Empilhe quantos quiser: a água desce por gravidade e '
        'volta ao reservatório. Escolha a cor e a quantidade de furos '
        'conforme a planta — 2 furos para folhagens grandes, 4 para alfaces '
        'e ervas.',
    specs: [
      ('Material', 'PP virgem com proteção UV'),
      ('Altura por módulo', '32 cm'),
      ('Furos', '2, 3 ou 4 (Ø 55 mm)'),
      ('Cores', 'Terracota, sálvia, areia, grafite, branco'),
      ('Encaixe', 'Compatível com toda a linha AeroTower'),
    ],
    furos: 3,
    prefixo: 'a partir de',
  ),
  Produto(
    id: 'fullkit',
    categoria: 'Kits completos',
    nome: 'HidroFullkit',
    kicker: 'Kit completo',
    slot: 'p-fullkit',
    foto: 'Foto do kit',
    arquivo: 'modulos-empilhados.jpg',
    resumo: 'Torre pronta para começar, com sensor de nível de água. '
        'Você acompanha o reservatório pelo app.',
    descricao: 'O kit para quem quer plantar no mesmo dia. Vem com módulos '
        'empilháveis, base, reservatório, bomba, mangueira e o manual de '
        'nutrientes. O sensor ultrassônico mede o nível do reservatório e '
        'avisa pelo app quando está na hora de completar. Tudo compatível '
        'com módulos extras comprados depois.',
    specs: [
      ('Conteúdo', '4 módulos + base + reservatório + bomba + mangueira'),
      ('Sensores', 'ultrassônico (nível de água)'),
      ('Monitoramento', 'nível do reservatório pelo app'),
      ('Altura montada', '≈ 1,4 m'),
      ('Plantas', 'até 12'),
      ('Reservatório', '30 L'),
    ],
    prefixo: '',
  ),
  Produto(
    id: 'pro',
    categoria: 'Kits completos',
    nome: 'HidroFullkit Pro',
    kicker: 'Kit profissional',
    slot: 'p-pro',
    foto: 'Foto do kit Pro',
    arquivo: 'modulos-preto.jpg',
    resumo: 'Todos os sensores: pH, condutividade, temperatura, umidade e '
        'nível. É a torre que se monitora sozinha.',
    descricao: 'Mesma lógica do Fullkit em escala comercial: mais módulos, '
        'bomba de maior vazão, reservatório de 60 L e temporizador de ciclo. '
        'A diferença que importa está nos sensores: enquanto o Fullkit mede '
        'só o nível de água, o Pro acompanha pH, condutividade, temperatura '
        'e umidade — e avisa antes de a planta dar sinal.',
    specs: [
      ('Conteúdo',
          '7 módulos + base reforçada + reservatório 60 L + bomba 1200 L/h'),
      ('Sensores', 'pH, condutividade (EC), temperatura, umidade e nível'),
      ('Monitoramento', 'todas as grandezas pelo app, com alertas'),
      ('Altura montada', '≈ 2,3 m'),
      ('Plantas', 'até 24'),
      ('Extra', 'Temporizador de ciclo liga/desliga'),
    ],
    prefixo: '',
  ),
  Produto(
    id: 'addons',
    categoria: 'Add-ons',
    nome: 'Kit Add-ons',
    kicker: 'Bomba + mangueira + reservatório',
    slot: 'p-addons',
    foto: 'Foto do kit add-ons',
    resumo: 'Bomba escolhida pela altura da torre, mangueira e reservatório.',
    descricao: 'O conjunto hidráulico avulso, para quem já tem módulos ou vai '
        'crescer. A bomba muda conforme a altura planejada; mangueira e '
        'reservatório acompanham.',
    specs: [
      ('Bomba', '400, 800 ou 1200 L/h'),
      ('Mangueira', '4 m · Ø 8 mm'),
      ('Reservatório', '30 L com tampa'),
      ('Indicado para', 'Torres de 1 a 3 m'),
    ],
    prefixo: 'a partir de',
  ),
];
