import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/location_service.dart';
import '../utils/precisao_helper.dart';

class GeolocalizacaoScreen extends StatefulWidget {
  const GeolocalizacaoScreen({super.key});

  @override
  State<GeolocalizacaoScreen> createState() => _GeolocalizacaoScreenState();
}

class _GeolocalizacaoScreenState extends State<GeolocalizacaoScreen> {
  final _locationService = LocationService();

  Position? _posicaoAtual;
  bool _carregando = false;
  String? _mensagemErro;
  StreamSubscription<Position>? _positionStreamSub;
  bool _rastreando = false;

  String _limparErro(Object erro) {
    return erro.toString().replaceFirst('Exception: ', '');
  }

  Future<void> _buscarLocalizacao() async {
    setState(() {
      _carregando = true;
      _mensagemErro = null;
    });

    try {
      final posicao = await _locationService.obterPosicaoAtual();
      if (!mounted) return;
      setState(() => _posicaoAtual = posicao);
    } catch (e) {
      if (!mounted) return;
      setState(() => _mensagemErro = _limparErro(e));
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _alternarRastreamento() async {
    if (_rastreando) {
      await _positionStreamSub?.cancel();
      _positionStreamSub = null;
      if (mounted) setState(() => _rastreando = false);
      return;
    }

    setState(() {
      _rastreando = true;
      _mensagemErro = null;
    });

    try {
      final stream = await _locationService.monitorarPosicao();
      if (!mounted) return;

      _positionStreamSub = stream.listen(
        (posicao) {
          if (mounted) setState(() => _posicaoAtual = posicao);
        },
        onError: (Object erro) {
          if (!mounted) return;
          setState(() {
            _mensagemErro = _limparErro(erro);
            _rastreando = false;
          });
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _mensagemErro = _limparErro(e);
        _rastreando = false;
      });
    }
  }

  @override
  void dispose() {
    _positionStreamSub?.cancel();
    super.dispose();
  }

  Color _corPrecisao(NivelPrecisao nivel) {
    switch (nivel) {
      case NivelPrecisao.alta:
        return Colors.green;
      case NivelPrecisao.media:
        return Colors.orange;
      case NivelPrecisao.baixa:
        return Colors.red;
    }
  }

  Widget _chipPrecisao(Position posicao) {
    final nivel = classificarPrecisao(posicao.accuracy);
    final cor = _corPrecisao(nivel);

    return Chip(
      avatar: Icon(Icons.gps_fixed, color: cor, size: 18),
      label: Text(
        '${rotuloPrecisao(nivel)} • ${posicao.accuracy.toStringAsFixed(1)} m',
      ),
      backgroundColor: cor.withValues(alpha: 0.12),
      side: BorderSide(color: cor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final posicao = _posicaoAtual;

    return Scaffold(
      appBar: AppBar(title: const Text('Check-in & GPS'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    if (_carregando)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    if (_mensagemErro != null)
                      Card(
                        color: Colors.red.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            _mensagemErro!,
                            style: TextStyle(color: Colors.red.shade900),
                          ),
                        ),
                      ),
                    if (posicao != null) ...[
                      Card(
                        elevation: 3,
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(
                                Icons.my_location,
                                color: Colors.blue,
                              ),
                              title: const Text('Latitude'),
                              subtitle: Text(
                                posicao.latitude.toStringAsFixed(6),
                              ),
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.location_on,
                                color: Colors.green,
                              ),
                              title: const Text('Longitude'),
                              subtitle: Text(
                                posicao.longitude.toStringAsFixed(6),
                              ),
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.speed,
                                color: Colors.orange,
                              ),
                              title: const Text('Precisão / Altitude'),
                              subtitle: Text(
                                'Precisão: '
                                '${posicao.accuracy.toStringAsFixed(1)} m | '
                                'Alt: ${posicao.altitude.toStringAsFixed(1)} m',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _chipPrecisao(posicao),
                      ),
                    ],
                    if (!_carregando &&
                        posicao == null &&
                        _mensagemErro == null)
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Nenhuma localização capturada. Use o botão abaixo '
                            'para obter as coordenadas do GPS.',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _carregando ? null : _buscarLocalizacao,
                  icon: const Icon(Icons.gps_fixed),
                  label: const Text('Capturar Localização Atual'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _alternarRastreamento,
                  icon: Icon(_rastreando ? Icons.stop : Icons.play_arrow),
                  label: Text(
                    _rastreando
                        ? 'Parar Rastreamento'
                        : 'Iniciar Rastreamento Contínuo',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
