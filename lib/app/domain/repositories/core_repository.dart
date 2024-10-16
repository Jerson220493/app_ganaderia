abstract class CoreRepository {
  Future insertBobino(
      name, categoria, raza, genero, fechaNacimiento, pesoInicial);
  Future insertUpdateBobino(
      id, name, categoria, raza, genero, fechaNacimiento, pesoInicial);
  Future getBobinoDataById(id);
}
