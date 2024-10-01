abstract class RazasRepository {
  Future getRazasData();
  Future insertRaza(
      name, idRazaPadre, nameRazaPadre, idRazaMadre, nameRazaMadre);
  Future getRazaDataById(id);
  Future updateRazaData(
      id, name, idRazaPadre, nameRazaPadre, idRazaMadre, nameRazaMadre);
  Future deleteRazaData(id);
}
