import 'package:dropill_project/common/constants/app_colors.dart';
import 'package:dropill_project/common/constants/app_text_styles.dart';
import 'package:dropill_project/common/models/return_monitoring_model.dart';
import 'package:dropill_project/common/widgets/custom_monitoring_list.dart';
import 'package:dropill_project/features/monitoring/monitoring_controller.dart';
import 'package:dropill_project/features/monitoring/monitoring_state.dart';
import 'package:dropill_project/locator.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MonitoringPage extends StatefulWidget {
  const MonitoringPage({super.key});

  @override
  _MonitoringPageState createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  late MonitoringController _monitoringController;

  @override
  void initState() {
    super.initState();
    _monitoringController = locator.get<MonitoringController>();
    _monitoringController.listMonitoring();
  }

  List<FlSpot> _getSpots(List<ReturnMonitoring> monitorings) {
    // Processa os dados para criar uma lista de FlSpot com a contagem de monitoramentos diários
    List<FlSpot> spots = [];
    Map<DateTime, int> dailyCounts = {};

    for (var monitoring in monitorings) {
      DateTime? date = monitoring.dataHorario;
      if (date != null) {
        DateTime dayStart = DateTime(date.year, date.month, date.day);

        if (dailyCounts.containsKey(dayStart)) {
          dailyCounts[dayStart] = dailyCounts[dayStart]! + 1;
        } else {
          dailyCounts[dayStart] = 1;
        }
      }
    }

    // Ordena os dados por data
    List<MapEntry<DateTime, int>> sortedDailyCounts = dailyCounts.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Cria os FlSpot a partir dos dados ordenados
    for (int index = 0; index < sortedDailyCounts.length; index++) {
      DateTime date = sortedDailyCounts[index].key;
      int count = sortedDailyCounts[index].value;
      spots.add(FlSpot(index.toDouble(), count.toDouble()));
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _monitoringController,
        builder: (context, child) {
          if (_monitoringController.state is MonitoringStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (_monitoringController.state is MonitoringStateError) {
            return const Center(
              child: Text(
                'Erro ao carregar dados',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          // Processamento dos dados para o gráfico
          List<FlSpot> spots = _getSpots(_monitoringController.monitoringList);
          print('Spots: $spots'); // Verifique os dados de entrada

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48.0),
                Text(
                  'Monitoramentos diários',
                  style: AppTextStyles.mediumText20.copyWith(color: AppColors.standartBlue),
                ),
                const SizedBox(height: 32.0),

                SizedBox(
                  height: 300,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: AppColors.standartBlue,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                      lineTouchData: LineTouchData(enabled: false),
                      minX: spots.isNotEmpty ? spots.first.x : 0.0,
                      maxX: spots.isNotEmpty ? spots.last.x : 1.0,
                      minY: 0.0,
                      maxY: spots.isNotEmpty ? spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) : 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                _monitoringController.monitoringList.isNotEmpty
                    ? CustomMonitoringList(monitoring: _monitoringController.monitoringList)
                    : Container(
                  alignment: Alignment.center,
                  height: 120,
                  child: Text(
                    'Nenhum monitoramento disponível',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.mediumText16w500.copyWith(color: AppColors.grey),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
