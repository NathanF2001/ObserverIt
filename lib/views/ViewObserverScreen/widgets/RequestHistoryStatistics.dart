import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:observerit/entities/Request.dart';
import 'package:observerit/entities/StatisticsView.dart';

class RequestHistoryStatistics extends StatefulWidget {

  List<Request> requests;
  StatisticsView statistics;

  RequestHistoryStatistics({super.key, required this.requests, required this.statistics});

  @override
  State<RequestHistoryStatistics> createState() =>
      _RequestHistoryStatisticsState();
}

class _RequestHistoryStatisticsState extends State<RequestHistoryStatistics> {

  List<Color> gradientColors = [
    Color(0xff7558a5),
    Color(0xff6000fd),
  ];

  formatDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day}T${date.hour}:${date.minute}";
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    final DateTime date = requests[value.toInt()].date!;

    //return Text(formatDate(date), style: style, textAlign: TextAlign.left);

    return SideTitleWidget(
      axisSide: AxisSide.left,
      angle: -0.75,
      space: 100,
      fitInside: SideTitleFitInsideData(
        distanceFromEdge: -30,
        parentAxisSize: 0,
        axisPosition: 0,
        enabled: true
      ),

      child: Text(formatDate(date), style: style, ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    return SideTitleWidget(
      axisSide: AxisSide.right,
      child: Text(value.toInt().toString(), style: style )
    );
  }

  List<Request> get requests => widget.requests;
  int? peakTime;
  int? minimumTime;
  int? range;
  @override
  void initState() {
    super.initState();
    peakTime = requests.map((request) => request.time!).reduce(max);
    minimumTime = requests.map((request) => request.time!).reduce(min);

    range = peakTime! - minimumTime!;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.white),
      child: Card(
        color: Colors.white,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 65,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Colors.black45))),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Response Time",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Response Time of last 20 executions",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black45),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text("Average", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                      Text("${widget.statistics.average!.toStringAsFixed(2)} ms", style: TextStyle(fontSize: 16))
                    ],
                  ),
                  Column(
                    children: [
                      Text("Peak", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                      Text("${widget.statistics.peak!.toStringAsFixed(2)} ms", style: TextStyle(fontSize: 16),)
                    ],
                  ),
                ],
              ),
            ),

            Container(
              height: 300,
              padding: EdgeInsets.all(16),
              child: LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(
                        enabled: true,

                      touchTooltipData: LineTouchTooltipData(
                        fitInsideHorizontally: true,
                        getTooltipColor: (tooltip) {
                          return Theme.of(context).primaryColor;
                        },
                        maxContentWidth: 150,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((LineBarSpot touchedSpot) {
                            final textStyle = TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            );

                            return LineTooltipItem("${formatDate(requests[touchedSpot.x.toInt()].date!)} ${touchedSpot.y}ms".toString(), textStyle);
                          }).toList();
                        },
                      )

                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.black12),
                    ),
                    gridData: FlGridData(
                      show: false,
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        axisNameWidget: Text("Period"),
                        drawBelowEverything: true,
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        axisNameWidget: Text("Time (ms)"),
                        drawBelowEverything: true,
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: leftTitleWidgets,
                          reservedSize: 40,
                          interval: (((peakTime!.toDouble() + range!*0.15) - ( minimumTime!.toDouble() - range!*0.25)) ~/ 3).toDouble(),
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    minX: 0,
                    maxX: requests.length-1,
                    minY: minimumTime!.toDouble() - range!*0.25,
                    maxY: peakTime!.toDouble() + range!*0.15,
                    lineBarsData: [
                      LineChartBarData(
                          spots: [
                            ...widget.requests.asMap().entries.toList().map((element) {
                              double index = element.key.toDouble();
                              Request request = element.value;
                              return FlSpot(index, request.time!.toDouble());
                            }),
                          ],
                        gradient: LinearGradient(
                          colors: [
                            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                                .lerp(0.2)!,
                            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                                .lerp(0.2)!,
                          ],
                        ),
                        barWidth: 5,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(
                          show: false,
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                                  .lerp(0.2)!
                                  .withOpacity(0.1),
                              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                                  .lerp(0.2)!
                                  .withOpacity(0.1),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
