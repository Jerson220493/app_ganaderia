import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../main.dart';
import '../../../domain/models/user.dart';
import '../../routes/routes.dart';

class CustomerDrawer extends StatelessWidget {
  const CustomerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // print(ModalRoute.of(context)!.settings.arguments);
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
              leading: const Icon(FontAwesomeIcons.home,
                  size: 20, color: Colors.black45),
              title: const Text('Inicio'),
              onTap: () async {
                await Navigator.pushNamed(
                  context,
                  Routes.home,
                  arguments: args,
                );
              },
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.pen,
                  size: 20, color: Colors.black45),
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
              leading: const Icon(FontAwesomeIcons.search,
                  size: 20, color: Colors.black45),
              title: const Text('Consultar'),
              onTap: () async {
                await Navigator.pushNamed(
                  context,
                  Routes.consultar,
                  arguments: args,
                );
              },
            ),
            ExpansionTile(
              title: const Text('Informes'),
              leading: const Icon(FontAwesomeIcons.fileAlt,
                  size: 20, color: Colors.black45),
              children: <Widget>[
                ListTile(
                  leading: const Icon(FontAwesomeIcons.fileAlt,
                      size: 17, color: Colors.black45),
                  title: const Text('Informe por razas'),
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      Routes.report_raza,
                      arguments: args,
                    );
                  },
                ),
                ListTile(
                  title: const Text('Informe por bobino'),
                  leading: const Icon(FontAwesomeIcons.fileAlt,
                      size: 17, color: Colors.black45),
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      Routes.reportBobino,
                      arguments: args,
                    );
                  },
                ),
              ],
            ),
            if (perfil == 1)
              ExpansionTile(
                title: const Text('Configuración'),
                leading: const Icon(FontAwesomeIcons.cog,
                    size: 20, color: Colors.black45),
                children: <Widget>[
                  ListTile(
                    leading: const Icon(FontAwesomeIcons.users,
                        size: 17, color: Colors.black45),
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
                    leading: const Icon(FontAwesomeIcons.list,
                        size: 17, color: Colors.black45),
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        Routes.categories,
                        arguments: args,
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Razas'),
                    leading: const Icon(FontAwesomeIcons.cow,
                        size: 17, color: Colors.black45),
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        Routes.razas,
                        arguments: args,
                      );
                    },
                  ),
                ],
              ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.signOutAlt,
                  size: 20, color: Colors.black45),
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
