import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final service = PreferencesService();
  final modoEscuroInicial = await service.obterModoEscuro();
  runApp(MeuApp(modoEscuroInicial: modoEscuroInicial));
}

class MeuApp extends StatefulWidget {
  final bool modoEscuroInicial;

  const MeuApp({super.key, this.modoEscuroInicial = false});

  @override
  State<MeuApp> createState() => _MeuAppState();
}

class _MeuAppState extends State<MeuApp> {
  late bool _modoEscuro;

  @override
  void initState() {
    super.initState();
    _modoEscuro = widget.modoEscuroInicial;
  }

  void _alternarTema(bool valor) {
    setState(() => _modoEscuro = valor);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PDM - Aulas 12 a 15',
      themeMode: _modoEscuro ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: HomeScreen(onTemaAlterado: _alternarTema),
    );
  }
}
