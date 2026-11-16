import 'package:flutter/material.dart';

import 'configuracoes_screen.dart';
import 'geolocalizacao_screen.dart';
import 'perfil_screen.dart';
import 'tarefas_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onTemaAlterado});

  final ValueChanged<bool> onTemaAlterado;

  void _abrir(BuildContext context, Widget tela) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => tela));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDM • Aulas 12 a 15'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Programação para Dispositivos Móveis I',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          _AulaCard(
            icon: Icons.settings,
            titulo: 'Aula 12 — Configurações & Perfil',
            subtitulo: 'SharedPreferences, tema e preferências',
            onTap: () => _abrir(
              context,
              ConfiguracoesScreen(onTemaAlterado: onTemaAlterado),
            ),
          ),
          _AulaCard(
            icon: Icons.checklist,
            titulo: 'Aula 13 — Tarefas SQLite',
            subtitulo: 'CRUD completo com sqflite',
            onTap: () => _abrir(context, const TarefasScreen()),
          ),
          _AulaCard(
            icon: Icons.gps_fixed,
            titulo: 'Aula 14 — Check-in & GPS',
            subtitulo: 'Permissões, coordenadas e rastreamento',
            onTap: () => _abrir(context, const GeolocalizacaoScreen()),
          ),
          _AulaCard(
            icon: Icons.photo_camera,
            titulo: 'Aula 15 — Perfil & Câmera',
            subtitulo: 'image_picker, galeria e avatar',
            onTap: () => _abrir(context, const PerfilScreen()),
          ),
        ],
      ),
    );
  }
}

class _AulaCard extends StatelessWidget {
  const _AulaCard({
    required this.icon,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  final IconData icon;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(titulo),
        subtitle: Text(subtitulo),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
