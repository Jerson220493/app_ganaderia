import 'package:app_ganaderia/app/domain/models/bobino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../../../../main.dart';
import '../../../routes/routes.dart';

class ConsultarView extends StatefulWidget {
  const ConsultarView({super.key});

  @override
  State<ConsultarView> createState() => _ConsultarViewState();
}

class _ConsultarViewState extends State<ConsultarView> {
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
        automaticallyImplyLeading: false,
      ),
      body: const BobinoSearchScreen(),
    );
  }
}

class BobinoSearchScreen extends StatefulWidget {
  const BobinoSearchScreen({super.key});

  @override
  _BobinoSearchScreenState createState() => _BobinoSearchScreenState();
}

class _BobinoSearchScreenState extends State<BobinoSearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  String? _qrData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de Bobino'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo para ingresar el ID del bobino
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'ID del Bobino',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (_qrData == null && (value == null || value.isEmpty)) {
                    return 'Por favor ingresa el ID o escanea el QR';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Botón para escanear el QR
              ElevatedButton.icon(
                onPressed: () async {
                  //Navegar a la pantalla del escáner QR
                  final qrResult = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QrScannerScreen(),
                    ),
                  );

                  if (qrResult != null) {
                    setState(() {
                      _qrData = qrResult;
                    });
                  }
                },
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Escanear QR'),
              ),
              const SizedBox(height: 16.0),
              if (_qrData != null) ...[
                Text(
                  'Código QR escaneado: $_qrData',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
              const SizedBox(height: 24.0),
              // Botón para consultar (ya sea por ID o por QR)
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_qrData != null) {
                      //Si hay QR escaneado, consultar con QR
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BobinoDetailScreen(qr: _qrData),
                        ),
                      );
                    } else if (_idController.text.isNotEmpty) {
                      // Si no hay QR, consultar por ID
                      final id = int.tryParse(_idController.text);
                      if (id != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BobinoDetailScreen(id: id),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('ID inválido')),
                        );
                      }
                    }
                  }
                },
                child: const Text('Consultar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({Key? key}) : super(key: key);

  @override
  _QrScannerScreenState createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrData;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear QR')),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrData = scanData.code;
      });
      // Devuelve el valor escaneado y cierra la pantalla
      Navigator.pop(context, qrData);
    });
  }
}

///////////////////////////////////////////////////////////////////////////////
////////////////////////// bobino detail //////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class BobinoDetailScreen extends StatefulWidget {
  final int? id;
  final String? qr;

  const BobinoDetailScreen({Key? key, this.id, this.qr}) : super(key: key);

  @override
  State<BobinoDetailScreen> createState() => _BobinoDetailScreenState();
}

class _BobinoDetailScreenState extends State<BobinoDetailScreen> {
  bool _loading = true; // Para manejar el estado de carga
  bool _hasError = false; // Para manejar el estado de error
  final _formKey = GlobalKey<FormState>();
  Bobino bobinoData = Bobino('', null, null, null, null, null);
  late String name = '';
  late String? categoria;
  late String? raza;
  late String? genero;
  late String? fechaNacimiento;
  late String? pesoInicial;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchBobinoData();
    });
  }

  Future<void> _fetchBobinoData() async {
    try {
      bobinoData = await _loadData(widget.id.toString());
      print(bobinoData.name);
      if (bobinoData.name == '') {
        // Si no se encuentran datos, lanzamos un error
        throw Exception("No se encontraron datos para el bobino");
      }
      name = bobinoData.name;
      categoria = bobinoData.categoria;
      raza = bobinoData.raza;
      genero = bobinoData.genero;
      fechaNacimiento = bobinoData.fechaNacimiento;
      pesoInicial = bobinoData.pesoInicial;
      setState(() {
        _loading = false; // Datos cargados correctamente
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _hasError = true; // Ocurrió un error al obtener los datos
      });
    }
  }

  Future<Bobino> _loadData(String id) async {
    final data = await getBobinoDataById(context, id);
    String name = data['name'];
    String? categoria = data['categoria'].toString();
    String? raza = data['raza'].toString();
    String? genero = data['genero'].toString();
    String? fechaNacimiento = data['fecha_nacimiento'].toString();
    String? pesoInicial = data['peso_inicial'].toString();

    return Bobino(
      name,
      categoria,
      raza,
      genero,
      fechaNacimiento,
      pesoInicial,
    );
  }

  Future<Map<String, dynamic>> getBobinoDataById(
      BuildContext context, String id) async {
    final result =
        await Injector.of(context).coreRepository.getBobinoDataById(id);
    return result;
  }

  Future<void> updateData(
      BuildContext context,
      String id,
      String name,
      String categoria,
      String raza,
      String genero,
      String? fechaNacimiento,
      int peso) async {
    final res = await Injector.of(context).coreRepository.insertUpdateBobino(
        id, name, categoria, raza, genero, fechaNacimiento, peso);
    await Navigator.pushNamed(
      context,
      Routes.home,
    );
  }

  @override
  final Color _color = Colors.indigo.shade400;
  bool _fetching = false;
  List<Map<dynamic, dynamic>>? razas;
  List<Map<dynamic, dynamic>>? categories;
  // variables para manejar los datos de ingreso
  String _name = '', _genero = '';
  int _peso = 0;
  String _raza = '', _categoria = '';
  DateTime? _selectedDate;

  Future<List<Map<dynamic, dynamic>>> getDataRazas(BuildContext context) async {
    final result = await Injector.of(context).razasRepository.getRazasData();
    return result;
  }

  Future<List<Map<dynamic, dynamic>>> getDataCategories(
      BuildContext context) async {
    final result =
        await Injector.of(context).categoriesRepository.getCategoriesData();
    return result;
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? const Center(
                  child: Text("Error al obtener los datos del bobino."))
              : SafeArea(
                  child: Form(
                    key: _formKey,
                    child: AbsorbPointer(
                      absorbing: _fetching,
                      child: ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          const Text(
                            "Actualización",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            readOnly: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            key: const Key('name'),
                            onChanged: (value) {
                              setState(() {
                                _name = value.trim().toLowerCase();
                              });
                            },
                            controller:
                                TextEditingController(text: bobinoData.name),
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              hintText: 'Name',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                            ),
                            validator: (value) {
                              value = value?.trim().toLowerCase() ?? '';
                              if (value.isEmpty) {
                                return 'Invalid name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          FutureBuilder<List<Map<dynamic, dynamic>>>(
                            future: getDataCategories(context),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text('No data available'));
                              } else {
                                categories = snapshot.data!;
                                return DropdownButtonFormField<int>(
                                  decoration: const InputDecoration(
                                    labelText: 'Categoria',
                                    hintText:
                                        'Categoria', // Cambia el hintText a lo que desees
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                  ),
                                  // decoration: const InputDecoration(labelText: 'Raza'),
                                  value: (bobinoData.categoria != null &&
                                          (bobinoData.categoria ?? '')
                                              .isNotEmpty)
                                      ? int.parse(bobinoData.categoria!)
                                      : null, // Mantiene el valor seleccionado // Valor inicial puede ser null si no hay selección
                                  items: categories!
                                      .map((option) => DropdownMenuItem<int>(
                                            value: option['id'],
                                            child: Text(option['name']),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _categoria = value.toString();
                                    });
                                  },
                                  onSaved: (value) {
                                    if (value != null) {
                                      _categoria = value.toString();
                                    }
                                  },
                                );
                              }
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          FutureBuilder<List<Map<dynamic, dynamic>>>(
                            future: getDataRazas(context),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text('No data available'));
                              } else {
                                razas = snapshot.data!;
                                return DropdownButtonFormField<int>(
                                  decoration: const InputDecoration(
                                    labelText: 'Raza',
                                    hintText:
                                        'Raza', // Cambia el hintText a lo que desees
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                  ),
                                  // decoration: const InputDecoration(labelText: 'Raza'),
                                  value: (bobinoData.raza != null &&
                                          (bobinoData.raza ?? '').isNotEmpty)
                                      ? int.parse(bobinoData.raza!)
                                      : null, // Mantiene el valor seleccionado // Valor inicial puede ser null si no hay selección
                                  items: razas!
                                      .map((option) => DropdownMenuItem<int>(
                                            value: option['id'],
                                            child: Text(option['name']),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _raza = value.toString();
                                    });
                                  },
                                  onSaved: (value) {
                                    if (value != null) {
                                      _raza = value.toString();
                                    }
                                  },
                                );
                              }
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Genero',
                              hintText:
                                  'Genero', // Cambia el hintText a lo que desees
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                            ),
                            value: (bobinoData.genero != null &&
                                    (bobinoData.genero ?? '').isNotEmpty)
                                ? (bobinoData.genero!)
                                : null,
                            items: ['Macho', 'Hembra']
                                .map((option) => DropdownMenuItem(
                                      value: option,
                                      child: Text(option),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _genero = value ?? '';
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, seleccione una opción';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _genero = value ?? '';
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            readOnly:
                                true, // Hace que el campo no sea editable directamente
                            decoration: const InputDecoration(
                              labelText: 'Fecha de nacimiento',
                              hintText: 'Seleccione una fecha',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                            ),

                            controller: TextEditingController(
                                text: bobinoData.fechaNacimiento),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            key: const Key('peso'),
                            onChanged: (value) {
                              setState(() {
                                _peso = int.parse(value);
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Peso actual',
                              hintText: 'Peso actual',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                            ),
                            validator: (value) {
                              value = value?.trim().toLowerCase() ?? '';
                              if (value.isEmpty) {
                                return 'Invalid peso actual';
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
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              return ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    _formKey.currentState?.save();
                                    await updateData(
                                      context,
                                      widget.id.toString(),
                                      _name,
                                      _categoria,
                                      _raza,
                                      _genero,
                                      _selectedDate.toString(),
                                      _peso,
                                    );
                                    Navigator.of(context).pop(true);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.indigo.shade400, // Color de fondo
                                  foregroundColor:
                                      Colors.white, // Color del texto
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

    if (!mounted) {
      return;
    }
  }
}
