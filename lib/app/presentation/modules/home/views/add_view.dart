import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../main.dart';
import '../../../../domain/models/user.dart';
import '../../../routes/routes.dart';

class AddView extends StatefulWidget {
  const AddView({super.key});

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  @override
  final Color _color = Colors.indigo.shade400;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as User?;
    String name = '';
    String email = '';
    String photo = '';
    int perfil = 0;
    if (args != null) {
      name = args.name;
      email = args.email;
      photo = args.photo;
      perfil = args.perfil;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _color,
        actions: [
          IconButton(
            // si initial date es diferente a la fecha inicial habilitamos el botom
            onPressed: () async {
              Injector.of(context).authenticationRepository.signOut();
              Navigator.pushReplacementNamed(context, Routes.signIn);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        // automaticallyImplyLeading: false,
      ),
      drawer: SizedBox(
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(name),
                accountEmail: Text(email),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/users/$photo'),
                ),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade400,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Consultar'),
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    Routes.home,
                    arguments: '',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.app_registration),
                title: const Text('Registrar'),
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    Routes.add,
                    arguments: args,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.update),
                title: const Text('Actualizar'),
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    Routes.home,
                    arguments: '',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_chart_outlined),
                title: const Text('Informes'),
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    Routes.users,
                    arguments: '',
                  );
                },
              ),
              if (perfil == 1)
                ListTile(
                  leading: const Icon(Icons.group),
                  title: const Text('Usuarios'),
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      Routes.users,
                      arguments: args,
                    );
                  },
                ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Cerrar sesión'),
                onTap: () async {
                  Injector.of(context).authenticationRepository.signOut();
                  Navigator.pushReplacementNamed(context, Routes.signIn);
                },
              ),
            ],
          ),
        ),
      ),
      body: Center(),
    );
  }
}
