import 'package:budsy/app/colors.dart';
import 'package:budsy/stash/bloc/product_details_bloc.dart';
import 'package:budsy/stash/model/cannabinoid.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CannabinoidChart extends StatelessWidget {
  final List<Cannabinoid> cannabinoids;
  const CannabinoidChart({
    super.key,
    required this.cannabinoids,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                PhosphorIcon(
                  PhosphorIcons.hexagon(),
                  size: 20,
                ),
                const Gap(size: 8.0),
                Text('Cannabinoids',
                    style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 24.0),
            AspectRatio(
              aspectRatio: context
                          .read<ProductDetailsBloc>()
                          .state
                          .terpenes
                          ?.isNotEmpty ==
                      true
                  ? 1.5
                  : 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: BarChart(BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    groupsSpace: 16.0,
                    gridData: const FlGridData(
                      drawVerticalLine: false,
                      drawHorizontalLine: true,
                      verticalInterval: 5.0,
                    ),
                    barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (group) =>
                                Theme.of(context).colorScheme.surface,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${rod.toY.toString()}%',
                                Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              );
                            })),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                        reservedSize: 36,
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            cannabinoids[value.toInt()].name!,
                          ),
                        ),
                      )),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: context
                                      .read<ProductDetailsBloc>()
                                      .state
                                      .terpenes
                                      ?.isNotEmpty ==
                                  true
                              ? 45
                              : 60,
                          getTitlesWidget: (value, meta) {
                            String? formattedValue;

                            if (value > 1) {
                              formattedValue = value.toStringAsFixed(0);
                            } // check if values second digit after decimal is 0, if so, remove it
                            else if (value.toString().split('.')[1] == '0') {
                              formattedValue = value.toStringAsFixed(0);
                            } else {
                              formattedValue = value.toStringAsFixed(2);
                            }
                            // if value is not divisible by 5, return empty string
                            if (value % 5 != 0) {
                              return const SizedBox();
                            }

                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$formattedValue%',
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: [
                      for (var i = 0; i < cannabinoids.length; i++)
                        BarChartGroupData(x: i, barRods: [
                          BarChartRodData(
                            width: 20,
                            toY: cannabinoids[i].amount!,
                            color: getColorForCannabinoid(cannabinoids[i]),
                          )
                        ])
                    ])),
              ),
            )
          ],
        ),
      ),
    );
  }
}
