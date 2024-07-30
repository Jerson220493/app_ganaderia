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
  Future<User?> getUserData() {
    return Future.value(User());
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
      Duration(seconds: 2),
    );
    if (username != 'test') {
      return Either.left(signInFailure.notFound);
    }
    if (password != '123456') {
      return Either.left(signInFailure.unauthorized);
    }

    await _secureStorage.write(key: _key, value: '123');
    return Either.right(
      User(),
    );
  }

  @override
  Future<void> signOut() async {
    await _secureStorage.delete(key: _key);
  }
}
