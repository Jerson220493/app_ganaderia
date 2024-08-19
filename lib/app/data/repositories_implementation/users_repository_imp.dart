import 'package:app_ganaderia/app/data/services/local/localDb.dart';
import 'package:app_ganaderia/app/domain/repositories/users_repository.dart';

class UsersRepositoryImp implements UsersRepository {
  @override
  Future getUsersData() async {
    final users = await LocalDatabase().readAllUser();
    return users;
  }

  @override
  Future<int> insertUser(name, email, password, perfil) async {
    int result = await LocalDatabase().insertUser(
        name: name, email: email, password: password, perfil: perfil);
    return result;
  }

  @override
  Future<Map<String, dynamic>> getUserDataById(id) async {
    final user = await LocalDatabase().getUserById(id: id);
    return user;
  }

  @override
  Future<int> updateUserData(id, name, email, perfil, password) async {
    final res = await LocalDatabase().updateUser(
        id: id, name: name, email: email, perfil: perfil, password: password);
    return res;
  }

  @override
  Future deleteUserData(id) async {
    await LocalDatabase().deleteUser(id: id);
  }
}
