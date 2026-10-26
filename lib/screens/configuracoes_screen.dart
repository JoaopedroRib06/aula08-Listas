import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

class ConfiguracoesScreen extends StatefulWidget {
  final Function(bool) onTemaAlterado;
  const ConfiguracoesScreen({super.key, required this.onTemaAlterado});

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  final _service = PreferencesService();
  final _nomeController = TextEditingController();
  bool _modoEscuro = false;
  bool _carregando = true;
  String _ultimoAcesso = '';

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
  }

  Future<void> _carregarPreferencias() async {
    final nome = await _service.obterNomeUsuario();
    final modoEscuro = await _service.obterModoEscuro();
    final ultimoAcessoSalvo = await _service.obterUltimoAcesso();

    // Salva o momento da execução atual para o próximo acesso (Desafio Básico)
    await _service.salvarUltimoAcesso(DateTime.now().toString());

    setState(() {
      _nomeController.text = nome;
      _modoEscuro = modoEscuro;
      _ultimoAcesso = ultimoAcessoSalvo ?? 'Primeiro acesso registrado agora';
      _carregando = false;
    });
  }

  Future<void> _salvarPreferencias() async {
    await _service.salvarNomeUsuario(_nomeController.text);
    await _service.salvarModoEscuro(_modoEscuro);
    widget.onTemaAlterado(_modoEscuro);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preferências salvas com sucesso!')),
      );
    }
  }

  Future<void> _redefinirPadroes() async {
    await _service.limparTudo();
    setState(() {
      _nomeController.text = 'Usuário Convidado';
      _modoEscuro = false;
      _ultimoAcesso = 'Preferências resetadas';
    });
    widget.onTemaAlterado(false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configurações redefinidas para os padrões!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações & Perfil'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do Usuário',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Ativar Modo Escuro'),
              subtitle: const Text('Persiste o tema visual selecionado no disco'),
              value: _modoEscuro,
              onChanged: (valor) => setState(() => _modoEscuro = valor),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _salvarPreferencias,
                icon: const Icon(Icons.save),
                label: const Text('Salvar Alterações'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _redefinirPadroes,
                icon: const Icon(Icons.restore),
                label: const Text('Redefinir Padrões'),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Último acesso: $_ultimoAcesso',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
