import 'package:app_ganaderia/app/data/services/local/localDb.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_ganaderia/app/domain/either.dart';
import 'package:app_ganaderia/app/domain/enums.dart';
import 'package:app_ganaderia/app/domain/models/user.dart';
import 'package:app_ganaderia/app/domain/repositories/authentication_repository.dart';

const _key = "sessionId";

class AuthenticationRepositoryImp implements AuthenticationRepository {
  final FlutterSecureStorage _secureStorage;

  AuthenticationRepositoryImp(this._secureStorage);

  @override
  Future<User?> getUserData() async {
    final id = await _secureStorage.read(key: _key);
    final user = await LocalDatabase().getUserById(id: id);
    print('user $user');
    if (!user.isEmpty) {
      return User(
        user['name'],
        user['email'],
        user['photo'],
        1,
        // user['perfil'],
      );
    }
    return Future.value(User('', '', '', 0));
  }

  @override
  Future<bool> get isSignedIn async {
    final sessionId = await _secureStorage.read(key: _key);
    return sessionId != null;
  }

  @override
  Future<Either<signInFailure, User>> signIn(
    String username,
    String password,
  ) async {
    await Future.delayed(
      const Duration(seconds: 2),
    );
    final validateName = await LocalDatabase().readUserByEmail(email: username);
    if (validateName.isEmpty) {
      return Either.left(signInFailure.notFound);
    }

    final validate =
        await LocalDatabase().readUser(email: username, password: password);
    if (validate.isEmpty) {
      return Either.left(signInFailure.unauthorized);
    }

    await _secureStorage.write(key: _key, value: validate['id']);
    return Either.right(
      User(
        validate['name'],
        validate['email'],
        validate['photo'],
        validate['perfil'],
      ),
    );
  }

  @override
  Future<void> signOut() async {
    await _secureStorage.delete(key: _key);
  }
}
