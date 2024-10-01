import 'package:app_ganaderia/app/domain/models/raza.dart';
import 'package:app_ganaderia/main.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/models/raza.dart';

class FormEditModal extends StatefulWidget {
  final int index;
  final List<Map<dynamic, dynamic>>? razas;
  final Function(String) actualizarTexto;
  const FormEditModal({
    super.key,
    this.index = 1,
    required this.actualizarTexto,
    this.razas,
  });
  @override
  _FormEditModalState createState() => _FormEditModalState();
}

class _FormEditModalState extends State<FormEditModal> {
  final _formKeyEditRaza = GlobalKey<FormState>();
  late String name = '';
  late String? id_raza_padre = null;
  late String? name_raza_padre = null;
  late String? id_raza_madre = null;
  late String? name_raza_madre = null;

  String? _razaPadreId;
  String? _razaPadreName = '';
  String? _razaMadreId;
  String? _razaMadreName = '';

  Raza razaData = Raza('', null, null, null, null);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchRazaData();
    });
  }

  Future<void> _fetchRazaData() async {
    razaData = await _loadData(widget.index.toString());

    name = razaData.name;
    id_raza_padre = razaData.id_raza_padre;
    name_raza_padre = razaData.name_raza_padre;
    id_raza_madre = razaData.id_raza_madre;
    name_raza_madre = razaData.name_raza_madre;
    setState(() {}); // Llama a setState para actualizar la UI
  }

  Future<Raza> _loadData(String id) async {
    final _data = await getRazaDataById(context, id);
    String name = _data['name'];
    String? id_raza_padre = _data['id_raza_padre'].toString();
    String? name_raza_padre = _data['name_raza_padre'];
    String? id_raza_madre = _data['id_raza_madre'].toString();
    String? name_raza_madre = _data['name_raza_madre'];

    return Raza(
      name,
      id_raza_padre,
      name_raza_padre,
      id_raza_madre,
      name_raza_madre,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKeyEditRaza,
          child: razaData.name == ''
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        name = value;
                      },
                      controller: TextEditingController(text: razaData.name),
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                    const SizedBox(height: 20),
                    // correo electronico

                    DropdownButtonFormField<int>(
                      decoration:
                          const InputDecoration(labelText: 'Raza padre'),
                      value: (id_raza_padre != null &&
                              (id_raza_padre ?? '').isNotEmpty)
                          ? int.parse(id_raza_padre!)
                          : null, // Valor inicial puede ser null si no hay selección
                      items: widget.razas
                          ?.map((option) => DropdownMenuItem<int>(
                                value:
                                    option['id'], // Usamos el 'id' como valor
                                child: Text(option[
                                    'name']), // Mostramos el 'name' como texto
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          var selectedRaza = widget.razas
                              ?.firstWhere((option) => option['id'] == value);

                          // Almacena tanto el id como el name
                          _razaPadreId = selectedRaza?['id'].toString() ??
                              ''; // Guarda el id
                          _razaPadreName =
                              selectedRaza?['name']; // Guarda el name
                        });
                      },
                      onSaved: (value) {
                        if (value != null) {
                          var selectedRaza = widget.razas
                              ?.firstWhere((option) => option['id'] == value);
                          _razaPadreId = selectedRaza?['id'].toString() ?? '';
                          _razaPadreName = selectedRaza?['name'] ?? '';
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    DropdownButtonFormField<int>(
                      decoration:
                          const InputDecoration(labelText: 'Raza madre'),
                      value: (id_raza_madre != null &&
                              (id_raza_madre ?? '').isNotEmpty)
                          ? int.parse(id_raza_madre!)
                          : null, // Valor inicial puede ser null si no hay selección
                      items: widget.razas
                          ?.map((option) => DropdownMenuItem<int>(
                                value:
                                    option['id'], // Usamos el 'id' como valor
                                child: Text(option[
                                    'name']), // Mostramos el 'name' como texto
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          var selectedRaza = widget.razas
                              ?.firstWhere((option) => option['id'] == value);
                          // Almacena tanto el id como el name
                          _razaMadreId = selectedRaza?['id'].toString() ??
                              ''; // Guarda el id
                          _razaMadreName =
                              selectedRaza?['name']; // Guarda el name
                        });
                      },
                      onSaved: (value) {
                        if (value != null) {
                          var selectedRaza = widget.razas
                              ?.firstWhere((option) => option['id'] == value);
                          _razaMadreId = selectedRaza?['id'].toString() ?? '';
                          _razaMadreName = selectedRaza?['name'] ?? '';
                        }
                      },
                    ),

                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKeyEditRaza.currentState?.validate() ??
                            false) {
                          _formKeyEditRaza.currentState?.save();
                          Navigator.pop(context);
                          updateRaza(
                            context,
                            widget.index.toString(),
                            name,
                            _razaPadreId,
                            _razaPadreName,
                            _razaMadreId,
                            _razaMadreName,
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

  Future<Map<String, dynamic>> getRazaDataById(
      BuildContext context, String id) async {
    final result =
        await Injector.of(context).razasRepository.getRazaDataById(id);
    return result;
  }

  Future<void> updateRaza(
    BuildContext context,
    String id,
    String name,
    String? id_raza_padre,
    String? name_raza_padre,
    String? id_raza_madre,
    String? name_raza_madre,
  ) async {
    final res = await Injector.of(context).razasRepository.updateRazaData(
          id,
          name,
          id_raza_padre,
          name_raza_padre,
          id_raza_madre,
          name_raza_madre,
        );
    widget.actualizarTexto('categoria actualizada');
    if (res == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("La raza ya fue registrada con anterioridad"),
        ),
      );
    }
  }
}
