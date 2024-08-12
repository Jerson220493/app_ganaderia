abstract class UsersRepository {
  Future getUsersData();
  Future insertUser(name, email, password, perfil);
}
