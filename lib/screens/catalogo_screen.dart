import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../widgets/produto_card.dart';
import 'detalhes_produto_screen.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  final List<Produto> _produtos = [
    const Produto(id: '1', nome: 'Smartphone Galaxy S24', preco: 4500.00, categoria: 'Eletrônicos', icone: '📱'),
    const Produto(id: '2', nome: 'Notebook Dell XPS', preco: 8900.00, categoria: 'Informática', icone: '💻'),
    const Produto(id: '3', nome: 'Fone Bluetooth Sony', preco: 1200.00, categoria: 'Áudio', icone: '🎧'),
    const Produto(id: '4', nome: 'Smartwatch Garmin', preco: 2300.00, categoria: 'Wearables', icone: '⌚'),
    const Produto(id: '5', nome: 'Teclado Mecânico RGB', preco: 450.00, categoria: 'Periféricos', icone: '⌨️'),
  ];

  int _contadorNovos = 1;

  void _adicionarProduto() {
    setState(() {
      final novoId = DateTime.now().millisecondsSinceEpoch.toString();
      final novosExemplos = [
        Produto(
          id: novoId,
          nome: 'Mouse Sem Fio Gamer #$_contadorNovos',
          preco: 250.00 + (_contadorNovos * 15),
          categoria: 'Periféricos',
          icone: '🖱️',
        ),
        Produto(
          id: novoId,
          nome: 'Monitor UltraWide 29" #$_contadorNovos',
          preco: 1450.00 + (_contadorNovos * 20),
          categoria: 'Monitores',
          icone: '🖥️',
        ),
        Produto(
          id: novoId,
          nome: 'Cadeira Ergonômica #$_contadorNovos',
          preco: 980.00 + (_contadorNovos * 10),
          categoria: 'Mobiliário',
          icone: '🪑',
        ),
        Produto(
          id: novoId,
          nome: 'Caixa de Som JBL #$_contadorNovos',
          preco: 320.00 + (_contadorNovos * 5),
          categoria: 'Áudio',
          icone: '🔊',
        ),
      ];
      final novoProduto = novosExemplos[(_contadorNovos - 1) % novosExemplos.length];
      _produtos.add(novoProduto);
      _contadorNovos++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Produto "${_produtos.last.nome}" adicionado com sucesso!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Produtos'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Itens: ${_produtos.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: _produtos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum produto no catálogo',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _produtos.length,
              itemBuilder: (context, index) {
                final produto = _produtos[index];
                return Dismissible(
                  key: Key(produto.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Remover',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.delete, color: Colors.white),
                      ],
                    ),
                  ),
                  onDismissed: (direction) {
                    final itemRemovido = produto;
                    final indexRemovido = index;
                    setState(() {
                      _produtos.removeAt(index);
                    });

                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${itemRemovido.nome} removido do catálogo'),
                        duration: const Duration(seconds: 3),
                        action: SnackBarAction(
                          label: 'Desfazer',
                          textColor: Colors.amber,
                          onPressed: () {
                            setState(() {
                              _produtos.insert(indexRemovido, itemRemovido);
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: ProdutoCard(
                    produto: produto,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalhesProdutoScreen(produto: produto),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarProduto,
        tooltip: 'Adicionar Produto',
        child: const Icon(Icons.add),
      ),
    );
  }
}
