import 'package:flutter/material.dart';

import '../../../../../../main.dart';
import 'category_add_page.dart';
import 'category_edit_page.dart';

class DataTableCategories extends StatefulWidget {
  const DataTableCategories({super.key});

  @override
  State<DataTableCategories> createState() => _DataTableCategoriesState();
}

class _DataTableCategoriesState extends State<DataTableCategories> {
  void _actualizarTexto(String text) {
    print(text);
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
                deleteCategoryDataById(context, index.toString());
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
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder<List<Map<dynamic, dynamic>>>(
              future: getDataCategories(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                } else {
                  final categories = snapshot.data!;
                  print(categories);
                  return DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text('Id'),
                      ),
                      DataColumn(
                        label: Text('Nombre'),
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
                    rows: categories.map(
                      (category) {
                        int _index = category['id'];
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(Text(category['id'].toString())),
                            DataCell(Text(category['name']!)),
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

Future<List<Map<dynamic, dynamic>>> getDataCategories(
    BuildContext context) async {
  final result =
      await Injector.of(context).categoriesRepository.getCategoriesData();
  return result;
}

Future<void> deleteCategoryDataById(BuildContext context, String id) async {
  await Injector.of(context).categoriesRepository.deleteCategoryData(id);
}
