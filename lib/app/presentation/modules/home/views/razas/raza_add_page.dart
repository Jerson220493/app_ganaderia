import 'package:app_ganaderia/main.dart';
import 'package:flutter/material.dart';

class FormModalRaza extends StatefulWidget {
  final Function(String) actualizarTexto;
  final List<Map<dynamic, dynamic>>? razas;
  const FormModalRaza({
    super.key,
    required this.actualizarTexto,
    this.razas,
  });

  @override
  _FormModalRazaState createState() => _FormModalRazaState();
}

class _FormModalRazaState extends State<FormModalRaza> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String? _razaPadreId;
  String? _razaPadreName = '';
  String? _razaMadreId = '';
  String? _razaMadreName = '';

  Future<void> insertData(
    BuildContext context,
    String name,
    String? idRazaPadre,
    String? nameRazaPadre,
    String? idRazaMadre,
    String? nameRazaMadre,
  ) async {
    final res = await Injector.of(context).razasRepository.insertRaza(
        name, idRazaPadre, nameRazaPadre, idRazaMadre, nameRazaMadre);
    if (res == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("La raza ya ha sido creada"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese su nombre';
                }
                return null;
              },
              onSaved: (value) {
                _name = value ?? '';
              },
            ),
            const SizedBox(height: 20),
            // correo electronico

            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: 'Raza padre'),
              value: null, // Valor inicial puede ser null si no hay selección
              items: widget.razas
                  ?.map((option) => DropdownMenuItem<int>(
                        value: option['id'], // Usamos el 'id' como valor
                        child: Text(
                            option['name']), // Mostramos el 'name' como texto
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  var selectedRaza = widget.razas
                      ?.firstWhere((option) => option['id'] == value);
                  // Almacena tanto el id como el name
                  _razaPadreId =
                      selectedRaza?['id'].toString() ?? ''; // Guarda el id
                  _razaPadreName = selectedRaza?['name']; // Guarda el name
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
              decoration: const InputDecoration(labelText: 'Raza madre'),
              value: null, // Valor inicial puede ser null si no hay selección
              items: widget.razas
                  ?.map((option) => DropdownMenuItem<int>(
                        value: option['id'], // Usamos el 'id' como valor
                        child: Text(
                            option['name']), // Mostramos el 'name' como texto
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  var selectedRaza = widget.razas
                      ?.firstWhere((option) => option['id'] == value);
                  // Almacena tanto el id como el name
                  _razaMadreId =
                      selectedRaza?['id'].toString() ?? ''; // Guarda el id
                  _razaMadreName = selectedRaza?['name']; // Guarda el name
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

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  await insertData(
                    context,
                    _name,
                    _razaPadreId,
                    _razaPadreName,
                    _razaMadreId,
                    _razaMadreName,
                  );
                  Navigator.of(context).pop(true);
                  widget.actualizarTexto('hello');
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
    );
  }
}
