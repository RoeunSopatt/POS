import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DonutPie extends StatelessWidget {
  final List<DonutPieData> data;
  final String title;

  const DonutPie({
    super.key,
    required this.data,
    this.title = 'Product Types',
  });

  @override
  Widget build(BuildContext context) {
    final TooltipBehavior _tooltip = TooltipBehavior(enable: true);

    return Column(
      children: [
        SfCircularChart(
          tooltipBehavior: _tooltip,
          series: <CircularSeries<DonutPieData, String>>[
            DoughnutSeries<DonutPieData, String>(
              dataSource: data,
              xValueMapper: (DonutPieData data, _) => data.x,
              yValueMapper: (DonutPieData data, _) => data.y,
              pointColorMapper: (DonutPieData data, _) => data.color,
              dataLabelMapper: (DonutPieData data, _) =>
                  NumberFormat.decimalPattern()
                      .format(data.y), // Formatting here
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelPosition: ChartDataLabelPosition.inside,
                textStyle: GoogleFonts.kantumruyPro(fontSize: 12),
              ),
              name: title,
              startAngle: 270,
              endAngle: 90,
            ),
          ],
          legend: const Legend(
            itemPadding: 10,
            toggleSeriesVisibility: true,
            height: '70%',
            isResponsive: true,
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
            position: LegendPosition.bottom,
            alignment: ChartAlignment.center,
          ),
        ),
      ],
    );
  }
}

// Helper class for data representation
class DonutPieData {
  final String x;
  final double y;
  final Color color;

  DonutPieData(this.x, this.y, this.color);
}

class StatisticChat extends StatefulWidget {
  final List<ChartData> data; // Use a generic ChartData class
  const StatisticChat({super.key, required this.data});

  @override
  StatisticChatState createState() => StatisticChatState();
}

class StatisticChatState extends State<StatisticChat> {
  late TooltipBehavior _tooltip = TooltipBehavior(enable: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis:
            const NumericAxis(minimum: 0, maximum: 2500000, interval: 100000),
        tooltipBehavior: _tooltip,
        series: <CartesianSeries<ChartData, String>>[
          ColumnSeries<ChartData, String>(
            dataSource: widget.data,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            name: 'Sales',
            color: const Color(0xFF0C7EA5),
          )
        ],
      ),
    );
  }
}

// ChartData class definition
class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}
