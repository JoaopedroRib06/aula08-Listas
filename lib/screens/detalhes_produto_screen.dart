import 'package:flutter/material.dart';
import '../models/produto.dart';

class DetalhesProdutoScreen extends StatelessWidget {
  final Produto produto;

  const DetalhesProdutoScreen({
    super.key,
    required this.produto,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(produto.nome),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Destaque visual com o ícone do produto
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    produto.icone,
                    style: const TextStyle(fontSize: 54),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Card com informações principais
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            produto.nome,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'ID: ${produto.id}',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Categoria
                    Row(
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 18,
                          color: theme.colorScheme.secondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Categoria: ${produto.categoria}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 28),

                    // Preço em destaque
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Preço:',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'R\$ ${produto.preco.toStringAsFixed(2)}',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card de Detalhes Adicionais
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Descrição e Benefícios',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Produto de alta qualidade da categoria ${produto.categoria}, com garantia de fábrica, nota fiscal e pronta entrega para todo o Brasil.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Text('Disponível em estoque', style: theme.textTheme.bodyMedium),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.local_shipping_outlined, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        Text('Frete grátis para compras acima de R\$ 199', style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Botão de Ação Principal
            FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${produto.nome} adicionado ao carrinho!'),
                    backgroundColor: Colors.green[800],
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Comprar Agora', style: TextStyle(fontSize: 16)),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Botão Voltar
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Voltar ao Catálogo'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
