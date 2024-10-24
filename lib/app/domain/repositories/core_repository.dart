abstract class CoreRepository {
  Future insertBobino(
      name, categoria, raza, genero, fechaNacimiento, pesoInicial);
  Future insertUpdateBobino(
      id, name, categoria, raza, genero, fechaNacimiento, pesoInicial);
  Future getBobinoDataById(id);
  Future<List<Map<String, dynamic>>> getDataRazaReport();
  Future<List<Map<String, dynamic>>> getDataBobinoReport();
  Future insertEvent(date, title);
  Future<List<Map<String, dynamic>>> getEvents();
}
