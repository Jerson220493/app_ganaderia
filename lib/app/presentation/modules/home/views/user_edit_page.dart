import 'package:flutter/material.dart';
// import 'package:flutter_application_ganaderia/database/localDb.dart';
// import 'package:flutter_application_ganaderia/models/user_data.dart';

class FormEditModal extends StatefulWidget {
  final int index;
  FormEditModal({
    this.index = 1,
  });
  @override
  _FormEditModalState createState() => _FormEditModalState();
}

class _FormEditModalState extends State<FormEditModal> {
  final _formKeyEdit = GlobalKey<FormState>();
  late String name;
  late String email;
  String perfil = '';
  late String password;
  // UserData? userData;

  @override
  void initState() {
    super.initState();
    // _fetchUserData();
  }

  // Future<void> _fetchUserData() async {
  //   userData = await _loadData(widget.index.toString());
  //   name = userData!.name;
  //   email = userData!.email;
  //   perfil = userData!.perfil;
  //   password = userData!.password;
  //   setState(() {}); // Llama a setState para actualizar la UI
  // }

  // Future<UserData> _loadData(String id) async {
  //   final _data = await LocalDatabase().getUserById(id: id);
  //   String name = _data['name']!;
  //   String email = _data['email']!;
  //   String perfil = _data['perfil']!;
  //   String password = '';

  //   return UserData(
  //     name: name,
  //     email: email,
  //     perfil: perfil,
  //     password: password,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: const Text(
            // key: _formKeyEdit,
            // child: userData == null
            //     ? Center(child: CircularProgressIndicator())
            //     : Column(
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           TextField(
            //             onChanged: (value) {
            //               name = value;
            //             },
            //             controller: TextEditingController(text: userData!.name),
            //             decoration: InputDecoration(labelText: 'Nombre'),
            //           ),
            //           TextField(
            //             onChanged: (value) {
            //               email = value;
            //             },
            //             controller: TextEditingController(text: userData!.email),
            //             decoration:
            //                 InputDecoration(labelText: 'Correo Electronico'),
            //             keyboardType: TextInputType.emailAddress,
            //           ),
            //           SingleChildScrollView(
            //             child: DropdownButtonFormField<String>(
            //               decoration: InputDecoration(labelText: 'Perfil'),
            //               value:
            //                   userData!.perfil.isEmpty ? null : userData!.perfil,
            //               items: ['Administrador', 'Operador']
            //                   .map((option) => DropdownMenuItem(
            //                         value: option,
            //                         child: Text(option),
            //                       ))
            //                   .toList(),
            //               onChanged: (value) {
            //                 setState(() {
            //                   perfil = value ?? '';
            //                 });
            //               },
            //               validator: (value) {
            //                 if (value == null || value.isEmpty) {
            //                   return 'Por favor, seleccione una opción';
            //                 }
            //                 return null;
            //               },
            //               onSaved: (value) {
            //                 perfil = value ?? '';
            //               },
            //             ),
            //           ),
            //           TextFormField(
            //             autovalidateMode: AutovalidateMode.onUserInteraction,
            //             key: const Key('user-pass'),
            //             onChanged: (value) {
            //               password = value.replaceAll(' ', '');
            //             },
            //             obscureText: true,
            //             decoration: const InputDecoration(
            //               label: Text('Contraseña'),
            //             ),
            //             validator: (value) {
            //               value = value ?? '';
            //               if (value.length >= 8) {
            //                 return null;
            //               }
            //               return 'Invalid password';
            //             },
            //             onSaved: (value) {
            //               password = value ?? '';
            //             },
            //           ),
            //           SizedBox(
            //             height: 40,
            //           ),
            //           ElevatedButton(
            //             onPressed: () async {
            //               if (_formKeyEdit.currentState?.validate() ?? false) {
            //                 _formKeyEdit.currentState?.save();
            //                 Navigator.pop(context);
            //                 // Aquí puedes manejar los datos del formulario
            //                 await LocalDatabase().updateUser(
            //                   email: email,
            //                   id: widget.index,
            //                   name: name,
            //                   password: password,
            //                   perfil: perfil,
            //                 );
            //                 setState(() {});
            //               }
            //             },
            //             style: ElevatedButton.styleFrom(
            //               backgroundColor: Colors.indigo.shade400,
            //               shadowColor: Colors.black, // Color de la sombra
            //               elevation: 5, // Elevación del botón
            //               padding: EdgeInsets.symmetric(
            //                   horizontal: 30, vertical: 15), // Padding del botón
            //               textStyle: TextStyle(
            //                   color: Colors.white,
            //                   fontSize: 16,
            //                   fontWeight: FontWeight.bold), // Estilo del texto
            //             ),
            //             child: Text(
            //               'Guardar',
            //               style: TextStyle(color: Colors.white),
            //             ),
            //           ),
            //         ],
            //       ),
            'hello '),
      ),
    );
  }
}
