import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  // Chaves do SharedPreferences
  static const String _keyNomeUsuario = 'key_nome_usuario';
  static const String _keyModoEscuro = 'key_modo_escuro';
  static const String _keyUltimoAcesso = 'key_ultimo_acesso';
  static const String _keyHistoricoBusca = 'key_historico_busca_json';
  static const String _keyTarefas = 'key_tarefas_salvas_json';
  static const int _maxHistorico = 10;

  // --- REQUISITOS BÁSICOS DA AULA ---
  Future<void> salvarNomeUsuario(String nome) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyNomeUsuario, nome);
  }

  Future<String> obterNomeUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyNomeUsuario) ?? 'Usuário Convidado';
  }

  Future<void> salvarModoEscuro(bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyModoEscuro, valor);
  }

  Future<bool> obterModoEscuro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyModoEscuro) ?? false;
  }

  // --- DESAFIO BÁSICO: Data do Último Acesso ---
  // Armazena uma String representando a data/hora da última execução com
  // prefs.setString('key_ultimo_acesso', DateTime.now().toString()) e exibe no rodapé.
  Future<void> salvarUltimoAcesso([String? dataHora]) async {
    final prefs = await SharedPreferences.getInstance();
    final valor = dataHora ?? DateTime.now().toString();
    await prefs.setString(_keyUltimoAcesso, valor);
  }

  Future<String?> obterUltimoAcesso() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUltimoAcesso);
  }

  // --- DESAFIO INTERMEDIÁRIO: Resetar Preferências ---
  // Redefinir Padrões chamando service.limparTudo() e restaurando a interface
  Future<void> limparTudo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // --- DESAFIO AVANÇADO: Armazenamento de Lista JSON em String ---
  // Histórico de pesquisas ou tarefas salvas utilizando jsonEncode para
  // converter uma List<Map> em String e jsonDecode na leitura.

  // 1. Tarefas salvas em formato JSON (List<Map<String, dynamic>>)
  Future<void> salvarTarefas(List<Map<String, dynamic>> tarefas) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(tarefas);
    await prefs.setString(_keyTarefas, jsonStr);
  }

  Future<List<Map<String, dynamic>>> obterTarefas() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyTarefas);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final dynamic decoded = jsonDecode(jsonStr);
      if (decoded is List) {
        return decoded
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
      }
    } catch (e) {
      debugPrint('Erro ao decodificar tarefas JSON: $e');
    }
    return [];
  }

  Future<void> adicionarTarefa(String titulo) async {
    if (titulo.trim().isEmpty) return;
    final tarefas = await obterTarefas();
    tarefas.insert(0, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'titulo': titulo.trim(),
      'concluida': false,
      'dataHora': DateTime.now().toIso8601String(),
    });
    await salvarTarefas(tarefas);
  }

  Future<void> alternarStatusTarefa(String id) async {
    final tarefas = await obterTarefas();
    final index = tarefas.indexWhere((t) => t['id'] == id);
    if (index != -1) {
      final atual = tarefas[index]['concluida'] as bool? ?? false;
      tarefas[index]['concluida'] = !atual;
      await salvarTarefas(tarefas);
    }
  }

  Future<void> removerTarefa(String id) async {
    final tarefas = await obterTarefas();
    tarefas.removeWhere((t) => t['id'] == id);
    await salvarTarefas(tarefas);
  }

  // 2. Histórico de pesquisas salvo em formato JSON (List<Map<String, dynamic>>)
  Future<void> salvarHistoricoBuscaJson(List<Map<String, dynamic>> historico) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(historico);
    await prefs.setString(_keyHistoricoBusca, jsonStr);
  }

  Future<List<Map<String, dynamic>>> obterHistoricoBuscaJson() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyHistoricoBusca);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final dynamic decoded = jsonDecode(jsonStr);
      if (decoded is List) {
        return decoded
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
      }
    } catch (e) {
      debugPrint('Erro ao decodificar histórico de busca JSON: $e');
    }
    return [];
  }

  Future<void> salvarTermoBusca(String termo) async {
    if (termo.trim().isEmpty) return;
    final termoTrim = termo.trim();
    final lista = await obterHistoricoBuscaJson();
    lista.removeWhere(
      (item) => (item['termo'] as String).toLowerCase() == termoTrim.toLowerCase(),
    );
    lista.insert(0, {
      'termo': termoTrim,
      'dataHora': DateTime.now().toIso8601String(),
    });
    if (lista.length > _maxHistorico) {
      lista.removeLast();
    }
    await salvarHistoricoBuscaJson(lista);
  }

  Future<List<String>> obterHistoricoBusca() async {
    final lista = await obterHistoricoBuscaJson();
    return lista.map((item) => item['termo'] as String).toList();
  }

  Future<void> limparHistoricoBusca() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHistoricoBusca);
  }
}
