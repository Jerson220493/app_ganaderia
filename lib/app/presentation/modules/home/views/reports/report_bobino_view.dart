import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../../../main.dart';

class ReportBobinoView extends StatefulWidget {
  @override
  State<ReportBobinoView> createState() => _ReportBobinoViewState();
}

class _ReportBobinoViewState extends State<ReportBobinoView> {
  List<Map<String, dynamic>> razaData = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    try {
      razaData = await _loadData();
      if (razaData.isEmpty) {
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
    final result =
        await Injector.of(context).coreRepository.getDataBobinoReport();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfico de Pesos por Raza'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: razaData == null
            ? const Center(
                child: CircularProgressIndicator(),
              ) // Mostrar indicador de carga
            : razaData.isEmpty
                ? Center(child: Text('No hay datos disponibles'))
                : SingleChildScrollView(
                    child: Column(
                      children: _buildRazaCharts(razaData),
                    ),
                  ),
      ),
    );
  }

  List<Widget> _buildRazaCharts(List<Map<String, dynamic>> data) {
    // Agrupamos los datos por raza
    Map<String, List<Map<String, dynamic>>> groupedData = {};
    for (var item in data) {
      String raza = item['raza'];
      if (!groupedData.containsKey(raza)) {
        groupedData[raza] = [];
      }
      groupedData[raza]?.add(item);
    }

    // Creamos un gráfico para cada raza
    return groupedData.entries.map((entry) {
      String raza = entry.key;
      List<Map<String, dynamic>> razaSpecificData = entry.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            raza,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < razaSpecificData.length) {
                          return Text(
                            razaSpecificData[index]['date'],
                            style: TextStyle(fontSize: 10),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                gridData: FlGridData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: _generateDataSpots(razaSpecificData),
                    isCurved: true,
                    color: Colors.blue,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20), // Separación entre gráficos
        ],
      );
    }).toList();
  }

  List<FlSpot> _generateDataSpots(List<Map<String, dynamic>> data) {
    // Convertimos el total_peso a puntos FlSpot para la gráfica
    return data.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> row = entry.value;
      return FlSpot(index.toDouble(), (row['total_peso'] as num).toDouble());
    }).toList();
  }
}
