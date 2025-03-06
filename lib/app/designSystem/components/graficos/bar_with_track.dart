import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarWithTrack extends StatefulWidget {
  const BarWithTrack({super.key});

  @override
  State<BarWithTrack> createState() => _BarWithTrackState();
}

class _BarWithTrackState extends State<BarWithTrack> {
  /// Return the Cartesian Chart with Bar series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: ChartTitle(
          text: 'Processos',
        ),
        primaryXAxis: const CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 0),
          title: AxisTitle(
            text: 'Quantidade',
          ),
          minimum: 0,
          maximum: 10,
          majorTickLines: const MajorTickLines(size: 0),
        ),
        series: <BarSeries<ChartSampleData, String>>[
          BarSeries<ChartSampleData, String>(
            dataSource: <ChartSampleData>[
              ChartSampleData(x: 'Elixir', y: 5.9),
              ChartSampleData(x: 'Clojure', y: 7),
              ChartSampleData(x: 'Ruby', y: 7),
              ChartSampleData(x: 'Java', y: 8),
              ChartSampleData(x: 'C#', y: 8.3),
              ChartSampleData(x: 'PHP', y: 10),
            ],
            xValueMapper: (ChartSampleData sales, int index) => sales.x,
            yValueMapper: (ChartSampleData sales, int index) => sales.y,

            /// Enable this property as true to show the track of series.
            isTrackVisible: true,
            trackColor: const Color.fromRGBO(198, 201, 207, 1),
            borderRadius: BorderRadius.circular(15),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
            ),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }
}

class ChartSampleData {
  final String x;
  final num y;
  ChartSampleData({
    required this.x,
    required this.y,
  });
}
