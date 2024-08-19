import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../domain/models/user.dart';
import '../../routes/routes.dart';

class CustomerDrawer extends StatelessWidget {
  const CustomerDrawer({super.key});

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
    return SizedBox(
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
              ExpansionTile(
                title: const Text('Configuración'),
                leading: const Icon(Icons.settings),
                children: <Widget>[
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
                    title: const Text('Categorías'),
                    leading: const Icon(Icons.category),
                    onTap: () {
                      // Acción al seleccionar Categorías
                    },
                  ),
                ],
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
    );
  }
}
