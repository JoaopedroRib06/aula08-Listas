import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyNomeUsuario = 'key_nome_usuario';
  static const String _keyModoEscuro = 'key_modo_escuro';
  static const String _keyUltimoAcesso = 'key_ultimo_acesso';
  static const String _keyHistoricoBusca = 'key_historico_busca';
  static const int _maxHistorico = 10;

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

  Future<void> salvarUltimoAcesso(String dataHora) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUltimoAcesso, dataHora);
  }

  Future<String?> obterUltimoAcesso() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUltimoAcesso);
  }

  Future<void> salvarTermoBusca(String termo) async {
    if (termo.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList(_keyHistoricoBusca) ?? [];
    lista.remove(termo); // remove duplicata
    lista.insert(0, termo); // insere no topo
    if (lista.length > _maxHistorico) lista.removeLast();
    await prefs.setStringList(_keyHistoricoBusca, lista);
  }

  Future<List<String>> obterHistoricoBusca() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyHistoricoBusca) ?? [];
  }

  Future<void> limparHistoricoBusca() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHistoricoBusca);
  }

  Future<void> limparTudo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
