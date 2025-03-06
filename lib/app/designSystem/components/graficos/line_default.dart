import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineDefault extends StatefulWidget {
  const LineDefault({super.key});

  @override
  State<LineDefault> createState() => _LineDefaultState();
}

class _LineDefaultState extends State<LineDefault> {
  List<_ChartData>? _chartData;
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _chartData = <_ChartData>[
      _ChartData(2019, 21, 28),
      _ChartData(2020, 24, 44),
      _ChartData(2021, 36, 48),
      _ChartData(2022, 38, 50),
      _ChartData(2023, 54, 66),
      _ChartData(2024, 57, 78),
      _ChartData(2025, 70, 84),
    ];
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Line series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: 'Periodo',
      ),
      primaryXAxis: const NumericAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        interval: 2,
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        labelFormat: '{value}',
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(color: Colors.transparent),
      ),
      series: _buildLineSeries(),
      legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Line series.
  List<LineSeries<_ChartData, num>> _buildLineSeries() {
    return <LineSeries<_ChartData, num>>[
      LineSeries<_ChartData, num>(
        dataSource: _chartData,
        xValueMapper: (_ChartData sales, int index) => sales.x,
        yValueMapper: (_ChartData sales, int index) => sales.y,
        name: 'Trabalhista',
        markerSettings: const MarkerSettings(isVisible: true),
      ),
      LineSeries<_ChartData, num>(
        dataSource: _chartData,
        name: 'Criminal',
        xValueMapper: (_ChartData sales, int index) => sales.x,
        yValueMapper: (_ChartData sales, int index) => sales.y2,
        markerSettings: const MarkerSettings(isVisible: true),
      ),
    ];
  }

  @override
  void dispose() {
    _chartData!.clear();
    super.dispose();
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.y2);
  final double x;
  final double y;
  final double y2;
}
