import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieTooltip extends StatefulWidget {
  const PieTooltip({super.key});

  @override
  State<PieTooltip> createState() => _PieTooltipState();
}

class _PieTooltipState extends State<PieTooltip> {
  late String _selectedTooltipPosition;
  late TooltipPosition _tooltipPosition;
  late double _duration;
  late List<ChartSampleDataPieToolTip> _chartData;

  List<String>? _tooltipPositionList;

  @override
  void initState() {
    _selectedTooltipPosition = 'auto';
    _tooltipPosition = TooltipPosition.auto;
    _duration = 1;
    _tooltipPositionList = <String>['auto', 'pointer'].toList();
    _chartData = <ChartSampleDataPieToolTip>[
      ChartSampleDataPieToolTip(x: 'Trabalhista', y: 40, text: '45%'),
      ChartSampleDataPieToolTip(x: 'Criminal', y: 180, text: '53.7%'),
      ChartSampleDataPieToolTip(x: 'Civel', y: 190, text: '59.6%')
    ];
    super.initState();
  }

  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildTooltipPosition(stateSetter),
          ],
        );
      },
    );
  }

  /// Builds the widget for selecting tooltip position.
  Widget _buildTooltipPosition(StateSetter stateSetter) {
    return Row(
      children: <Widget>[
        Text(
          'Tooltip position',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
          height: 50,
          alignment: Alignment.bottomLeft,
          child: DropdownButton<String>(
            focusColor: Colors.transparent,
            underline: Container(
              color: const Color(0xFFBDBDBD),
              height: 1,
            ),
            value: _selectedTooltipPosition,
            items: _tooltipPositionList!.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                ),
              );
            }).toList(),
            onChanged: (dynamic value) {
              setState(() {
                _updateTooltipPosition(value.toString());
                stateSetter(() {});
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildPieTooltipPositionChart();
  }

  /// Returns a circular pie chart with tooltip.
  SfCircularChart _buildPieTooltipPositionChart() {
    return SfCircularChart(
      title: ChartTitle(
        text: 'Area - Atuação',
      ),
      legend:
          Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      series: _buildPieSeries(),

      /// To enable the tooltip and its behavior.
      tooltipBehavior: TooltipBehavior(
        enable: true,
        tooltipPosition: _tooltipPosition,
        duration: _duration * 1000,
      ),
    );
  }

  /// Returns the circular pie series.
  List<PieSeries<ChartSampleDataPieToolTip, String>> _buildPieSeries() {
    return <PieSeries<ChartSampleDataPieToolTip, String>>[
      PieSeries<ChartSampleDataPieToolTip, String>(
        dataSource: _chartData,
        xValueMapper: (ChartSampleDataPieToolTip data, int index) => data.x,
        yValueMapper: (ChartSampleDataPieToolTip data, int index) => data.y,
        dataLabelMapper: (ChartSampleDataPieToolTip data, int index) => data.x,
        startAngle: 100,
        endAngle: 100,
        pointRadiusMapper: (ChartSampleDataPieToolTip data, int index) =>
            data.text,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelPosition: ChartDataLabelPosition.outside,
        ),
      )
    ];
  }

  void _updateTooltipPosition(String item) {
    _selectedTooltipPosition = item;
    if (_selectedTooltipPosition == 'auto') {
      _tooltipPosition = TooltipPosition.auto;
    }
    if (_selectedTooltipPosition == 'pointer') {
      _tooltipPosition = TooltipPosition.pointer;
    }
    setState(() {
      /// Update the tooltip position changes.
    });
  }

  @override
  void dispose() {
    _chartData.clear();
    _tooltipPositionList!.clear();
    super.dispose();
  }
}

class ChartSampleDataPieToolTip {
  ChartSampleDataPieToolTip({this.x, this.y, this.text});

  final String? x;
  final double? y;
  final String? text;
}
