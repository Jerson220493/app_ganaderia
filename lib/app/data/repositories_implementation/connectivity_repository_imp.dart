import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:app_ganaderia/app/data/services/remote/internet_checkear.dart';
import 'package:app_ganaderia/app/domain/repositories/connectivity_reporsitory.dart';

class ConnectivityRepositoryImp implements ConnectivityRepository {
  final Connectivity _connectivity;
  final InternetCheckear _internetCheckear;
  ConnectivityRepositoryImp(this._connectivity, this._internetCheckear);

  @override
  Future<bool> get hasInternet async {
    // validar si estamos conectados a internet
    final result = await _connectivity.checkConnectivity();
    // si no esta conectado a una red
    if (result == ConnectivityResult.none) {
      return false;
    }

    return _internetCheckear.hasInternet();
  }
}
