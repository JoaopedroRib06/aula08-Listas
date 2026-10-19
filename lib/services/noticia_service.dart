import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/comentario_model.dart';
import '../models/noticia_model.dart';

class NoticiaService {
  static const String _endpointPadrao = 'https://jsonplaceholder.typicode.com/posts';
  static const String _endpointInvalido = 'https://endpoint-invalido-para-simulacao-de-erro.com/posts';

  Future<List<NoticiaModel>> buscarNoticias({bool simularErro = false}) async {
    final url = simularErro ? _endpointInvalido : _endpointPadrao;
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> listaJson = jsonDecode(response.body);
        return listaJson.map((item) => NoticiaModel.fromJson(item)).toList();
      } else {
        throw Exception('Status HTTP de erro: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Falha ao conectar com a API: $e');
    }
  }

  Future<List<ComentarioModel>> buscarComentarios(int postId) async {
    final url = 'https://jsonplaceholder.typicode.com/posts/$postId/comments';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> listaJson = jsonDecode(response.body);
        return listaJson.map((item) => ComentarioModel.fromJson(item)).toList();
      } else {
        throw Exception('Status HTTP de erro ao buscar comentários: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Falha ao carregar comentários: $e');
    }
  }
}
