import 'package:flutter/material.dart';
import '../models/noticia_model.dart';
import '../services/noticia_service.dart';
import '../services/preferences_service.dart';
import 'detalhe_noticia_screen.dart';

class FeedNoticiasScreen extends StatefulWidget {
  const FeedNoticiasScreen({super.key});

  @override
  State<FeedNoticiasScreen> createState() => _FeedNoticiasScreenState();
}

class _FeedNoticiasScreenState extends State<FeedNoticiasScreen> {
  final _service = NoticiaService();
  final _prefsService = PreferencesService();
  final _buscaController = TextEditingController();
  final _focusNode = FocusNode();

  List<NoticiaModel> _noticias = [];
  List<NoticiaModel> _noticiasFiltradas = [];
  final Set<int> _favoritos = {};

  bool _carregando = true;
  String? _erro;
  bool _simularErro = false;

  List<String> _historicoBusca = [];
  bool _mostrarHistorico = false;

  @override
  void initState() {
    super.initState();
    _carregarFeed();
    _carregarHistorico();
    _buscaController.addListener(_filtrarNoticias);
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() => _mostrarHistorico = true);
      }
    });
  }

  @override
  void dispose() {
    _buscaController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _carregarHistorico() async {
    final historico = await _prefsService.obterHistoricoBusca();
    if (mounted) {
      setState(() => _historicoBusca = historico);
    }
  }

  void _filtrarNoticias() {
    final query = _buscaController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _noticiasFiltradas = _noticias;
      } else {
        _noticiasFiltradas = _noticias
            .where((n) => n.titulo.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  Future<void> _executarBusca(String termo) async {
    if (termo.trim().isEmpty) return;
    _buscaController.text = termo;
    _buscaController.selection = TextSelection.fromPosition(
      TextPosition(offset: termo.length),
    );
    _focusNode.unfocus();
    setState(() => _mostrarHistorico = false);
    _filtrarNoticias();
    await _prefsService.salvarTermoBusca(termo.trim());
    await _carregarHistorico();
  }

  Future<void> _onSubmitBusca(String termo) async {
    await _executarBusca(termo);
  }

  Future<void> _limparHistorico() async {
    await _prefsService.limparHistoricoBusca();
    setState(() => _historicoBusca = []);
  }

  Future<void> _carregarFeed() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final lista = await _service.buscarNoticias(simularErro: _simularErro);
      setState(() {
        _noticias = lista;
        _filtrarNoticias();
      });
    } catch (e) {
      setState(() {
        _erro = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  void _alternarSimulacaoErro() {
    setState(() {
      _simularErro = !_simularErro;
    });

    final status = _simularErro ? 'ativada (falhará)' : 'desativada (sucesso)';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Simulação de erro de conexão $status.'),
        duration: const Duration(seconds: 2),
      ),
    );

    _carregarFeed();
  }

  Future<void> _abrirDetalhes(NoticiaModel noticia) async {
    final isFavorito = _favoritos.contains(noticia.id);

    final resultadoFavorito = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => DetalheNoticiaScreen(
          noticia: noticia,
          isFavoritoInicial: isFavorito,
        ),
      ),
    );

    if (resultadoFavorito != null && mounted) {
      setState(() {
        if (resultadoFavorito) {
          _favoritos.add(noticia.id);
        } else {
          _favoritos.remove(noticia.id);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
        setState(() => _mostrarHistorico = false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Portal de Notícias'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                _simularErro ? Icons.wifi_off : Icons.wifi,
                color: _simularErro ? Colors.red : null,
              ),
              tooltip: _simularErro
                  ? 'Simulação de erro ativa (clique para normalizar)'
                  : 'Simular erro de conexão',
              onPressed: _alternarSimulacaoErro,
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Recarregar Feed',
              onPressed: _carregarFeed,
            ),
          ],
        ),
        body: Column(
          children: [
            // Campo de busca em tempo real
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: TextField(
                controller: _buscaController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Buscar notícia por título...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _buscaController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _buscaController.clear();
                            setState(() => _mostrarHistorico = true);
                          },
                        )
                      : null,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onSubmitted: _onSubmitBusca,
              ),
            ),

            // Histórico de busca
            if (_mostrarHistorico && _historicoBusca.isNotEmpty)
              _buildHistoricoBusca(),

            // Aviso visual quando simulação de erro estiver ativa
            if (_simularErro)
              Container(
                width: double.infinity,
                color: Colors.red.shade100,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber, size: 16, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Modo de teste: Simulação de erro de conexão ativada.',
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

            // Chips do histórico (sempre visíveis quando há histórico e não está com foco)
            if (!_mostrarHistorico && _historicoBusca.isNotEmpty)
              _buildChipsHistorico(),

            // Conteúdo com os 4 estados essenciais
            Expanded(child: _buildConteudo()),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoricoBusca() {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      elevation: 4,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, size: 16, color: colorScheme.primary),
                const SizedBox(width: 6),
                Text(
                  'Buscas recentes',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _limparHistorico,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Limpar',
                    style: TextStyle(fontSize: 12, color: colorScheme.error),
                  ),
                ),
              ],
            ),
            const Divider(height: 4),
            ..._historicoBusca.map(
              (termo) => ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                leading: Icon(Icons.history, size: 18, color: Colors.grey.shade500),
                title: Text(termo, style: const TextStyle(fontSize: 14)),
                trailing: Icon(Icons.north_west, size: 16, color: Colors.grey.shade400),
                onTap: () => _executarBusca(termo),
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildChipsHistorico() {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, size: 14, color: colorScheme.primary),
              const SizedBox(width: 4),
              Text(
                'Buscas recentes:',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: _limparHistorico,
                child: Text(
                  'Limpar',
                  style: TextStyle(fontSize: 11, color: colorScheme.error),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: _historicoBusca
                .map(
                  (termo) => ActionChip(
                    avatar: Icon(Icons.history, size: 14, color: colorScheme.primary),
                    label: Text(termo, style: const TextStyle(fontSize: 12)),
                    onPressed: () => _executarBusca(termo),
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildConteudo() {
    if (_carregando) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Carregando notícias...'),
          ],
        ),
      );
    }

    if (_erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                _erro!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  if (_simularErro) {
                    setState(() => _simularErro = false);
                  }
                  _carregarFeed();
                },
                label: const Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (_noticiasFiltradas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text(
              'Nenhuma notícia encontrada.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregarFeed,
      child: ListView.builder(
        itemCount: _noticiasFiltradas.length,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        itemBuilder: (context, index) {
          final item = _noticiasFiltradas[index];
          final isFavorito = _favoritos.contains(item.id);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Hero(
                tag: 'noticia-img-${item.id}',
                child: CircleAvatar(
                  backgroundColor: Colors.teal.shade100,
                  child: Text(
                    item.id.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade900,
                    ),
                  ),
                ),
              ),
              title: Text(
                item.titulo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                item.resumo,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isFavorito)
                    const Padding(
                      padding: EdgeInsets.only(right: 4.0),
                      child: Icon(Icons.favorite, color: Colors.red, size: 18),
                    ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              onTap: () => _abrirDetalhes(item),
            ),
          );
        },
      ),
    );
  }
}
