import 'package:flutter/material.dart';

import '../../../../../../main.dart';
import 'raza_add_page.dart';
import 'raza_edit_page.dart';

class DataTableRazas extends StatefulWidget {
  const DataTableRazas({super.key});

  @override
  State<DataTableRazas> createState() => _DataTableRazasState();
}

class _DataTableRazasState extends State<DataTableRazas> {
  List<Map<dynamic, dynamic>>? razas;

  void _actualizarTexto(String text) {
    setState(() {});
  }

  void _editRecord(BuildContext context, int index,
      List<Map<dynamic, dynamic>>? razas) async {
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
            razas: razas,
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
                deleteRazaDataById(context, index.toString());
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

  void _showFormModalRaza(BuildContext context, razas) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: FormModalRaza(
            actualizarTexto: _actualizarTexto,
            razas: razas,
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
          child: Container(
            child: FutureBuilder<List<Map<dynamic, dynamic>>>(
              future: getDataRazas(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                } else {
                  razas = snapshot.data!;
                  return DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text('Número'),
                      ),
                      DataColumn(
                        label: Text('Nombre'),
                      ),
                      DataColumn(
                        label: Text('Raza padre'),
                      ),
                      DataColumn(
                        label: Text('Raza madre'),
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
                    rows: razas!.map(
                      (raza) {
                        int _index = raza['id'];
                        String razaPadre = raza['name_raza_padre'] ?? ' ';
                        String razaMadre = raza['name_raza_madre'] ?? ' ';
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(Text(raza['id'].toString())),
                            DataCell(Text(raza['name']!)),
                            DataCell(Text(razaPadre)),
                            DataCell(Text(razaMadre)),
                            DataCell(
                              (_index != 1)
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        mainAxisSize: MainAxisSize
                                            .min, // Esto asegura que el Row no ocupe todo el espacio disponible
                                        mainAxisAlignment: MainAxisAlignment
                                            .end, // Alinea los hijos al final del Row
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () {
                                              _editRecord(
                                                  context, _index, razas);
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormModalRaza(context, razas);
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

Future<List<Map<dynamic, dynamic>>> getDataRazas(BuildContext context) async {
  final result = await Injector.of(context).razasRepository.getRazasData();
  return result;
}

Future<void> deleteRazaDataById(BuildContext context, String id) async {
  await Injector.of(context).razasRepository.deleteRazaData(id);
}
