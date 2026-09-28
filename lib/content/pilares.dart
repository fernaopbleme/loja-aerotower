/// Conteúdo editorial da início — texto do proprietário, fora dos widgets.
class Pilar {
  final String numero;
  final String titulo;
  final String texto;

  const Pilar({
    required this.numero,
    required this.titulo,
    required this.texto,
  });
}

const pilares = <Pilar>[
  Pilar(
    numero: '01',
    titulo: 'Modular de verdade',
    texto: 'Um módulo encaixa no outro por pressão. A torre cresce quando você '
        'precisa, sem trocar o que já comprou.',
  ),
  Pilar(
    numero: '02',
    titulo: 'Pouca água, muita colheita',
    texto: 'A água circula em ciclo fechado e volta ao reservatório: gasta '
        'menos que um canteiro e ocupa o espaço de um vaso.',
  ),
  Pilar(
    numero: '03',
    titulo: 'Do hobby à venda',
    texto: 'A mesma peça serve para três alfaces na varanda e para uma '
        'produção pequena de ervas.',
  ),
];
