import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm_aula8_listas/screens/geolocalizacao_screen.dart';
import 'package:pdm_aula8_listas/screens/home_screen.dart';
import 'package:pdm_aula8_listas/screens/perfil_screen.dart';
import 'package:pdm_aula8_listas/utils/precisao_helper.dart';

void main() {
  group('Desafio Aula 14 — medidor de precisão', () {
    test('classifica precisão alta abaixo de 15 metros', () {
      expect(classificarPrecisao(0), NivelPrecisao.alta);
      expect(classificarPrecisao(14.99), NivelPrecisao.alta);
    });

    test('classifica precisão média entre 15 e 50 metros', () {
      expect(classificarPrecisao(15), NivelPrecisao.media);
      expect(classificarPrecisao(50), NivelPrecisao.media);
    });

    test('classifica precisão baixa acima de 50 metros', () {
      expect(classificarPrecisao(50.01), NivelPrecisao.baixa);
    });

    test('retorna os rótulos esperados', () {
      expect(rotuloPrecisao(NivelPrecisao.alta), 'Alta precisão');
      expect(rotuloPrecisao(NivelPrecisao.media), 'Precisão média');
      expect(rotuloPrecisao(NivelPrecisao.baixa), 'Baixa precisão');
    });
  });

  testWidgets('HomeScreen exibe os atalhos das quatro aulas', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: HomeScreen(onTemaAlterado: (_) {})),
    );

    expect(find.text('Aula 12 — Configurações & Perfil'), findsOneWidget);
    expect(find.text('Aula 13 — Tarefas SQLite'), findsOneWidget);
    expect(find.text('Aula 14 — Check-in & GPS'), findsOneWidget);
    expect(find.text('Aula 15 — Perfil & Câmera'), findsOneWidget);
  });

  testWidgets('GeolocalizacaoScreen exibe controles de GPS', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: GeolocalizacaoScreen()));

    expect(find.text('Check-in & GPS'), findsOneWidget);
    expect(find.text('Capturar Localização Atual'), findsOneWidget);
    expect(find.text('Iniciar Rastreamento Contínuo'), findsOneWidget);
    expect(
      find.textContaining('Nenhuma localização capturada'),
      findsOneWidget,
    );
  });

  testWidgets('PerfilScreen exibe avatar e opções de mídia', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PerfilScreen()));

    expect(find.text('Perfil do Usuário'), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.text('Nome Completo'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Tirar Foto com a Câmera'), findsOneWidget);
    expect(find.text('Escolher da Galeria'), findsOneWidget);
    expect(find.text('Remover Foto'), findsOneWidget);
  });
}
