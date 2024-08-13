abstract class UsersRepository {
  Future getUsersData();
  Future insertUser(name, email, password, perfil);
  Future getUserDataById(id);
  Future updateUserData(id, name, email, perfil, password);
}
