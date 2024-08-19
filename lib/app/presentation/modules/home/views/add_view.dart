import 'package:app_ganaderia/app/presentation/global/widgets/customer_drawer.dart';
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
  @override
  final Color _color = Colors.indigo.shade400;
  bool _fetching = false;

  // variables para manejar los datos de ingreso
  String _peso = '', _estatura = '', _raza = '', _genero = '';

  @override
  void initState() {
    super.initState();
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
          child: AbsorbPointer(
            absorbing: _fetching,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  "Registro de bobino",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: const Key('add-peso'),
                  onChanged: (value) {
                    setState(() {
                      _peso = value.trim().toLowerCase();
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'peso',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                  validator: (value) {
                    value = value?.trim().toLowerCase() ?? '';
                    if (value.isEmpty) {
                      return 'Invalid user name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: const Key('add-estatura'),
                  onChanged: (value) {
                    setState(() {
                      _estatura = value.replaceAll(' ', '').toLowerCase();
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'estatura',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                  validator: (value) {
                    value = value?.trim().toLowerCase() ?? '';
                    if (value.isEmpty) {
                      return 'Estatura invalida';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: const Key('add-raza'),
                  onChanged: (value) {
                    setState(() {
                      _raza = value.replaceAll(' ', '').toLowerCase();
                    });
                  },
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'raza',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                  validator: (value) {
                    value = value?.trim().toLowerCase() ?? '';
                    if (value.isEmpty) {
                      return 'Raza invalida';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: const Key('add-genero'),
                  onChanged: (value) {
                    setState(() {
                      _raza = value.replaceAll(' ', '').toLowerCase();
                    });
                  },
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'genero',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                  validator: (value) {
                    value = value?.trim().toLowerCase() ?? '';
                    if (value.isEmpty) {
                      return 'genero';
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
                      onPressed: () {
                        final isValid = Form.of(context).validate();
                        if (isValid) {
                          _submit(context);
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
