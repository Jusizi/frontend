import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieGradient extends StatefulWidget {
  const PieGradient({super.key});

  @override
  State<PieGradient> createState() => _PieGradientState();
}

class _PieGradientState extends State<PieGradient> {
  late List<ChartSampleDataPieGradient> _chartData;

  List<Color>? _gradientColors;
  List<double>? _gradientStops;
  void _initializeVariables() {
    _gradientColors = const <Color>[
      Color.fromRGBO(96, 87, 234, 1),
      Color.fromRGBO(59, 141, 236, 1),
      Color.fromRGBO(112, 198, 129, 1),
      Color.fromRGBO(237, 241, 81, 1)
    ];
    _gradientStops = <double>[0.25, 0.5, 0.75, 1];
    _chartData = <ChartSampleDataPieGradient>[
      ChartSampleDataPieGradient(x: 'David', y: 17, text: 'David \n 17%'),
      ChartSampleDataPieGradient(x: 'Steve', y: 20, text: 'Steve \n 20%'),
      ChartSampleDataPieGradient(x: 'Jack', y: 25, text: 'Jack \n 25%'),
      ChartSampleDataPieGradient(x: 'Others', y: 38, text: 'Others \n 38%')
    ];
  }

  @override
  void initState() {
    _initializeVariables();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDefaultPieChart();
  }

  List<PieSeries<ChartSampleDataPieGradient, String>> _buildDefaultPieSeries() {
    return <PieSeries<ChartSampleDataPieGradient, String>>[
      PieSeries<ChartSampleDataPieGradient, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleDataPieGradient data, int index) => data.x,
        yValueMapper: (ChartSampleDataPieGradient data, int index) => data.y,
        animationDuration: 1500,
        explodeAll: true,
        explodeOffset: '3%',
        explode: true,
        strokeWidth: 2,
        dataLabelMapper: (ChartSampleDataPieGradient data, int index) =>
            data.text,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          textStyle: TextStyle(fontSize: 13, color: Colors.white),
        ),
      ),
    ];
  }

  /// Returns a circular pie chart filled with a gradient.
  SfCircularChart _buildDefaultPieChart() {
    return SfCircularChart(
      onCreateShader: (ChartShaderDetails chartShaderDetails) {
        return ui.Gradient.sweep(
          chartShaderDetails.outerRect.center,
          _gradientColors!,
          _gradientStops,
          TileMode.repeated,
        );
      },
      title: ChartTitle(text: 'Sales by sales person'),
      series: _buildDefaultPieSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }
}

class ChartSampleDataPieGradient {
  ChartSampleDataPieGradient({this.x, this.y, this.text});

  final String? x;
  final double? y;
  final String? text;
}
