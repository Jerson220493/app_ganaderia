import 'package:app_ganaderia/app/data/services/local/localDb.dart';
import 'package:app_ganaderia/app/domain/repositories/core_repository.dart';

class CoreRepositoryImp implements CoreRepository {
  @override
  Future<int> insertBobino(
      name, categoria, raza, genero, fechaNacimiento, pesoInicial) async {
    var text_qr =
        "name=$name, categoria=$categoria, raza=$raza, genero=$genero, fecha_nacimiento=$fechaNacimiento, peso_inicial=$pesoInicial";
    int result = await LocalDatabase().insertBobino(
      name: name,
      categoria: categoria,
      raza: raza,
      genero: genero,
      fechaNacimiento: fechaNacimiento,
      pesoInicial: pesoInicial,
      qrText: text_qr,
    );
    return result;
  }

  @override
  Future getBobinoDataById(id) async {
    final data = await LocalDatabase().getBobinoById(id: id);
    return data;
  }

  @override
  Future insertUpdateBobino(
      id, name, categoria, raza, genero, fechaNacimiento, pesoInicial) async {
    int result = await LocalDatabase().insertUpdateBobino(
      id: id,
      peso: pesoInicial,
      date: DateTime.now(),
    );
    return result;
  }

  @override
  Future<List<Map<String, dynamic>>> getDataRazaReport() async {
    final result = await LocalDatabase().getDataRazaReport();
    return result;
  }

  @override
  Future<List<Map<String, dynamic>>> getDataBobinoReport() async {
    final result = await LocalDatabase().getDataBobinoReport();
    return result;
  }

  @override
  Future insertEvent(date, title) async {
    int result = await LocalDatabase().insertEvent(
      date: date,
      title: title,
    );
    return result;
  }

  @override
  Future<List<Map<String, dynamic>>> getEvents() async {
    final result = await LocalDatabase().getEvents();
    return result;
  }
}
