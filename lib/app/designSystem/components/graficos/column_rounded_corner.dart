import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ColumnRoundedCorner extends StatefulWidget {
  const ColumnRoundedCorner({super.key});

  @override
  State<ColumnRoundedCorner> createState() => _ColumnRoundedCornerState();
}

class _ColumnRoundedCornerState extends State<ColumnRoundedCorner> {
  TooltipBehavior? _tooltipBehavior;
  List<ChartSampleDataRoundedCorner>? _chartData;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      canShowMarker: false,
      format: 'Status - Causa',
      header: '',
    );
    _chartData = <ChartSampleDataRoundedCorner>[
      ChartSampleDataRoundedCorner(x: 'Ganha', y: 86),
      ChartSampleDataRoundedCorner(x: 'Em aberto', y: 23),
      ChartSampleDataRoundedCorner(x: 'Perdida', y: 40),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCartesianChart();
  }

  /// Return the Cartesian Chart with Column series.
  SfCartesianChart _buildCartesianChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: 'Status - Causa',
      ),
      primaryXAxis: CategoryAxis(
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        axisLine: const AxisLine(width: 0),
        labelPosition: ChartDataLabelPosition.inside,
        majorTickLines: const MajorTickLines(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        isVisible: false,
        minimum: 0,
        maximum: 150,
      ),
      series: _buildColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the list of Cartesian Column series.
  List<ColumnSeries<ChartSampleDataRoundedCorner, String>>
      _buildColumnSeries() {
    return <ColumnSeries<ChartSampleDataRoundedCorner, String>>[
      ColumnSeries<ChartSampleDataRoundedCorner, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleDataRoundedCorner sales, int index) =>
            sales.x,
        yValueMapper: (ChartSampleDataRoundedCorner sales, int index) =>
            sales.y,

        /// If we set the border radius value for Column series,
        /// then the series will appear as rounder corner.
        borderRadius: BorderRadius.circular(10),
        width: 0.9,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.top,
        ),
      ),
    ];
  }
}

class ChartSampleDataRoundedCorner {
  ChartSampleDataRoundedCorner({required this.x, required this.y});
  final String x;
  final double y;
}
