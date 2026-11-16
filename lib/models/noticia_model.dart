class NoticiaModel {
  final int id;
  final int autorId;
  final String titulo;
  final String resumo;
  final String conteudoCompleto;
  final String autor;
  final String urlImagem;

  NoticiaModel({
    required this.id,
    this.autorId = 0,
    required this.titulo,
    required this.resumo,
    required this.conteudoCompleto,
    required this.autor,
    required this.urlImagem,
  });

  factory NoticiaModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] ?? 0;
    final userId = json['userId'] ?? 0;
    final autorIdParsed = userId is int ? userId : int.tryParse(userId.toString()) ?? 0;
    final body = json['body'] as String? ?? '';
    final resumoCalculado = body.length > 40 ? '${body.substring(0, 40)}...' : body;

    return NoticiaModel(
      id: id,
      autorId: autorIdParsed,
      titulo: json['title'] ?? 'Sem título',
      resumo: resumoCalculado.isNotEmpty ? resumoCalculado : 'Sem resumo',
      conteudoCompleto: body.isNotEmpty ? body : 'Sem conteúdo disponível.',
      autor: 'Autor ID ${userId.toString()}',
      // Placeholder com fallback elegante via errorBuilder
      urlImagem: 'https://picsum.photos/seed/$id/600/300',
    );
  }
}
