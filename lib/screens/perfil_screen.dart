import 'dart:io';

import 'package:flutter/material.dart';

import '../services/media_service.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _mediaService = MediaService();
  final _nomeController = TextEditingController(text: 'Diego Menegassi');

  File? _imagemPerfil;

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  String _limparErro(Object erro) {
    return erro.toString().replaceFirst('Exception: ', '');
  }

  Future<void> _capturarImagem(bool daCamera) async {
    Navigator.pop(context);

    try {
      final imagem = daCamera
          ? await _mediaService.tirarFoto()
          : await _mediaService.selecionarDaGaleria();

      if (!mounted) return;
      if (imagem != null) {
        setState(() => _imagemPerfil = imagem);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Não foi possível obter a imagem: ${_limparErro(e)}'),
        ),
      );
    }
  }

  void _removerFoto() {
    Navigator.pop(context);
    setState(() => _imagemPerfil = null);
  }

  void _exibirOpcoesMidia() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.pink),
                title: const Text('Tirar Foto com a Câmera'),
                onTap: () => _capturarImagem(true),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.pink),
                title: const Text('Escolher da Galeria'),
                onTap: () => _capturarImagem(false),
              ),
              ListTile(
                enabled: _imagemPerfil != null,
                leading: Icon(
                  Icons.delete_outline,
                  color: _imagemPerfil == null ? Colors.grey : Colors.red,
                ),
                title: const Text('Remover Foto'),
                onTap: _imagemPerfil == null ? null : _removerFoto,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil do Usuário'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Semantics(
                    label: _imagemPerfil == null
                        ? 'Avatar padrão'
                        : 'Foto de perfil selecionada',
                    image: _imagemPerfil != null,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.pink.shade100,
                      backgroundImage: _imagemPerfil != null
                          ? FileImage(_imagemPerfil!)
                          : null,
                      child: _imagemPerfil == null
                          ? const Icon(
                              Icons.person,
                              size: 70,
                              color: Colors.pink,
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: FloatingActionButton.small(
                      tooltip: 'Alterar foto de perfil',
                      onPressed: _exibirOpcoesMidia,
                      child: const Icon(Icons.camera_alt),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome Completo',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
              ),
            ),
            if (_imagemPerfil != null) ...[
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _imagemPerfil!,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    alignment: Alignment.center,
                    color: Colors.pink.shade50,
                    child: const Text('Não foi possível carregar a imagem.'),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
