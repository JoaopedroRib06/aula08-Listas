import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm_aula8_listas/main.dart';

void main() {
  testWidgets('CatalogoScreen renderiza lista e contador de itens corretamente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MeuApp());

    // Verifica que o título está presente
    expect(find.text('Catálogo de Produtos'), findsOneWidget);

    // Verifica contador inicial no AppBar
    expect(find.text('Itens: 5'), findsOneWidget);

    // Verifica produtos iniciais
    expect(find.text('Smartphone Galaxy S24'), findsOneWidget);
    expect(find.text('Notebook Dell XPS'), findsOneWidget);
    expect(find.text('Fone Bluetooth Sony'), findsOneWidget);
  });

  testWidgets('Nível 1: FloatingActionButton adiciona produto dinamicamente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MeuApp());

    expect(find.text('Itens: 5'), findsOneWidget);

    // Clica no FloatingActionButton
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Contador deve ter sido atualizado para 6
    expect(find.text('Itens: 6'), findsOneWidget);
  });

  testWidgets('Nível 2: Deslizar item remove com Dismissible', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MeuApp());

    expect(find.text('Itens: 5'), findsOneWidget);
    expect(find.text('Smartphone Galaxy S24'), findsOneWidget);

    // Desliza para remover o primeiro item
    await tester.drag(find.text('Smartphone Galaxy S24'), const Offset(-500.0, 0.0));
    await tester.pumpAndSettle();

    // Contador deve diminuir para 4 e o item não deve mais estar na tela
    expect(find.text('Itens: 4'), findsOneWidget);
    expect(find.text('Smartphone Galaxy S24'), findsNothing);
  });

  testWidgets('Nível 3: Tocar no ProdutoCard navega para DetalhesProdutoScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MeuApp());

    // Toca no card do Smartphone Galaxy S24
    await tester.tap(find.text('Smartphone Galaxy S24'));
    await tester.pumpAndSettle();

    // Deve estar na tela de detalhes
    expect(find.text('Descrição e Benefícios'), findsOneWidget);
    expect(find.text('Comprar Agora'), findsOneWidget);
    expect(find.text('Voltar ao Catálogo'), findsOneWidget);

    // Toca no botão de voltar da AppBar
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // Retorna ao catálogo
    expect(find.text('Catálogo de Produtos'), findsOneWidget);
  });
}
