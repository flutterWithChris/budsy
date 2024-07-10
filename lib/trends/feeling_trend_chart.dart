import 'package:budsy/app/colors.dart';
import 'package:budsy/app/icons.dart';
import 'package:budsy/consts.dart';
import 'package:budsy/entries/model/journal_entry.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';

class FeelingTrendChart extends StatefulWidget {
  final Map<String, Map<Feeling, int>> productFeelingTrends;
  final String productName;

  const FeelingTrendChart(this.productFeelingTrends, this.productName,
      {super.key});

  @override
  State<FeelingTrendChart> createState() => _FeelingTrendChartState();
}

class _FeelingTrendChartState extends State<FeelingTrendChart> {
  bool showTitle = false;

  @override
  Widget build(BuildContext context) {
    Map<Feeling, int> feelingCounts =
        widget.productFeelingTrends[widget.productName] ?? {};

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            widget.productName,
            style: Theme.of(context).textTheme.titleSmall,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        const Gap(size: 16),
        SizedBox(
          height: 90,
          width: 90,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 0,
              pieTouchData: PieTouchData(
                  enabled: true,
                  longPressDuration: const Duration(seconds: 1),
                  touchCallback: (event, response) {
                    if (response?.touchedSection != null) {
                      //  response.touchedSection.touchedSection.
                      print(response!.touchedSection!.touchedSection?.title);
                      setState(() {
                        showTitle = !showTitle;
                      });
                    }
                  }),
              sections: feelingCounts.entries.map((entry) {
                return PieChartSectionData(
                  badgeWidget: Icon(getIconForFeeling(entry.key),
                      size: calculateIconRadius(feelingCounts.length)),
                  badgePositionPercentageOffset: feelingCounts.length > 4
                      ? 0.65
                      : feelingCounts.length > 3
                          ? 0.6
                          : feelingCounts.length > 2
                              ? 0.55
                              : 0.5,
                  value: entry.value.toDouble(),
                  title: entry.key.toString().split('.').last,
                  color: getColorForFeeling(entry.key),
                  showTitle: showTitle,
                  titlePositionPercentageOffset: 1.0,
                  titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
