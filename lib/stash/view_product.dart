import 'package:budsy/app/colors.dart';
import 'package:budsy/app/icons.dart';
import 'package:budsy/app/system/bottom_nav.dart';
import 'package:budsy/stash/model/product.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ViewProductPage extends StatelessWidget {
  final Product product;
  const ViewProductPage({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const BottomNavBar(),
        body: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              title: Text(
                'Product',
                style: GoogleFonts.roboto().copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              floating: true,
              snap: true,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28.0,
                            backgroundColor: getColorForProductCategory(
                                product.category ?? ProductCategory.other),
                            foregroundImage: product.images != null
                                ? NetworkImage(product.images![0])
                                : null,
                            child: product.images == null ||
                                    product.images!.isEmpty
                                ? Icon(
                                    getIconForCategory(product.category ??
                                        ProductCategory.other),
                                    size: 28.0,
                                  )
                                : null,
                          ),
                          const Gap(size: 16.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    product.name!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(),
                                  ),
                                  const Gap(size: 16.0),
                                  product.images != null
                                      ? CircleAvatar(
                                          radius: 14,
                                          backgroundColor:
                                              getColorForProductCategory(
                                                  product.category ??
                                                      ProductCategory.other),
                                          child: Icon(
                                            getIconForCategory(
                                                product.category ??
                                                    ProductCategory.other),
                                            size: 14.0,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                              Text(
                                product.brand!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RatingBar(
                            initialRating: product.rating!.toDouble(),
                            size: 24,
                            filledIcon:
                                PhosphorIcons.star(PhosphorIconsStyle.fill),
                            emptyIcon: PhosphorIcons.star(),
                            onRatingChanged: (rating) {},
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Cannabinoids',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          height: 120,
                          width: 160,
                          child: BarChart(BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              groupsSpace: 16.0,
                              barTouchData: BarTouchData(touchTooltipData:
                                  BarTouchTooltipData(getTooltipItem:
                                      (group, groupIndex, rod, rodIndex) {
                                return BarTooltipItem(
                                  '${rod.toY.toString()}%',
                                  GoogleFonts.roboto().copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              })),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) => Text(
                                    product.cannabinoids![value.toInt()].name!,
                                  ),
                                )),
                                topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) => Text(
                                      '${value.toStringAsFixed(2)}%',
                                      maxLines: 1,
                                      style:
                                          const TextStyle(color: Colors.white)
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              barGroups: [
                                for (var i = 0;
                                    i < product.cannabinoids!.length;
                                    i++)
                                  BarChartGroupData(x: i, barRods: [
                                    BarChartRodData(
                                      toY: product.cannabinoids![i].amount!,
                                      color: getColorForCannabinoid(
                                          product.cannabinoids![i]),
                                    )
                                  ])
                              ])),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text('Terpenes',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          height: 120,
                          width: 180,
                          child: PieChart(PieChartData(
                            centerSpaceRadius: 30,
                            sections: [
                              for (var terpene in product.terpenes!)
                                PieChartSectionData(
                                  radius: 30,
                                  color: getColorForTerpene(terpene),
                                  badgeWidget: Icon(getIconForTerpene(terpene),
                                      color: Colors.white, size: 14.0),
                                  value: terpene.amount!,
                                  showTitle: false,
                                ),
                            ],
                          )),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
