import 'package:app_ganaderia/app/domain/models/user.dart';
import 'package:app_ganaderia/main.dart';
import 'package:flutter/material.dart';

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
  final _formKeyEdit = GlobalKey<FormState>();
  late String name;
  late String email;
  late String photo;
  late int perfil_selected;
  late String perfil;
  late String password;
  User userData = User('', '', '', 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserData();
    });
  }

  Future<void> _fetchUserData() async {
    userData = await _loadData(widget.index.toString());
    name = userData.name;
    email = userData.email;
    photo = userData.photo;
    perfil_selected = userData.perfil;
    password = '';
    setState(() {}); // Llama a setState para actualizar la UI
  }

  Future<User> _loadData(String id) async {
    final _data = await getUserDataById(context, id);
    String name = _data['name'];
    String email = _data['email'];
    String photo = _data['photo'];
    String perfil_d = _data['perfil'];

    return User(
      name,
      email,
      photo,
      int.parse(perfil_d),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKeyEdit,
          child: userData.name == ''
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        name = value;
                      },
                      controller: TextEditingController(text: userData.name),
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                    TextField(
                      onChanged: (value) {
                        email = value;
                      },
                      controller: TextEditingController(text: userData.email),
                      decoration: const InputDecoration(
                          labelText: 'Correo Electronico'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SingleChildScrollView(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Perfil'),
                        value:
                            perfil_selected == 1 ? 'Administrador' : 'Operador',
                        items: ['Administrador', 'Operador']
                            .map((option) => DropdownMenuItem(
                                  value: option,
                                  child: Text(option),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            perfil = value ?? '';
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, seleccione una opción';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          perfil = value ?? '';
                        },
                      ),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: const Key('user-pass'),
                      onChanged: (value) {
                        password = value.replaceAll(' ', '');
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
                        password = value ?? '';
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKeyEdit.currentState?.validate() ?? false) {
                          _formKeyEdit.currentState?.save();
                          Navigator.pop(context);
                          // Aquí puedes manejar los datos del formulario
                          int auxPerfil = (perfil == 'Administrador') ? 1 : 2;
                          updateUser(context, widget.index.toString(), name,
                              email, password, auxPerfil);
                          // setState(() {});
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

  Future<Map<String, dynamic>> getUserDataById(
      BuildContext context, String id) async {
    final result =
        await Injector.of(context).usersRepository.getUserDataById(id);
    return result;
  }

  Future<void> updateUser(BuildContext context, String id, String name,
      String email, String password, int perfil) async {
    final res = await Injector.of(context)
        .usersRepository
        .updateUserData(id, name, email, perfil, password);
    print("Resultado de la actualizacion $res");
    if (res == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("El email ya fue registrado en otro usuario"),
        ),
      );
    }
  }
}
