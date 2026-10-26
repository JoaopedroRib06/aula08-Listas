import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdm_aula8_listas/models/noticia_model.dart';
import 'package:pdm_aula8_listas/models/comentario_model.dart';
import 'package:pdm_aula8_listas/screens/feed_noticias_screen.dart';
import 'package:pdm_aula8_listas/screens/configuracoes_screen.dart';
import 'package:pdm_aula8_listas/services/preferences_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

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

  group('Testes de PreferencesService (Desafios Aula 12)', () {
    test('Desafio Básico: salvar e obter data do último acesso', () async {
      final service = PreferencesService();
      final data = DateTime.now().toString();
      await service.salvarUltimoAcesso(data);

      final salvo = await service.obterUltimoAcesso();
      expect(salvo, equals(data));
    });

    test('Desafio Intermediário: limparTudo redefine todas as preferências', () async {
      final service = PreferencesService();
      await service.salvarNomeUsuario('Carlos');
      await service.salvarModoEscuro(true);
      await service.salvarUltimoAcesso('2026-10-26 10:00:00');

      await service.limparTudo();

      expect(await service.obterNomeUsuario(), equals('Usuário Convidado'));
      expect(await service.obterModoEscuro(), isFalse);
      expect(await service.obterUltimoAcesso(), isNull);
    });

    test('Desafio Avançado: manipulação de tarefas via JSON (jsonEncode/jsonDecode)', () async {
      final service = PreferencesService();
      expect(await service.obterTarefas(), isEmpty);

      // Adiciona tarefa
      await service.adicionarTarefa('Fazer atividade de PDM');
      final tarefas = await service.obterTarefas();
      expect(tarefas.length, 1);
      expect(tarefas.first['titulo'], equals('Fazer atividade de PDM'));
      expect(tarefas.first['concluida'], isFalse);

      // Alterna status
      final id = tarefas.first['id'].toString();
      await service.alternarStatusTarefa(id);
      final tarefasAtualizadas = await service.obterTarefas();
      expect(tarefasAtualizadas.first['concluida'], isTrue);

      // Remove tarefa
      await service.removerTarefa(id);
      expect(await service.obterTarefas(), isEmpty);
    });

    test('Desafio Avançado: histórico de buscas com List<Map> e JSON', () async {
      final service = PreferencesService();
      await service.salvarTermoBusca('Flutter');
      await service.salvarTermoBusca('Dart');

      final historico = await service.obterHistoricoBusca();
      expect(historico, containsAllInOrder(['Dart', 'Flutter']));

      final jsonHistorico = await service.obterHistoricoBuscaJson();
      expect(jsonHistorico.first['termo'], equals('Dart'));
      expect(jsonHistorico.first.containsKey('dataHora'), isTrue);

      await service.limparHistoricoBusca();
      expect(await service.obterHistoricoBusca(), isEmpty);
    });
  });

  group('Testes de Interface', () {
    testWidgets('ConfiguracoesScreen renderiza controles, desafios e rodapé', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ConfiguracoesScreen(onTemaAlterado: (_) {}),
        ),
      );
      await tester.pumpAndSettle();

      // Verifica AppBar
      expect(find.text('Configurações & Perfil'), findsOneWidget);

      // Verifica campos e botões
      expect(find.byType(TextField), findsNWidgets(2)); // Nome + Nova Tarefa
      expect(find.text('Ativar Modo Escuro'), findsOneWidget);
      expect(find.text('Salvar Alterações'), findsOneWidget);
      expect(find.text('Redefinir Padrões'), findsOneWidget);

      // Verifica seção do Desafio Avançado
      expect(find.text('Desafio Avançado: Tarefas (JSON)'), findsOneWidget);

      // Verifica rodapé do Desafio Básico
      expect(find.textContaining('Último acesso:'), findsOneWidget);
    });

    testWidgets('FeedNoticiasScreen renderiza AppBar, campo de busca e ações', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FeedNoticiasScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Verifica título no AppBar
      expect(find.text('Portal de Notícias'), findsOneWidget);

      // Verifica campo de busca
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Buscar notícia por título...'), findsOneWidget);

      // Verifica botões na AppBar
      expect(find.byIcon(Icons.wifi), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsWidgets);
    });
  });
}
