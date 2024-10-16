import 'dart:ffi';

import 'package:app_ganaderia/app/presentation/global/widgets/customer_drawer.dart';
import 'package:app_ganaderia/app/presentation/modules/home/views/categories/category_datatables.dart';
import 'package:app_ganaderia/app/presentation/modules/home/views/information_view.dart';
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
  final _formKey = GlobalKey<FormState>();

  Future<void> insertData(
      BuildContext context,
      String name,
      String categoria,
      String raza,
      String genero,
      String? fechaNacimiento,
      int pesoInicial) async {
    final res = await Injector.of(context).coreRepository.insertBobino(
        name, categoria, raza, genero, fechaNacimiento, pesoInicial);
    if (res == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("El bobino ya fue creado"),
        ),
      );
    } else {
      await Navigator.pushNamed(
        context,
        Routes.information,
        arguments: res,
      );
    }
  }

  @override
  final Color _color = Colors.indigo.shade400;
  bool _fetching = false;
  List<Map<dynamic, dynamic>>? razas;
  List<Map<dynamic, dynamic>>? categories;
  // variables para manejar los datos de ingreso
  String _name = '', _genero = '';
  int _peso = 0;
  String _raza = '', _categoria = '';
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(), // Fecha inicial
      firstDate: DateTime(2000), // Fecha mínima
      lastDate: DateTime(2101), // Fecha máxima
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // Actualiza la fecha seleccionada
      });
    }
  }

  Future<List<Map<dynamic, dynamic>>> getDataRazas(BuildContext context) async {
    final result = await Injector.of(context).razasRepository.getRazasData();
    return result;
  }

  Future<List<Map<dynamic, dynamic>>> getDataCategories(
      BuildContext context) async {
    final result =
        await Injector.of(context).categoriesRepository.getCategoriesData();
    return result;
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
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: AbsorbPointer(
            absorbing: _fetching,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  "Registro",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: const Key('name'),
                  onChanged: (value) {
                    setState(() {
                      _name = value.trim().toLowerCase();
                    });
                  },
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                  validator: (value) {
                    value = value?.trim().toLowerCase() ?? '';
                    if (value.isEmpty) {
                      return 'Invalid name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                FutureBuilder<List<Map<dynamic, dynamic>>>(
                  future: getDataCategories(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No data available'));
                    } else {
                      categories = snapshot.data!;
                      return DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Categoria',
                          hintText:
                              'Categoria', // Cambia el hintText a lo que desees
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                        // decoration: const InputDecoration(labelText: 'Raza'),
                        value: _categoria != null
                            ? int.tryParse(_categoria!)
                            : null, // Mantiene el valor seleccionado // Valor inicial puede ser null si no hay selección
                        items: categories!
                            .map((option) => DropdownMenuItem<int>(
                                  value: option['id'],
                                  child: Text(option['name']),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _categoria = value.toString();
                          });
                        },
                        onSaved: (value) {
                          if (value != null) {
                            _categoria = value.toString();
                          }
                        },
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                FutureBuilder<List<Map<dynamic, dynamic>>>(
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
                      return DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Raza',
                          hintText:
                              'Raza', // Cambia el hintText a lo que desees
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                        // decoration: const InputDecoration(labelText: 'Raza'),
                        value: _raza != null
                            ? int.tryParse(_raza!)
                            : null, // Mantiene el valor seleccionado // Valor inicial puede ser null si no hay selección
                        items: razas!
                            .map((option) => DropdownMenuItem<int>(
                                  value: option['id'],
                                  child: Text(option['name']),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _raza = value.toString();
                          });
                        },
                        onSaved: (value) {
                          if (value != null) {
                            _raza = value.toString();
                          }
                        },
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Genero',
                    hintText: 'Genero', // Cambia el hintText a lo que desees
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                  value: null,
                  items: ['Macho', 'Hembra']
                      .map((option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _genero = value ?? '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, seleccione una opción';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _genero = value ?? '';
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  readOnly:
                      true, // Hace que el campo no sea editable directamente
                  decoration: const InputDecoration(
                    labelText: 'Fecha de nacimiento',
                    hintText: 'Seleccione una fecha',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                  onTap: () {
                    _selectDate(
                        context); // Abre el selector de fecha al tocar el campo
                  },
                  controller: TextEditingController(
                    text: _selectedDate != null
                        ? "${_selectedDate!.toLocal()}"
                            .split(' ')[0] // Formato de fecha
                        : '',
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: const Key('peso'),
                  onChanged: (value) {
                    setState(() {
                      _peso = int.parse(value);
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Peso inicial',
                    hintText: 'Peso inicial',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                  validator: (value) {
                    value = value?.trim().toLowerCase() ?? '';
                    if (value.isEmpty) {
                      return 'Invalid peso inicial';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Builder(
                  builder: (context) {
                    if (_fetching) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          _formKey.currentState?.save();
                          await insertData(
                            context,
                            _name,
                            _categoria,
                            _raza,
                            _genero,
                            _selectedDate.toString(),
                            _peso,
                          );
                          Navigator.of(context).pop(true);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.indigo.shade400, // Color de fondo
                        foregroundColor: Colors.white, // Color del texto
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Registrar',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    setState(() {
      _fetching = true;
    });
    // final result = await Injector.of(context)
    //     .authenticationRepository
    //     .signIn("", "");

    if (!mounted) {
      return;
    }
  }
}
