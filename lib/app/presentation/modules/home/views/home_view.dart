import 'package:app_ganaderia/app/domain/models/user.dart';
import 'package:app_ganaderia/main.dart';
import 'package:flutter/material.dart';
import '../../../routes/routes.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Color _color = Colors.indigo.shade400;
  late DateTime _initialDate, _date;

  @override
  void initState() {
    super.initState();
    _initialDate = DateTime(2010, 1);
    _date = _initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as User?;
    String name = '';
    String email = '';
    String photo = '';
    int perfil = 0;
    if (args != null) {
      name = args.name;
      email = args.email;
      photo = args.photo;
      perfil = args.perfil;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _color,
        actions: [
          IconButton(
            onPressed: _selectedDate,
            icon: const Icon(Icons.calendar_month),
          ),
          IconButton(
            // si initial date es diferente a la fecha inicial habilitamos el botom
            onPressed: _initialDate != _date ? () {} : null,
            icon: const Icon(Icons.save),
          ),
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
      drawer: SizedBox(
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(name),
                accountEmail: Text(email),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/users/$photo'),
                ),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade400,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Consultar'),
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    Routes.home,
                    arguments: '',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.app_registration),
                title: const Text('Registrar'),
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    Routes.home,
                    arguments: '',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.update),
                title: const Text('Actualizar'),
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    Routes.home,
                    arguments: '',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_chart_outlined),
                title: const Text('Informes'),
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    Routes.users,
                    arguments: '',
                  );
                },
              ),
              if (perfil == 1)
                ListTile(
                  leading: const Icon(Icons.group),
                  title: const Text('Usuarios'),
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      Routes.users,
                      arguments: args,
                    );
                  },
                ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Cerrar sesión'),
                onTap: () async {
                  Injector.of(context).authenticationRepository.signOut();
                  Navigator.pushReplacementNamed(context, Routes.signIn);
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: CalendarDatePicker(
          // Date time (año, mes, dia)
          // fecha inicial en que sale el calendario
          initialDate: _date,
          // first date fecha inicial para el calendario
          firstDate: DateTime(2010, 1),
          lastDate: DateTime.now(),
          // como se visualizara en forma inicial por año o normal
          initialCalendarMode: DatePickerMode.day,
          // deshabilitar todos los días sabados
          selectableDayPredicate: (date) {
            return date.weekday != 6;
          },
          onDateChanged: (date) {
            setState(() {
              _date = date;
            });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción cuando se presiona el botón
        },
        child: Icon(Icons.add),
        tooltip: 'Agregar',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _selectedDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000, 5),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _date = date;
      });
    }
  }
}
