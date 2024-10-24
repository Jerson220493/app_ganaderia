import 'package:app_ganaderia/app/domain/models/user.dart';
import 'package:app_ganaderia/main.dart';
import 'package:flutter/material.dart';
import '../../../global/widgets/customer_drawer.dart';
import '../../../routes/routes.dart';

class Event {
  final DateTime date;
  final String title;
  Event({required this.date, required this.title});
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Color _color = Colors.indigo.shade400;
  late DateTime _initialDate, _date;
  List<Map<String, dynamic>> eventsDb = [];

  @override
  void initState() {
    super.initState();
    _initialDate = DateTime.now();
    _date = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    try {
      eventsDb = await _loadData();
      if (eventsDb.isEmpty) {
        // Si no se encuentran datos, lanzamos un error
        throw Exception("No se encontraron datos para el bobino");
      }
      setState(() {});
    } catch (e) {
      print('error obteniendo datos');
      print(e);
    }
  }

  Future<List<Map<String, dynamic>>> _loadData() async {
    final data = await getData(context);
    return data;
  }

  Future<List<Map<String, dynamic>>> getData(BuildContext context) async {
    final result = await Injector.of(context).coreRepository.getEvents();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    List<Event> events = [];
    for (var item in eventsDb) {
      // Aquí puedes agregar la lógica para asignar una fecha si es necesario
      // En este caso, se agrega un evento con fecha actual (por ejemplo)
      events.add(Event(
          date: DateTime.parse(item['date']), title: item['title'].toString()));
    }

    // Mapa para almacenar eventos por fecha
    Map<DateTime, List<Event>> eventsByDate = {};

    // Agrupar eventos por fecha
    for (var event in events) {
      eventsByDate.putIfAbsent(event.date, () => []).add(event);
    }

    // Método para obtener eventos en una fecha específica
    List<Event> getEventsForDate(DateTime date) {
      print(eventsByDate[date]);
      return eventsByDate[date] ?? [];
    }

    Future<void> saveEvent(Event event) async {
      // Aquí puedes agregar la lógica para guardar el evento en la base de datos
      // Esto es solo un ejemplo para ilustrar la idea
      // await database.insert('events', {'date': event.date, 'title': event.title});
      final res = await Injector.of(context)
          .coreRepository
          .insertEvent(event.date, event.title);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _color,
        actions: [
          IconButton(
            onPressed: () async {
              // Lógica para seleccionar una fecha
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );

              // Si el usuario seleccionó una fecha
              if (selectedDate != null) {
                // Mostrar un dialogo para agregar un título al evento
                TextEditingController eventController = TextEditingController();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Agregar Evento"),
                      content: TextField(
                        controller: eventController,
                        decoration:
                            InputDecoration(hintText: "Título del evento"),
                      ),
                      actions: [
                        TextButton(
                          child: Text("Cancelar"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text("Guardar"),
                          onPressed: () async {
                            String title = eventController.text;
                            if (title.isNotEmpty) {
                              // Guardar el evento en la base de datos
                              Event newEvent =
                                  Event(date: selectedDate, title: title);
                              await saveEvent(newEvent);

                              // Actualizar la UI
                              setState(() {
                                _date = selectedDate;
                              });

                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
            icon: const Icon(Icons.calendar_month),
          ),
          IconButton(
            // si initial date es diferente a la fecha inicial habilitamos el botom
            onPressed: () async {
              await syncDatabase();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sincronización en proceso'),
                  duration: Duration(seconds: 5), // Mostrar por 5 segundos
                ),
              );
            },
            icon: const Icon(Icons.autorenew),
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
          onDateChanged: (date) {
            setState(() {
              _date = date;
              // Obtener eventos para la fecha seleccionada
              List<Event> selectedEvents = getEventsForDate(_date);
              if (selectedEvents.isNotEmpty) {
                // Aquí puedes mostrar los eventos en un diálogo o en la interfaz
                print(
                    "Eventos en esta fecha: ${selectedEvents.map((e) => e.title).toList()}");
              }
            });
            // Mostrar evento si hay en la fecha seleccionada
            Event? selectedEvent = events.isNotEmpty
                ? events.firstWhere(
                    (event) => event.date == date,
                    orElse: () => Event(date: DateTime.now(), title: ''),
                  )
                : null;

            if (selectedEvent != null) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Evento en esta fecha"),
                    content: Text(selectedEvent.title),
                    actions: [
                      TextButton(
                        child: Text("Cerrar"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
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

  Future syncDatabase() async {}
}
