import 'package:app_ganaderia/app/domain/models/user.dart';
import 'package:app_ganaderia/app/presentation/modules/home/views/user_add_page.dart';
import 'package:app_ganaderia/app/presentation/modules/home/views/user_edit_page.dart';
import 'package:flutter/material.dart';

import '../../../../../main.dart';
import '../../../routes/routes.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
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
                    Routes.home,
                    arguments: '',
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
      body: DataTableExample(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción cuando se presiona el botón
          _showFormModal(context);
        },
        tooltip: 'Agregar',
        backgroundColor: Colors.indigo.shade300,
        hoverColor: Colors.indigo.shade900,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: FormModal(),
        );
      },
    );
  }
}

class DataTableExample extends StatefulWidget {
  const DataTableExample({super.key});

  @override
  State<DataTableExample> createState() => _DataTableExampleState();
}

class _DataTableExampleState extends State<DataTableExample> {
  void _editRecord(int index) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: FormEditModal(index: index),
        );
      },
    );
  }

  Future<bool?> _deleteRecor(BuildContext context, int index) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar tu acción'),
          content: Text('¿ Estas Seguro de proceder ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Cierra el diálogo y retorna false
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // await LocalDatabase().deleteUser(id: index);
                Navigator.of(context)
                    .pop(true); // Cierra el diálogo y retorna true
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: FutureBuilder<List<Map<dynamic, dynamic>>>(
        future: getDataUser(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final users = snapshot.data!;
            return DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Text('Nombre'),
                ),
                DataColumn(
                  label: Text('Correo'),
                ),
                DataColumn(
                  label: Text('Tipo'),
                ),
                DataColumn(
                  label: Center(
                    child: Text(
                      'Acciones',
                    ),
                  ),
                  numeric: true,
                ),
              ],
              rows: users.map(
                (user) {
                  int _index = user['id'];
                  String perfil = '';
                  if (user['perfil'] == '1') {
                    perfil = 'Administrador';
                  } else {
                    perfil = 'Operador';
                  }
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text(user['name']!)),
                      DataCell(Text(user['email']!)),
                      DataCell(Text(perfil)),
                      DataCell(
                        (_index != 1)
                            ? Center(
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        // _editRecord(_index);
                                      },
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          // _deleteRecor(context, _index);
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.delete))
                                  ],
                                ),
                              )
                            : const Text(''),
                      )
                    ],
                  );
                },
              ).toList(),
            );
          }
        },
      ),
    );
  }
}

Future<List<Map<dynamic, dynamic>>> getDataUser(BuildContext context) async {
  final result = await Injector.of(context).usersRepository.getUsersData();
  return result;
}
