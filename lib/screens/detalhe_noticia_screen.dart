import 'package:flutter/material.dart';
import '../models/comentario_model.dart';
import '../models/noticia_model.dart';
import '../services/noticia_service.dart';

class DetalheNoticiaScreen extends StatefulWidget {
  final NoticiaModel noticia;
  final bool isFavoritoInicial;

  const DetalheNoticiaScreen({
    super.key,
    required this.noticia,
    this.isFavoritoInicial = false,
  });

  @override
  State<DetalheNoticiaScreen> createState() => _DetalheNoticiaScreenState();
}

class _DetalheNoticiaScreenState extends State<DetalheNoticiaScreen> {
  final _service = NoticiaService();
  late bool _favorito;
  late Future<List<ComentarioModel>> _futureComentarios;

  @override
  void initState() {
    super.initState();
    _favorito = widget.isFavoritoInicial;
    _futureComentarios = _service.buscarComentarios(widget.noticia.id);
  }

  void _alternarFavorito() {
    setState(() {
      _favorito = !_favorito;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _favorito
              ? 'Notícia adicionada aos favoritos!'
              : 'Notícia removida dos favoritos.',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _favorito);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes da Notícia'),
          actions: [
            IconButton(
              icon: Icon(
                _favorito ? Icons.favorite : Icons.favorite_border,
                color: _favorito ? Colors.red : null,
              ),
              tooltip: _favorito ? 'Remover dos favoritos' : 'Favoritar notícia',
              onPressed: _alternarFavorito,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'noticia-img-${widget.noticia.id}',
                child: Image.network(
                  widget.noticia.urlImagem,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.image, size: 48, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.person, size: 16),
                      label: Text(widget.noticia.autor),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.noticia.titulo,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 24),
                    Text(
                      widget.noticia.conteudoCompleto,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.comment, size: 20, color: Colors.teal),
                        const SizedBox(width: 8),
                        Text(
                          'Comentários da Comunidade',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    FutureBuilder<List<ComentarioModel>>(
                      future: _futureComentarios,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.amber.shade300),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline, color: Colors.amber),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Não foi possível carregar os comentários no momento.',
                                    style: TextStyle(color: Colors.grey.shade800),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text('Nenhum comentário encontrado.');
                        }

                        final comentarios = snapshot.data!;
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: comentarios.length,
                          separatorBuilder: (_, _) => const Divider(height: 12),
                          itemBuilder: (context, index) {
                            final c = comentarios[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: Colors.teal.shade100,
                                child: Text(
                                  c.email.isNotEmpty ? c.email[0].toUpperCase() : '?',
                                  style: TextStyle(
                                    color: Colors.teal.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                c.nome,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c.email,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    c.corpo,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
