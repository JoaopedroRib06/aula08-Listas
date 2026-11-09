import 'package:flutter_test/flutter_test.dart';
import 'package:pdm_aula8_listas/models/tarefa_model.dart';

void main() {
  group('TarefaModel', () {
    test('toMap converte os campos para o formato do SQLite', () {
      final tarefa = TarefaModel(
        id: 1,
        titulo: 'Estudar Flutter',
        descricao: 'Revisar SQLite',
        concluida: true,
      );

      expect(tarefa.toMap(), {
        'id': 1,
        'titulo': 'Estudar Flutter',
        'descricao': 'Revisar SQLite',
        'concluida': 1,
      });
    });

    test('fromMap reconstrói uma tarefa concluída', () {
      final tarefa = TarefaModel.fromMap({
        'id': 7,
        'titulo': 'Fazer atividade',
        'descricao': 'Aula 13',
        'concluida': 1,
      });

      expect(tarefa.id, 7);
      expect(tarefa.titulo, 'Fazer atividade');
      expect(tarefa.descricao, 'Aula 13');
      expect(tarefa.concluida, isTrue);
    });

    test('fromMap reconstrói uma tarefa pendente', () {
      final tarefa = TarefaModel.fromMap({
        'id': 8,
        'titulo': 'Entregar projeto',
        'descricao': 'Até sexta-feira',
        'concluida': 0,
      });

      expect(tarefa.concluida, isFalse);
    });
  });
}
