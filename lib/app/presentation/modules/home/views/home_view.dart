import 'package:app_ganaderia/app/domain/models/user.dart';
import 'package:app_ganaderia/main.dart';
import 'package:flutter/material.dart';
import '../../../global/widgets/customer_drawer.dart';
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
      drawer: const CustomerDrawer(),
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
        tooltip: 'Agregar',
        child: const Icon(Icons.add),
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
