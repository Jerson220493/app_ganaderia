import 'package:app_ganaderia/app/presentation/global/widgets/customer_drawer.dart';
import 'package:flutter/material.dart';

import '../../../../../../main.dart';
import '../../../../routes/routes.dart';
import 'raza_datatables.dart';

class RazaView extends StatefulWidget {
  const RazaView({super.key});

  @override
  State<RazaView> createState() => _RazaViewState();
}

class _RazaViewState extends State<RazaView> {
  final Color _color = Colors.indigo.shade400;

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
      body: const DataTableRazas(),
    );
  }
}
