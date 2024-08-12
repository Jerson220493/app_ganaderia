import 'package:app_ganaderia/app/data/repositories_implementation/users_repository_imp.dart';
import 'package:app_ganaderia/app/domain/repositories/users_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_ganaderia/app/data/repositories_implementation/authentication_repository_imp.dart';
import 'package:app_ganaderia/app/data/repositories_implementation/connectivity_repository_imp.dart';
import 'package:app_ganaderia/app/data/services/remote/internet_checkear.dart';
import 'package:app_ganaderia/app/domain/repositories/authentication_repository.dart';
import 'package:app_ganaderia/app/domain/repositories/connectivity_reporsitory.dart';
import 'package:app_ganaderia/app/my_app.dart';

void main() {
  runApp(
    Injector(
      authenticationRepository: AuthenticationRepositoryImp(
        const FlutterSecureStorage(),
      ),
      connectivityRepository: ConnectivityRepositoryImp(
        Connectivity(),
        InternetCheckear(),
      ),
      usersRepository: UsersRepositoryImp(),
      child: MyApp(),
    ),
  );
}

class Injector extends InheritedWidget {
  const Injector(
      {super.key,
      required super.child,
      required this.authenticationRepository,
      required this.connectivityRepository,
      required this.usersRepository});

  final ConnectivityRepository connectivityRepository;
  final AuthenticationRepository authenticationRepository;
  final UsersRepository usersRepository;

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => false;

  static Injector of(BuildContext context) {
    final injector = context.dependOnInheritedWidgetOfExactType<Injector>();
    assert(injector != null, 'Injector could not be found');
    return injector!;
  }
}
