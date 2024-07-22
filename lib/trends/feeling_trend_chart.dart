import 'package:canjo/app/colors.dart';
import 'package:canjo/app/icons.dart';
import 'package:canjo/consts.dart';
import 'package:canjo/journal/model/feeling.dart';
import 'package:canjo/stash/bloc/stash_bloc.dart';
import 'package:canjo/stash/mock/mock_products.dart';
import 'package:canjo/journal/model/journal_entry.dart';
import 'package:canjo/stash/model/product.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';

class FeelingTrendChart extends StatefulWidget {
  final Map<String, Map<Feeling, int>> productFeelingTrends;
  final String productName;
  final bool? mockMode;

  const FeelingTrendChart(this.productFeelingTrends, this.productName,
      {this.mockMode, super.key});

  @override
  State<FeelingTrendChart> createState() => _FeelingTrendChartState();
}

class _FeelingTrendChartState extends State<FeelingTrendChart> {
  bool showTitle = false;
  int touchedIndex = 0;
  String touchedTitle = '';

  @override
  Widget build(BuildContext context) {
    Product product = widget.mockMode == true
        ? mockProducts
            .firstWhere((element) => element.name == widget.productName)
        : context
            .read<StashBloc>()
            .state
            .products!
            .where((element) => element.name == widget.productName)
            .first;

    Map<Feeling, int> feelingCounts =
        widget.productFeelingTrends[widget.productName] ?? {};

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
                    if (event is FlTapDownEvent) {
                      setState(() {
                        showTitle = true;
                        touchedIndex =
                            response?.touchedSection?.touchedSectionIndex ?? 0;
                        touchedTitle =
                            response?.touchedSection?.touchedSection?.title ??
                                '';
                      });
                    } else if (event is FlTapUpEvent ||
                        event is FlLongPressEnd) {
                      setState(() {
                        showTitle = false;
                        touchedIndex = 0;
                        touchedTitle = '';
                      });
                    }
                    if (response?.touchedSection != null) {
                      //  response.touchedSection.touchedSection.
                      print(response!.touchedSection!.touchedSection?.title);
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
                              : feelingCounts.length > 1
                                  ? 0.5
                                  : 0,
                  value: entry.value.toDouble(),
                  title: entry.key.name,
                  color: getColorForFeeling(entry.key),
                  showTitle: showTitle && touchedTitle == entry.key.name,
                  titlePositionPercentageOffset: 1.25,
                  titleStyle: const TextStyle(
                      //  background: Paint()..color = Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                );
              }).toList(),
            ),
          ),
        ),
        const Gap(size: 8),
        SizedBox(
          width: 110,
          child: Row(
            children: [
              Icon(
                getIconForCategory(product.category!),
                size: 16,
                color: getColorForProductCategory(product.category!),
              ),
              const Gap(size: 8),
              Flexible(
                child: Text(
                  widget.productName,
                  style: Theme.of(context).textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
