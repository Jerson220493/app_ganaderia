import 'package:app_ganaderia/main.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/models/category.dart';

class FormEditModal extends StatefulWidget {
  final int index;
  final Function(String) actualizarTexto;
  const FormEditModal({
    super.key,
    this.index = 1,
    required this.actualizarTexto,
  });
  @override
  _FormEditModalState createState() => _FormEditModalState();
}

class _FormEditModalState extends State<FormEditModal> {
  final _formKeyEditCategory = GlobalKey<FormState>();
  late String name;

  Category categoryData = Category('');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCategoryData();
    });
  }

  Future<void> _fetchCategoryData() async {
    categoryData = await _loadData(widget.index.toString());
    name = categoryData.name;
    setState(() {}); // Llama a setState para actualizar la UI
  }

  Future<Category> _loadData(String id) async {
    final _data = await getCategoryDataById(context, id);
    String name = _data['name'];

    return Category(
      name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKeyEditCategory,
          child: categoryData.name == ''
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        name = value;
                      },
                      controller:
                          TextEditingController(text: categoryData.name),
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKeyEditCategory.currentState?.validate() ??
                            false) {
                          _formKeyEditCategory.currentState?.save();
                          Navigator.pop(context);
                          updateCategory(
                            context,
                            widget.index.toString(),
                            name,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade400,
                        shadowColor: Colors.black, // Color de la sombra
                        elevation: 5, // Elevación del botón
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15), // Padding del botón
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold), // Estilo del texto
                      ),
                      child: const Text(
                        'Guardar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> getCategoryDataById(
      BuildContext context, String id) async {
    final result =
        await Injector.of(context).categoriesRepository.getCategoryDataById(id);
    return result;
  }

  Future<void> updateCategory(
    BuildContext context,
    String id,
    String name,
  ) async {
    final res =
        await Injector.of(context).categoriesRepository.updateCategoryData(
              id,
              name,
            );
    widget.actualizarTexto('categoria actualizada');
    if (res == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("La categoria ya fue registrada con anterioridad"),
        ),
      );
    }
  }
}
