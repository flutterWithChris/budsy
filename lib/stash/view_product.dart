import 'package:budsy/app/colors.dart';
import 'package:budsy/app/icons.dart';
import 'package:budsy/app/system/bottom_nav.dart';
import 'package:budsy/stash/bloc/product_details_bloc.dart';
import 'package:budsy/stash/model/cannabinoid.dart';
import 'package:budsy/stash/model/product.dart';
import 'package:budsy/stash/model/terpene.dart';
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
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              sliver: SliverToBoxAdapter(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 28.0,
                                      backgroundColor:
                                          getColorForProductCategory(
                                              widget.product.category ??
                                                  ProductCategory.other),
                                      foregroundImage:
                                          widget.product.images != null
                                              ? NetworkImage(
                                                  widget.product.images![0])
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                            widget.product
                                                                    .category ??
                                                                ProductCategory
                                                                    .other),
                                                    child: Icon(
                                                      getIconForCategory(widget
                                                              .product
                                                              .category ??
                                                          ProductCategory
                                                              .other),
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
                                          widget.product.rating?.toDouble() ??
                                              0.0,
                                      size: 20,
                                      filledIcon: PhosphorIcons.star(
                                          PhosphorIconsStyle.fill),
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
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Dispensary
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  ],
                                ),
                              ),
                              // FlowerType

                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                        '\$${widget.product.price!.toStringAsFixed(0)}/${widget.product.unit?.name[0]}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
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
              ),
            ),
            // Price and weight

            // Dispensary
            // SliverToBoxAdapter(
            //   child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
            //     builder: (context, state) {
            //       if (state is ProductDetailsLoaded) {
            //         return Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //           child: Row(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               state.cannabinoids.isNotEmpty
            //                   ? const SizedBox()
            //                   : Expanded(
            //                       child: Padding(
            //                         padding: const EdgeInsets.symmetric(
            //                             horizontal: 4.0),
            //                         child: OutlinedButton(
            //                           onPressed: () {},
            //                           child: const Text('Add Cannabinoids'),
            //                         ),
            //                       ),
            //                     ),
            //               state.terpenes.isNotEmpty
            //                   ? const SizedBox()
            //                   : Expanded(
            //                       child: Padding(
            //                         padding: const EdgeInsets.symmetric(
            //                             horizontal: 4.0),
            //                         child: OutlinedButton(
            //                           onPressed: () {},
            //                           child: const Text('Add Terpenes'),
            //                         ),
            //                       ),
            //                     ),
            //             ],
            //           ),
            //         );
            //       }
            //       return const SizedBox.shrink();
            //     },
            //   ),
            // ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
                child: Row(
                  children: [
                    PhosphorIcon(PhosphorIcons.list(), size: 18),
                    const Gap(size: 8.0),
                    Text('Details',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                builder: (context, state) {
                  if (state is ProductDetailsLoaded) {
                    if (state.cannabinoids.isEmpty && state.terpenes.isEmpty) {
                      return const Text(
                          'No cannabinoids or terpene data added.');
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: state.cannabinoids.isNotEmpty &&
                                state.terpenes.isNotEmpty
                            ? MainAxisAlignment.spaceEvenly
                            : MainAxisAlignment.center,
                        children: [
                          state.cannabinoids.isNotEmpty
                              ? Expanded(
                                  child: CannabinoidChart(
                                      cannabinoids: state.cannabinoids),
                                )
                              : const SizedBox(),
                          const SizedBox(),
                          const Gap(size: 4.0),
                          if (state.terpenes.isNotEmpty)
                            Expanded(
                                child: TerpeneChart(
                              terpenes: state.terpenes,
                            ))
                          else
                            const SizedBox(),
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

// Add Cannabinoids Card
class AddCannabinoidsCard extends StatelessWidget {
  const AddCannabinoidsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Example of a cannabinoid chart
          Expanded(
            flex: 2,
            child: Center(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: OutlinedButton.icon(
                      onPressed: () {},
                      icon:
                          Icon(PhosphorIcons.plusCircle(), color: Colors.green),
                      label: const Text('Cannabinoids'))),
            ),
          ),
        ],
      ),
    );
  }
}

class TerpeneEmptyCard extends StatelessWidget {
  const TerpeneEmptyCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Example of a terpene chart

          Expanded(
            flex: 2,
            child: Center(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: OutlinedButton(
                      onPressed: () {}, child: const Text('Add Terpenes'))),
            ),
          ),
        ],
      ),
    );
  }
}

class ExampleTerpeneChart extends StatelessWidget {
  const ExampleTerpeneChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Text('Terpenes', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 120,
          width: 180,
          child: PieChart(PieChartData(
            centerSpaceRadius: 30,
            sections: [
              PieChartSectionData(
                radius: 30,
                color: Colors.green,
                badgeWidget:
                    Icon(PhosphorIcons.leaf(), color: Colors.white, size: 14.0),
                value: 20,
                showTitle: false,
              ),
              PieChartSectionData(
                radius: 30,
                color: Colors.blue,
                badgeWidget:
                    Icon(PhosphorIcons.leaf(), color: Colors.white, size: 14.0),
                value: 30,
                showTitle: false,
              ),
              PieChartSectionData(
                radius: 30,
                color: Colors.red,
                badgeWidget:
                    Icon(PhosphorIcons.leaf(), color: Colors.white, size: 14.0),
                value: 50,
                showTitle: false,
              ),
            ],
          )),
        )
      ],
    );
  }
}

class TerpeneChart extends StatelessWidget {
  final List<Terpene> terpenes;
  const TerpeneChart({
    super.key,
    required this.terpenes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                PhosphorIcon(PhosphorIcons.leaf(), size: 20),
                const Gap(size: 8.0),
                Text('Terpenes',
                    style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
          SizedBox(
            height: 105,
            width: 120,
            child: PieChart(PieChartData(
              centerSpaceRadius: 30,
              sections: [
                for (var terpene in terpenes)
                  PieChartSectionData(
                    radius: 22,
                    color: getColorForTerpene(terpene),
                    badgeWidget: Icon(getIconForTerpene(terpene),
                        color: Colors.white, size: 14.0),
                    value: terpene.amount!,
                    showTitle: false,
                  ),
              ],
            )),
          ),
          const Gap(size: 24.0),
        ],
      ),
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
                  : 2.1,
              // height: 120,
              // width: 160,

              child: BarChart(BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  groupsSpace: 16.0,
                  barTouchData: BarTouchData(touchTooltipData:
                      BarTouchTooltipData(
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
                            ? 28
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

                          return Text(
                            '$formattedValue%',
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold),
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
                          toY: cannabinoids[i].amount!,
                          color: getColorForCannabinoid(cannabinoids[i]),
                        )
                      ])
                  ])),
            )
          ],
        ),
      ),
    );
  }
}
