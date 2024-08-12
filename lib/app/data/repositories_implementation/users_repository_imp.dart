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
}
