import 'package:budsy/app/colors.dart';
import 'package:budsy/app/icons.dart';
import 'package:budsy/stash/model/terpene.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TerpeneChart extends StatelessWidget {
  final List<Terpene> terpenes;
  const TerpeneChart({
    super.key,
    required this.terpenes,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                child: Row(
                  children: [
                    PhosphorIcon(PhosphorIcons.leaf(), size: 20),
                    const Gap(size: 8.0),
                    Text('Terpenes',
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SfCircularChart(
                  margin: EdgeInsets.zero,
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    color: Theme.of(context).colorScheme.surface,
                    builder: (data, point, series, pointIndex, seriesIndex) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${data.amount}%',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      );
                    },
                  ),
                  series: [
                    RadialBarSeries<Terpene, String>(
                      animationDuration: 400,
                      gap: '12%',
                      radius: '100%',
                      innerRadius: '25%',
                      strokeWidth: 2.9,
                      cornerStyle: CornerStyle.bothCurve,
                      trackColor: Theme.of(context).colorScheme.surface,
                      dataSource: terpenes,
                      xValueMapper: (Terpene terpene, _) => terpene.name,
                      yValueMapper: (Terpene terpene, _) => terpene.amount,
                      pointColorMapper: (Terpene terpene, _) =>
                          getColorForTerpene(terpene),
                      dataLabelMapper: (Terpene terpene, _) =>
                          '${terpene.name}',
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        textStyle: Theme.of(context).textTheme.bodySmall,
                        margin: const EdgeInsets.all(8.0),
                        offset: const Offset(0, 0),
                        builder:
                            (data, point, series, pointIndex, seriesIndex) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                // color: Theme.of(context)
                                //     .colorScheme
                                //     .tertiaryContainer,
                                border: Border.all(
                                  color: getColorForTerpene(data),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: PhosphorIcon(
                                          getFilledIconForTerpene(data),
                                          //   color: getColorForTerpene(data),
                                          size: 10.0),
                                    ),
                                    const Gap(size: 4.0),
                                    Text('${data.name}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // SizedBox(
            //   height: 105,
            //   width: 120,
            //   child: PieChart(PieChartData(
            //     centerSpaceRadius: 30,
            //     sections: [
            //       for (var terpene in terpenes)
            //         PieChartSectionData(
            //           radius: 22,
            //           color: getColorForTerpene(terpene),
            //           badgeWidget: Icon(getIconForTerpene(terpene),
            //               color: Colors.white, size: 14.0),
            //           value: terpene.amount!,
            //           showTitle: false,
            //         ),
            //     ],
            //   )),
            // ),
          ],
        ),
      ),
    );
  }
}
