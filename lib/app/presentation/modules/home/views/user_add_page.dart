import 'package:app_ganaderia/main.dart';
import 'package:flutter/material.dart';

class FormModal extends StatefulWidget {
  const FormModal({super.key});

  @override
  _FormModalState createState() => _FormModalState();
}

class _FormModalState extends State<FormModal> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _perfil = '';
  String _password = '';

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
            TextFormField(
              key: const Key('login-email'),
              onChanged: (text) {
                _email = text.trim();
              },
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                label: Text('Email'),
              ),
              validator: (text) {
                text = text ?? '';
                final isValid = RegExp(
                        r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                    .hasMatch(text);
                if (isValid) {
                  return null;
                }
                return 'Invalid email';
              },
              onSaved: (value) {
                _email = value ?? '';
              },
            ),
            // perfiles
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Perfil'),
              value: _perfil.isEmpty ? null : _perfil,
              items: ['Administrador', 'Operador']
                  .map((option) => DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _perfil = value ?? '';
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, seleccione una opción';
                }
                return null;
              },
              onSaved: (value) {
                _perfil = value ?? '';
              },
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: const Key('user-pass'),
              onChanged: (value) {
                _password = value.replaceAll(' ', '');
              },
              obscureText: true,
              decoration: const InputDecoration(
                label: Text('Contraseña'),
              ),
              validator: (value) {
                value = value ?? '';
                if (value.length >= 8) {
                  return null;
                }
                return 'Invalid password';
              },
              onSaved: (value) {
                _password = value ?? '';
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  Navigator.pop(context);
                  int auxP = _perfil == 'Administrador' ? 1 : 0;
                  insertData(context, _name, _email, _password, auxP);
                  setState(() {});
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

Future<int> insertData(BuildContext context, String name, String email,
    String password, int perfil) async {
  final result = await Injector.of(context)
      .usersRepository
      .insertUser(name, email, password, perfil);
  return result;
}
