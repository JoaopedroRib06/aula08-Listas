import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<void> _validarServicoEPermissoes() async {
    final servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado) {
      throw Exception('O serviço de GPS está desativado no dispositivo.');
    }

    var permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        throw Exception('Permissão de localização negada pelo usuário.');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      throw Exception(
        'Permissões negadas permanentemente. Altere nas configurações.',
      );
    }
  }

  Future<Position> obterPosicaoAtual() async {
    await _validarServicoEPermissoes();

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<Stream<Position>> monitorarPosicao() async {
    await _validarServicoEPermissoes();

    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }
}
