import 'package:app_ganaderia/app/data/services/local/localDb.dart';
import 'package:app_ganaderia/app/domain/repositories/raza_repository.dart';

class RazasRepositoryImp implements RazasRepository {
  @override
  Future getRazasData() async {
    final razas = await LocalDatabase().readAllRazas();
    return razas;
  }

  @override
  Future<int> insertRaza(
      name, idRazaPadre, nameRazaPadre, idRazaMadre, nameRazaMadre) async {
    int result = await LocalDatabase().insertRaza(
      name: name,
      idRazaPadre: idRazaPadre,
      nameRazaPadre: nameRazaPadre,
      idRazaMadre: idRazaMadre,
      nameRazaMadre: nameRazaMadre,
    );
    return result;
  }

  @override
  Future<Map<String, dynamic>> getRazaDataById(id) async {
    final data = await LocalDatabase().getRazaById(id: id);
    return data;
  }

  @override
  Future<int> updateRazaData(id, name, id_raza_padre, name_raza_padre,
      id_raza_madre, name_raza_madre) async {
    final res = await LocalDatabase().updateRaza(
      id: id,
      name: name,
      id_raza_padre: id_raza_padre,
      name_raza_padre: name_raza_padre,
      id_raza_madre: id_raza_madre,
      name_raza_madre: name_raza_madre,
    );
    return res;
  }

  @override
  Future deleteRazaData(id) async {
    await LocalDatabase().deleteRaza(id: id);
  }
}
