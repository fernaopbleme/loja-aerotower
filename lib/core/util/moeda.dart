import 'package:intl/intl.dart';

/// Formato pt-BR: R$ 1.234,56.
/// O protótipo só trocava o ponto por vírgula e perdia o separador de
/// milhar; o handoff pede intl.
final _formato = NumberFormat.currency(
  locale: 'pt_BR',
  symbol: r'R$',
  decimalDigits: 2,
);

String formatarMoeda(double valor) => _formato.format(valor);
