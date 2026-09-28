import 'package:flutter_test/flutter_test.dart';
import 'package:pdm_aula8_listas/main.dart';

void main() {
  testWidgets('CatalogoScreen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MeuApp());

    // Verifica que o título está presente
    expect(find.text('Catálogo de Produtos'), findsOneWidget);

    // Verifica se os itens iniciais estão renderizados
    expect(find.text('Smartphone Galaxy S24'), findsOneWidget);
    expect(find.text('Notebook Dell XPS'), findsOneWidget);
    expect(find.text('Itens: 5'), findsOneWidget);
  });
}
