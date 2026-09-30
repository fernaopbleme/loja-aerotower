// Guias do "faça você mesmo" — conteúdo editorial, fora dos widgets.
//
// São textos que o dono do projeto vai reescrever com a experiência dele.
// Por isso ficam aqui, em texto puro, e não espalhados pela interface.

class SecaoGuia {
  final String titulo;
  final String texto;

  const SecaoGuia({required this.titulo, required this.texto});
}

class Guia {
  final String id;
  final String titulo;
  final String nivel;
  final String duracao;
  final String resumo;

  /// Arquivo em assets/fotos/. Nulo onde ainda não há foto — o card mostra
  /// o espaço reservado, que é mais honesto que ilustrar com outra coisa.
  final String? capa;

  /// Descrição da foto que falta, usada no espaço reservado.
  final String descricaoCapa;

  final List<String> materiais;
  final List<SecaoGuia> secoes;

  const Guia({
    required this.id,
    required this.titulo,
    required this.nivel,
    required this.duracao,
    required this.resumo,
    required this.descricaoCapa,
    required this.materiais,
    required this.secoes,
    this.capa,
  });

  String get etiqueta => '$nivel · $duracao';
}

const guias = <Guia>[
  Guia(
    id: 'garrafa',
    titulo: 'Torre de garrafa PET',
    nivel: 'Iniciante',
    duracao: '1 tarde',
    resumo: 'A montagem mais barata possível: seis garrafas, um balde e uma '
        'bomba de aquário.',
    descricaoCapa: 'Torre de garrafas montada',
    materiais: [
      '6 garrafas PET de 2 L limpas',
      'Balde ou bombona de 20 L',
      'Bomba de aquário 400 L/h',
      '3 m de mangueira de 8 mm',
      'Estilete e furador aquecido',
      'Substrato de argila expandida',
    ],
    secoes: [
      SecaoGuia(
        titulo: 'Cortando as garrafas',
        texto: 'Corte cada garrafa a dois terços da altura e faça a boca '
            'virada para baixo, encaixando uma na outra. O furo lateral '
            'recebe a muda e precisa ser um pouco menor que o copo de '
            'plantio, para segurar sem apertar a raiz.',
      ),
      SecaoGuia(
        titulo: 'Empilhando e vedando',
        texto: 'Empilhe as garrafas alinhando os furos em espiral, para que '
            'nenhuma folha faça sombra na de baixo. Vede as juntas com fita '
            'de silicone: a água precisa descer por dentro, nunca escorrer '
            'pela parede externa.',
      ),
      SecaoGuia(
        titulo: 'Circulação e ciclo',
        texto: 'A bomba manda a água até o topo pela mangueira e a gravidade '
            'faz o resto. Comece com quinze minutos ligada a cada duas horas '
            'e observe: substrato encharcado pede menos tempo, planta murcha '
            'ao meio-dia pede mais.',
      ),
    ],
  ),
  Guia(
    id: 'cano',
    titulo: 'Torre de cano de PVC 100 mm',
    nivel: 'Intermediário',
    duracao: 'Um fim de semana',
    resumo: 'Mais firme e mais durável, com furos feitos com serra copo e '
        'base de bombona. É a que montamos aqui — as fotos são dela.',
    capa: 'diy-torre-manjericao.jpg',
    descricaoCapa: 'Cano de PVC com furos de plantio',
    materiais: [
      '2 m de cano PVC 100 mm',
      'Tampa e joelho de 100 mm',
      'Serra copo de 55 mm',
      'Bombona de 50 L',
      'Bomba 800 L/h',
      'Temporizador de tomada',
      'Copos de plantio e argila expandida',
    ],
    secoes: [
      SecaoGuia(
        titulo: 'Marcando os furos',
        texto: 'Marque os furos em espiral, com vinte centímetros entre eles, '
            'girando 90° a cada furo. Fure com a serra copo em rotação '
            'baixa: PVC aquecido lasca e a borda irregular machuca a raiz.',
      ),
      SecaoGuia(
        titulo: 'Base e retorno',
        texto: 'A bombona serve de base e reservatório. O cano entra nela '
            'pela tampa, e o joelho na parte de baixo devolve a água ao '
            'reservatório sem respingar — é o que evita alga e mosquito.',
      ),
      SecaoGuia(
        titulo: 'Nutrição',
        texto: 'Use solução A+B para hortaliças na diluição do rótulo e '
            'confira a condutividade uma vez por semana. Troque a solução '
            'inteira a cada quinze dias e lave o reservatório com água '
            'corrente antes de repor.',
      ),
    ],
  ),
  Guia(
    id: 'nft',
    titulo: 'Bancada NFT com calha',
    nivel: 'Intermediário',
    duracao: '2 dias',
    resumo: 'Fluxo laminar em calha de telhado — ideal para alface em '
        'quantidade e pouca altura.',
    descricaoCapa: 'Bancada de calhas inclinadas',
    materiais: [
      '3 calhas de PVC de 3 m',
      'Cavaletes de madeira',
      'Bomba 800 L/h com temporizador',
      'Mangueira e conectores T',
      'Reservatório 60 L',
    ],
    secoes: [
      SecaoGuia(
        titulo: 'Inclinação certa',
        texto: 'A calha precisa de 2% de inclinação: dois centímetros de '
            'queda por metro. Menos que isso a água empoça e apodrece a '
            'raiz, mais que isso ela corre rápido demais e a planta não bebe.',
      ),
      SecaoGuia(
        titulo: 'Lâmina de água',
        texto: 'O fluxo ideal forma uma lâmina de poucos milímetros no fundo '
            'da calha, o suficiente para molhar a ponta da raiz e deixar o '
            'resto no ar. Regule na saída da bomba, não estrangulando a '
            'mangueira.',
      ),
      SecaoGuia(
        titulo: 'Prevenindo a parada',
        texto: 'Num sistema NFT a planta murcha em poucas horas se a bomba '
            'para. Deixe um reservatório fundo, uma bomba de reserva e, se '
            'puder, um nobreak pequeno para a bomba.',
      ),
    ],
  ),
  Guia(
    id: 'nutrientes',
    titulo: 'Solução nutritiva sem mistério',
    nivel: 'Leitura',
    duracao: '15 min',
    resumo: 'O que medir, com que frequência e como corrigir quando a folha '
        'avisa que algo está errado.',
    descricaoCapa: 'Baldes e medidores de solução',
    materiais: [
      'Solução A + B para hortaliças',
      'Medidor de pH',
      'Medidor de condutividade (TDS)',
      'Regulador de pH para baixo',
      'Copo medidor de 1 L',
    ],
    secoes: [
      SecaoGuia(
        titulo: 'pH antes de tudo',
        texto: 'Mantenha o pH entre 5,5 e 6,5. Fora dessa faixa a planta '
            'simplesmente não absorve o que está na água, mesmo com a '
            'solução perfeita — folha amarela com reservatório cheio quase '
            'sempre é pH, não falta de adubo.',
      ),
      SecaoGuia(
        titulo: 'Condutividade por fase',
        texto: 'Muda pede solução fraca, planta adulta pede mais '
            'concentrada: comece perto de 800 e vá subindo até cerca de '
            '1400 conforme ela cresce. Se a folha queimar na borda, você '
            'passou do ponto.',
      ),
      SecaoGuia(
        titulo: 'Rotina semanal',
        texto: 'Complete o nível com água pura no meio da semana, meça pH e '
            'condutividade, e troque tudo a cada quinze dias. Anote os '
            'números: em um mês você enxerga o padrão da sua casa e para de '
            'chutar.',
      ),
    ],
  ),
];

Guia? guiaPorId(String id) {
  for (final g in guias) {
    if (g.id == id) return g;
  }
  return null;
}
