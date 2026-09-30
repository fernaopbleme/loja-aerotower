import 'package:flutter_test/flutter_test.dart';

import 'package:aerotower_site/content/produtos.dart';
import 'package:aerotower_site/core/util/moeda.dart';
import 'package:aerotower_site/state/carrinho_store.dart';
import 'package:aerotower_site/state/loja_store.dart';

void main() {
  group('Precos.unitario', () {
    Produto porId(String id) => produtos.firstWhere((p) => p.id == id);

    test('modular soma o furo extra acima de 2', () {
      expect(Precos.unitario(porId('modular'), furos: 2), 89);
      expect(Precos.unitario(porId('modular'), furos: 3), 101);
      expect(Precos.unitario(porId('modular'), furos: 4), 113);
    });

    test('kits têm preço fechado', () {
      expect(Precos.unitario(porId('fullkit')), 649);
      expect(Precos.unitario(porId('pro')), 1190);
    });

    test('add-ons somam o acréscimo da bomba', () {
      expect(Precos.unitario(porId('addons'), bomba: 'baixa'), 279);
      expect(Precos.unitario(porId('addons'), bomba: 'media'), 319);
      expect(Precos.unitario(porId('addons'), bomba: 'alta'), 374);
    });
  });

  group('formatarMoeda', () {
    test('usa separador de milhar pt-BR', () {
      expect(formatarMoeda(1190), contains('1.190,00'));
      expect(formatarMoeda(101), contains('101,00'));
    });
  });

  group('LojaStore', () {
    test('sem filtro mostra os quatro produtos', () {
      expect(LojaStore().produtosFiltrados.length, 4);
    });

    test('filtra por categoria', () {
      final loja = LojaStore()..categoria = 'Kits completos';
      expect(loja.produtosFiltrados.map((p) => p.id), ['fullkit', 'pro']);
      expect(loja.tituloLista, 'Kits completos');
      expect(loja.contagem, '2 produtos');
    });

    test('busca no nome e no resumo, ignorando maiúsculas', () {
      final loja = LojaStore()..busca = 'RESERVATÓRIO';
      final ids = loja.produtosFiltrados.map((p) => p.id).toList();
      expect(ids, contains('addons'));
      expect(ids, contains('fullkit'));
      expect(ids, isNot(contains('modular')));
    });

    test('contagem no singular', () {
      final loja = LojaStore()..busca = 'HidroFullkit Pro';
      expect(loja.contagem, '1 produto');
    });

    test('busca sem resultado devolve lista vazia', () {
      expect((LojaStore()..busca = 'zzz').produtosFiltrados, isEmpty);
    });

    test('categoria e busca se combinam', () {
      // "condutividade" só aparece no resumo do Pro: é justamente o que
      // separa os dois kits, então serve de filtro dentro da categoria.
      final loja = LojaStore()
        ..categoria = 'Kits completos'
        ..busca = 'condutividade';
      expect(loja.produtosFiltrados.map((p) => p.id), ['pro']);
    });

    test('a busca é por substring, como no protótipo', () {
      // "pro" casa com "pronta" no resumo do Fullkit — barulhento, mas é
      // o comportamento do protótipo (includes), mantido de propósito.
      final loja = LojaStore()..busca = 'pro';
      expect(loja.produtosFiltrados.map((p) => p.id), contains('fullkit'));
    });

    test('filtro de furos predefine o configurador sem reduzir a grade', () {
      final loja = LojaStore();
      expect(loja.furos, 3);

      loja.selecionarFuroFiltro(4);
      expect(loja.furos, 4);
      expect(loja.produtosFiltrados.length, 4);

      loja.selecionarFuroFiltro(0);
      expect(loja.furos, 4, reason: 'Qualquer não redefine o configurador');
      expect(loja.produtosFiltrados.length, 4);
    });

    test('módulos ficam entre 1 e 12', () {
      final loja = LojaStore();
      for (var i = 0; i < 20; i++) {
        loja.aumentarModulos();
      }
      expect(loja.modulos, 12);
      for (var i = 0; i < 20; i++) {
        loja.diminuirModulos();
      }
      expect(loja.modulos, 1);
    });
  });

  group('CarrinhoStore', () {
    ItemCarrinho modular({String cor = 'Terracota', int furos = 3}) =>
        ItemCarrinho(
          id: 'modular',
          nome: 'HidroModular',
          cor: cor,
          furos: furos,
          precoUnitario: 101,
        );

    test('mesma configuração incrementa a linha', () {
      final carrinho = CarrinhoStore()
        ..adicionar(modular())
        ..adicionar(modular());

      expect(carrinho.itens.length, 1);
      expect(carrinho.itens.single.quantidade, 2);
      expect(carrinho.quantidadeTotal, 2);
    });

    test('cor diferente vira linha separada', () {
      final carrinho = CarrinhoStore()
        ..adicionar(modular())
        ..adicionar(modular(cor: 'Sálvia'));

      expect(carrinho.itens.length, 2);
      expect(carrinho.quantidadeTotal, 2);
    });

    test('furos diferentes viram linha separada', () {
      final carrinho = CarrinhoStore()
        ..adicionar(modular(furos: 2))
        ..adicionar(modular(furos: 4));

      expect(carrinho.itens.length, 2);
    });

    test('total da linha multiplica pela quantidade', () {
      final carrinho = CarrinhoStore()
        ..adicionar(modular())
        ..adicionar(modular());

      expect(carrinho.itens.single.total, 202);
    });

    test('remover apaga a linha inteira', () {
      final carrinho = CarrinhoStore()..adicionar(modular());
      carrinho.remover(carrinho.itens.single.chave);

      expect(carrinho.vazio, isTrue);
      expect(carrinho.quantidadeTotal, 0);
    });

    test('notifica os ouvintes ao adicionar', () {
      var avisos = 0;
      final carrinho = CarrinhoStore()..addListener(() => avisos++);
      carrinho.adicionar(modular());

      expect(avisos, 1);
    });
  });
}
