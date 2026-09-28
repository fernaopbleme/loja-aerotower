import 'package:flutter/foundation.dart';

/// Uma linha do carrinho. A chave composta `id|cor|furos|bomba` decide
/// se um item novo vira linha própria ou incrementa uma existente.
@immutable
class ItemCarrinho {
  final String id;
  final String nome;
  final String? cor;
  final int? furos;
  final String? bomba;
  final double precoUnitario;
  final int quantidade;

  const ItemCarrinho({
    required this.id,
    required this.nome,
    required this.precoUnitario,
    this.cor,
    this.furos,
    this.bomba,
    this.quantidade = 1,
  });

  String get chave => '$id|${cor ?? ''}|${furos ?? ''}|${bomba ?? ''}';

  double get total => precoUnitario * quantidade;

  ItemCarrinho copyWith({int? quantidade}) => ItemCarrinho(
        id: id,
        nome: nome,
        cor: cor,
        furos: furos,
        bomba: bomba,
        precoUnitario: precoUnitario,
        quantidade: quantidade ?? this.quantidade,
      );
}

class CarrinhoStore extends ChangeNotifier {
  final List<ItemCarrinho> _itens = [];

  List<ItemCarrinho> get itens => List.unmodifiable(_itens);

  int get quantidadeTotal =>
      _itens.fold(0, (soma, item) => soma + item.quantidade);

  bool get vazio => _itens.isEmpty;

  void adicionar(ItemCarrinho item) {
    final indice = _itens.indexWhere((i) => i.chave == item.chave);
    if (indice >= 0) {
      final atual = _itens[indice];
      _itens[indice] =
          atual.copyWith(quantidade: atual.quantidade + item.quantidade);
    } else {
      _itens.add(item);
    }
    notifyListeners();
  }

  void remover(String chave) {
    _itens.removeWhere((i) => i.chave == chave);
    notifyListeners();
  }

  void limpar() {
    _itens.clear();
    notifyListeners();
  }
}
