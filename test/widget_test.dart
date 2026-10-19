import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm_aula8_listas/main.dart';
import 'package:pdm_aula8_listas/models/noticia_model.dart';
import 'package:pdm_aula8_listas/models/comentario_model.dart';

void main() {
  group('Testes de Modelagem', () {
    test('NoticiaModel.fromJson mapeia dados corretamente com valores padrão', () {
      final json = {
        'id': 1,
        'userId': 2,
        'title': 'Título de Teste',
        'body': 'Corpo de teste para validação de mapeamento da API remota.',
      };

      final noticia = NoticiaModel.fromJson(json);

      expect(noticia.id, 1);
      expect(noticia.autorId, 2);
      expect(noticia.titulo, 'Título de Teste');
      expect(noticia.autor, 'Autor ID 2');
      expect(noticia.conteudoCompleto, 'Corpo de teste para validação de mapeamento da API remota.');
      expect(noticia.resumo.endsWith('...'), isTrue);
      expect(noticia.urlImagem, contains('picsum.photos'));
    });

    test('ComentarioModel.fromJson mapeia dados corretamente', () {
      final json = {
        'id': 10,
        'postId': 1,
        'name': 'João Silva',
        'email': 'joao@teste.com',
        'body': 'Excelente notícia!',
      };

      final comentario = ComentarioModel.fromJson(json);

      expect(comentario.id, 10);
      expect(comentario.postId, 1);
      expect(comentario.nome, 'João Silva');
      expect(comentario.email, 'joao@teste.com');
      expect(comentario.corpo, 'Excelente notícia!');
    });
  });

  group('Testes de Interface', () {
    testWidgets('FeedNoticiasScreen renderiza AppBar, campo de busca e ações', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MeuApp());

      // Verifica título no AppBar
      expect(find.text('Portal de Notícias'), findsOneWidget);

      // Verifica campo de busca
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Buscar notícia por título...'), findsOneWidget);

      // Verifica botões na AppBar
      expect(find.byIcon(Icons.wifi), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });
  });
}
