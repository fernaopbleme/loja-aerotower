// Conteúdo da página inicial, tirado do pitch (AeroTower_Pitch_v7_1).
//
// Texto separado dos widgets de propósito: é o que mais muda, e quem
// escreve não precisa abrir código de interface para mexer.

class Passo {
  final String numero;
  final String titulo;
  final String texto;

  const Passo({
    required this.numero,
    required this.titulo,
    required this.texto,
  });
}

/// "Da raiz ao seu celular" — os quatro passos. É o que explica por que a
/// torre é diferente de um vaso com sensor.
///
/// O texto fala em circuito fechado, e não em névoa: hoje a solução é
/// bombeada e volta por gravidade — hidroponia. Os atomizadores (que
/// tornariam o sistema aeropônico) são o passo seguinte do projeto, e
/// aparecem na página como plano, não como recurso existente.
const comoFunciona = <Passo>[
  Passo(
    numero: '01',
    titulo: 'Raízes suspensas',
    texto: 'Sem solo: a raiz fica no ar, dentro da coluna, e respira o '
        'tempo todo.',
  ),
  Passo(
    numero: '02',
    titulo: 'Solução em circuito fechado',
    texto: 'A bomba leva a solução ao topo e a gravidade devolve tudo ao '
        'reservatório. Nada se perde pelo caminho.',
  ),
  Passo(
    numero: '03',
    titulo: 'Sensores + ESP32',
    texto: 'pH, condutividade, temperatura e umidade medidos direto no '
        'reservatório e publicados por MQTT.',
  ),
  Passo(
    numero: '04',
    titulo: 'O app te avisa',
    texto: 'Quando algo sai do ideal, você recebe o alerta — em vez de '
        'descobrir pela folha amarela.',
  ),
];

class Personalidade {
  final String nome;
  final String descricao;
  final int cor;
  final String? foto;

  const Personalidade({
    required this.nome,
    required this.descricao,
    required this.cor,
    this.foto,
  });
}

/// "Uma torre, quatro personalidades" — as cores que já imprimimos.
const personalidades = <Personalidade>[
  Personalidade(
    nome: 'Terracota',
    descricao: 'orgânica',
    cor: 0xFFC67139,
    foto: 'modulo-terracota.jpg',
  ),
  Personalidade(
    nome: 'Verde',
    descricao: 'futurista',
    cor: 0xFF1F6B5C,
    foto: 'modulo-verde.jpg',
  ),
  Personalidade(
    nome: 'Preta',
    descricao: 'industrial',
    cor: 0xFF2E2B25,
    foto: 'modulos-preto.jpg',
  ),
  Personalidade(
    nome: 'Areia',
    descricao: 'minimalista',
    cor: 0xFFEBDDC5,
    foto: 'modulo-frente.jpg',
  ),
];

/// Números do pitch que sustentam o problema. Cada um com a fonte, porque
/// dado sem fonte em página de produto não convence ninguém.
class Evidencia {
  final String numero;
  final String descricao;
  final String fonte;

  const Evidencia({
    required this.numero,
    required this.descricao,
    required this.fonte,
  });
}

const evidencias = <Evidencia>[
  Evidencia(
    numero: '11 mi',
    descricao: 'domicílios em apartamento no Brasil',
    fonte: 'IBGE, Censo 2022',
  ),
  Evidencia(
    numero: '~30%',
    descricao: 'dos alimentos se perdem na cadeia até chegar em você',
    fonte: 'FAO',
  ),
  Evidencia(
    numero: '90%',
    descricao: 'menos água que o cultivo em solo',
    fonte: 'circuito fechado, sem perda por infiltração',
  ),
];
