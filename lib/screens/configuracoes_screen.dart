import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import 'feed_noticias_screen.dart';

class ConfiguracoesScreen extends StatefulWidget {
  final Function(bool) onTemaAlterado;
  const ConfiguracoesScreen({super.key, required this.onTemaAlterado});

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  final _service = PreferencesService();
  final _nomeController = TextEditingController();
  final _tarefaController = TextEditingController();

  bool _modoEscuro = false;
  bool _carregando = true;
  String _ultimoAcesso = '';
  List<Map<String, dynamic>> _tarefas = [];

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _tarefaController.dispose();
    super.dispose();
  }

  Future<void> _carregarPreferencias() async {
    final nome = await _service.obterNomeUsuario();
    final modoEscuro = await _service.obterModoEscuro();
    final ultimoAcessoSalvo = await _service.obterUltimoAcesso();
    final tarefasSalvas = await _service.obterTarefas();

    // Desafio Básico: salva a execução atual com DateTime.now().toString()
    await _service.salvarUltimoAcesso(DateTime.now().toString());

    setState(() {
      _nomeController.text = nome;
      _modoEscuro = modoEscuro;
      _ultimoAcesso = ultimoAcessoSalvo ?? 'Primeiro acesso registrado agora';
      _tarefas = tarefasSalvas;
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

  // Desafio Intermediário: Redefinir Padrões chamando service.limparTudo()
  Future<void> _redefinirPadroes() async {
    await _service.limparTudo();
    setState(() {
      _nomeController.text = 'Usuário Convidado';
      _modoEscuro = false;
      _ultimoAcesso = 'Preferências resetadas';
      _tarefas = [];
    });
    widget.onTemaAlterado(false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configurações redefinidas para os padrões!')),
      );
    }
  }

  // Desafio Avançado: Manipulação de Tarefas em List<Map> com jsonEncode/jsonDecode
  Future<void> _adicionarTarefa() async {
    final texto = _tarefaController.text.trim();
    if (texto.isEmpty) return;

    await _service.adicionarTarefa(texto);
    _tarefaController.clear();
    final tarefasAtualizadas = await _service.obterTarefas();

    setState(() {
      _tarefas = tarefasAtualizadas;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarefa adicionada e salva em JSON!'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _alternarTarefa(String id) async {
    await _service.alternarStatusTarefa(id);
    final tarefasAtualizadas = await _service.obterTarefas();
    setState(() {
      _tarefas = tarefasAtualizadas;
    });
  }

  Future<void> _removerTarefa(String id) async {
    await _service.removerTarefa(id);
    final tarefasAtualizadas = await _service.obterTarefas();
    setState(() {
      _tarefas = tarefasAtualizadas;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações & Perfil'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Portal de Notícias (Buscas em JSON)',
            icon: const Icon(Icons.newspaper),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FeedNoticiasScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo de Nome do Usuário
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do Usuário',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),

            // Alternância de Tema Escuro
            SwitchListTile(
              title: const Text('Ativar Modo Escuro'),
              subtitle: const Text('Persiste o tema visual selecionado no disco'),
              value: _modoEscuro,
              onChanged: (valor) => setState(() => _modoEscuro = valor),
            ),
            const SizedBox(height: 12),

            // Botão Salvar Alterações
            ElevatedButton.icon(
              onPressed: _salvarPreferencias,
              icon: const Icon(Icons.save),
              label: const Text('Salvar Alterações'),
            ),
            const SizedBox(height: 8),

            // Desafio Intermediário: Botão Redefinir Padrões
            OutlinedButton.icon(
              onPressed: _redefinirPadroes,
              icon: const Icon(Icons.restore),
              label: const Text('Redefinir Padrões'),
            ),
            const SizedBox(height: 24),

            // Desafio Avançado: Armazenamento de Lista JSON em String
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.data_object, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Desafio Avançado: Tarefas (JSON)',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Persiste uma List<Map> utilizando jsonEncode e jsonDecode no SharedPreferences.',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),

                    // Formulário de adicionar tarefa
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _tarefaController,
                            decoration: const InputDecoration(
                              hintText: 'Nova tarefa / anotação...',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (_) => _adicionarTarefa(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          onPressed: _adicionarTarefa,
                          icon: const Icon(Icons.add),
                          tooltip: 'Adicionar Tarefa',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Lista de tarefas renderizada
                    if (_tarefas.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Text(
                            'Nenhuma tarefa salva no momento.',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _tarefas.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final tarefa = _tarefas[index];
                          final id = tarefa['id']?.toString() ?? '';
                          final titulo = tarefa['titulo']?.toString() ?? '';
                          final concluida = tarefa['concluida'] as bool? ?? false;

                          return ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: Checkbox(
                              value: concluida,
                              onChanged: (_) => _alternarTarefa(id),
                            ),
                            title: Text(
                              titulo,
                              style: TextStyle(
                                decoration: concluida
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: concluida ? Colors.grey : null,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20),
                              color: theme.colorScheme.error,
                              onPressed: () => _removerTarefa(id),
                              tooltip: 'Excluir',
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Desafio Básico: Data do Último Acesso exibida no rodapé
            Text(
              'Último acesso: $_ultimoAcesso',
              style: theme.textTheme.bodySmall?.copyWith(
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
