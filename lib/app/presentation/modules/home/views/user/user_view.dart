import 'package:app_ganaderia/app/presentation/global/widgets/customer_drawer.dart';
import 'package:app_ganaderia/app/presentation/modules/home/views/user/user_add_page.dart';
import 'package:app_ganaderia/app/presentation/modules/home/views/user/user_edit_page.dart';
import 'package:flutter/material.dart';

import '../../../../../../main.dart';
import '../../../../routes/routes.dart';

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
      drawer: const CustomerDrawer(),
      body: const DataTableExample(),
    );
  }
}

class DataTableExample extends StatefulWidget {
  const DataTableExample({super.key});

  @override
  State<DataTableExample> createState() => _DataTableExampleState();
}

class _DataTableExampleState extends State<DataTableExample> {
  void _actualizarTexto(String text) {
    setState(() {});
  }

  void _editRecord(BuildContext context, int index) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: FormEditModal(
            index: index,
            actualizarTexto: _actualizarTexto,
          ),
        );
      },
    );
  }

  Future<bool?> _deleteRecor(BuildContext context, int index) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar tu acción'),
          content: const Text('¿ Estas Seguro de proceder ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Cierra el diálogo y retorna false
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                deleteUserDataById(context, index.toString());
                // await LocalDatabase().deleteUser(id: index);
                Navigator.of(context)
                    .pop(true); // Cierra el diálogo y retorna true
                setState(() {});
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
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
          child: FormModal(
            actualizarTexto: _actualizarTexto,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                                      mainAxisSize: MainAxisSize
                                          .min, // Esto asegura que el Row no ocupe todo el espacio disponible
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            _editRecord(context, _index);
                                          },
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              _deleteRecor(context, _index);
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
        ),
      ),
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
}

Future<List<Map<dynamic, dynamic>>> getDataUser(BuildContext context) async {
  final result = await Injector.of(context).usersRepository.getUsersData();
  return result;
}

Future<void> deleteUserDataById(BuildContext context, String id) async {
  await Injector.of(context).usersRepository.deleteUserData(id);
}
