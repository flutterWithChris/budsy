import 'package:budsy/app/colors.dart';
import 'package:budsy/app/icons.dart';
import 'package:budsy/app/system/bottom_nav.dart';
import 'package:budsy/stash/bloc/product_details_bloc.dart';
import 'package:budsy/stash/model/cannabinoid.dart';
import 'package:budsy/stash/model/product.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ViewProductPage extends StatefulWidget {
  final Product product;
  const ViewProductPage({required this.product, super.key});

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  int? _selectedRating;
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
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 28.0,
                                backgroundColor: getColorForProductCategory(
                                    widget.product.category ??
                                        ProductCategory.other),
                                foregroundImage: widget.product.images != null
                                    ? NetworkImage(widget.product.images![0])
                                    : null,
                                child: widget.product.images == null ||
                                        widget.product.images!.isEmpty
                                    ? Icon(
                                        getIconForCategory(
                                            widget.product.category ??
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
                                        widget.product.name!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(),
                                      ),
                                      const Gap(size: 16.0),
                                      widget.product.images != null
                                          ? CircleAvatar(
                                              radius: 14,
                                              backgroundColor:
                                                  getColorForProductCategory(
                                                      widget.product.category ??
                                                          ProductCategory
                                                              .other),
                                              child: Icon(
                                                getIconForCategory(
                                                    widget.product.category ??
                                                        ProductCategory.other),
                                                size: 14.0,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                  Wrap(
                                    spacing: 8.0,
                                    children: [
                                      Text(
                                        widget.product.brand!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
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
                                initialRating:
                                    widget.product.rating?.toDouble() ?? 0.0,
                                size: 20,
                                filledIcon:
                                    PhosphorIcons.star(PhosphorIconsStyle.fill),
                                emptyIcon: PhosphorIcons.star(),
                                onRatingChanged: (rating) {
                                  setState(() {
                                    _selectedRating = rating.toInt();
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Dispensary
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    PhosphorIcon(
                                        getIconForCategory(
                                            widget.product.category!),
                                        size: 14.0),
                                    const Gap(size: 8.0),
                                    Text('Type',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall),
                                  ],
                                ),
                                Text(widget.product.type!.name.capitalize,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ),
                          // FlowerType

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    PhosphorIcon(
                                        PhosphorIcons.storefront(
                                            PhosphorIconsStyle.duotone),
                                        size: 14.0),
                                    const Gap(size: 8.0),
                                    Text('Dispensary',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall),
                                  ],
                                ),
                                Text(widget.product.dispensary!,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    PhosphorIcon(
                                        PhosphorIcons.tag(
                                            PhosphorIconsStyle.fill),
                                        size: 14.0),
                                    const Gap(size: 8.0),
                                    Text('Price',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                  ],
                                ),
                                Text(
                                    '\$${widget.product.price!.toStringAsFixed(0)}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Price and weight

            const SliverToBoxAdapter(child: Gap(size: 24)),
            // Dispensary
            SliverToBoxAdapter(
              child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                builder: (context, state) {
                  if (state is ProductDetailsLoaded) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          state.cannabinoids.isNotEmpty
                              ? const SizedBox()
                              : Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      child: const Text('Add Cannabinoids'),
                                    ),
                                  ),
                                ),
                          state.terpenes.isNotEmpty
                              ? const SizedBox()
                              : Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      child: const Text('Add Terpenes'),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                builder: (context, state) {
                  if (state is ProductDetailsLoaded) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: state.cannabinoids.isNotEmpty &&
                                state.terpenes.isNotEmpty
                            ? MainAxisAlignment.spaceEvenly
                            : MainAxisAlignment.center,
                        children: [
                          state.cannabinoids.isNotEmpty
                              ? CannabinoidChart(
                                  cannabinoids: state.cannabinoids)
                              : const SizedBox(),
                          state.terpenes.isNotEmpty
                              ? TerpeneChart(widget: widget)
                              : const SizedBox(),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ));
  }
}

class TerpeneChart extends StatelessWidget {
  const TerpeneChart({
    super.key,
    required this.widget,
  });

  final ViewProductPage widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Terpenes', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 120,
          width: 180,
          child: PieChart(PieChartData(
            centerSpaceRadius: 30,
            sections: [
              for (var terpene in widget.product.terpenes!)
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
    );
  }
}

class CannabinoidChart extends StatelessWidget {
  final List<Cannabinoid> cannabinoids;
  const CannabinoidChart({
    super.key,
    required this.cannabinoids,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Cannabinoids', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 120,
          width: 160,
          child: BarChart(BarChartData(
              alignment: BarChartAlignment.spaceAround,
              groupsSpace: 16.0,
              barTouchData: BarTouchData(touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
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
                    cannabinoids[value.toInt()].name!,
                  ),
                )),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(
                      '${value.toStringAsFixed(2)}%',
                      maxLines: 1,
                      style: const TextStyle(color: Colors.white)
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              barGroups: [
                for (var i = 0; i < cannabinoids.length; i++)
                  BarChartGroupData(x: i, barRods: [
                    BarChartRodData(
                      toY: cannabinoids[i].amount!,
                      // color: getColorForCannabinoid(cannabinoids[i]),
                    )
                  ])
              ])),
        )
      ],
    );
  }
}
