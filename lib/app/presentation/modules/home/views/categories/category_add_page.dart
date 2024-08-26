import 'package:app_ganaderia/main.dart';
import 'package:flutter/material.dart';

class FormModal extends StatefulWidget {
  final Function(String) actualizarTexto;
  const FormModal({super.key, required this.actualizarTexto});

  @override
  _FormModalState createState() => _FormModalState();
}

class _FormModalState extends State<FormModal> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';

  Future<void> insertData(
    BuildContext context,
    String name,
  ) async {
    final res =
        await Injector.of(context).categoriesRepository.insertCategory(name);
    if (res == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("La categoria ya ha sido creada"),
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
            // correo electronico

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  await insertData(context, _name);
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
