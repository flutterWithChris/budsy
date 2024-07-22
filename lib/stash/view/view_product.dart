import 'package:canjo/app/colors.dart';
import 'package:canjo/app/icons.dart';
import 'package:canjo/app/system/bottom_nav.dart';
import 'package:canjo/stash/bloc/product_details_bloc.dart';
import 'package:canjo/stash/model/cannabinoid.dart';
import 'package:canjo/stash/model/product.dart';
import 'package:canjo/stash/model/terpene.dart';
import 'package:canjo/stash/widgets/cannabinoid_chart.dart';
import 'package:canjo/stash/widgets/terpene_chart.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
              title: Row(
                children: [
                  Text(
                    'Product',
                    style: GoogleFonts.roboto().copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                ],
              ),
              floating: true,
              snap: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextButton.icon(
                    onPressed: () async => await context.push(
                        '/stash/product/${widget.product.id}/edit',
                        extra:
                            context.read<ProductDetailsBloc>().state.product),
                    label: const Text('Edit'),
                    icon: PhosphorIcon(
                      PhosphorIcons.pencil(),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              sliver: SliverToBoxAdapter(
                child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                  builder: (context, state) {
                    if (state is ProductDetailsError) {
                      return Center(
                        child: Text('Error: ${state.message}'),
                      );
                    }
                    if (state is ProductDetailsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is ProductDetailsLoaded) {
                      Product product = state is ProductDetailsLoaded
                          ? state.product
                          : widget.product;
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 16.0),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
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
                                                    product.category ??
                                                        ProductCategory.other),
                                            foregroundImage:
                                                product.images != null
                                                    ? NetworkImage(
                                                        product.images![0])
                                                    : null,
                                            child: product.images == null ||
                                                    product.images!.isEmpty
                                                ? Icon(
                                                    getIconForCategory(product
                                                            .category ??
                                                        ProductCategory.other),
                                                    size: 28.0,
                                                  )
                                                : null,
                                          ),
                                          const Gap(size: 16.0),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        product.name!,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium
                                                            ?.copyWith(),
                                                      ),
                                                    ),
                                                    const Gap(size: 16.0),
                                                    product.images != null
                                                        ? CircleAvatar(
                                                            radius: 14,
                                                            backgroundColor:
                                                                getColorForProductCategory(widget
                                                                        .product
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
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                  ],
                                                ),
                                                Wrap(
                                                  spacing: 8.0,
                                                  children: [
                                                    Text(
                                                      product.brand!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          RatingBar(
                                            initialRating:
                                                product.rating?.toDouble() ??
                                                    0.0,
                                            size: 20,
                                            filledIcon: PhosphorIcons.star(
                                                PhosphorIconsStyle.fill),
                                            emptyIcon: PhosphorIcons.star(),
                                            onRatingChanged: (rating) {
                                              setState(() {
                                                _selectedRating =
                                                    rating.toInt();
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Dispensary
                                    if (product.type != null)
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                PhosphorIcon(
                                                    getIconForCategory(
                                                        product.category!),
                                                    size: 14.0),
                                                const Gap(size: 8.0),
                                                Text('Type',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall),
                                              ],
                                            ),
                                            Text(product.type!.name.capitalize,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium),
                                          ],
                                        ),
                                      ),
                                    // FlowerType
                                    if (product.dispensary?.isNotEmpty ?? false)
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                PhosphorIcon(
                                                    PhosphorIcons.storefront(
                                                        PhosphorIconsStyle
                                                            .duotone),
                                                    size: 14.0),
                                                const Gap(size: 8.0),
                                                Text('Dispensary',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall),
                                              ],
                                            ),
                                            Text(product.dispensary!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium),
                                          ],
                                        ),
                                      ),
                                    if (product.price != null)
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                PhosphorIcon(
                                                    PhosphorIcons.tag(
                                                        PhosphorIconsStyle
                                                            .fill),
                                                    size: 14.0),
                                                const Gap(size: 8.0),
                                                Text('Price',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium),
                                              ],
                                            ),
                                            Text(
                                                product.unit != null
                                                    ? '\$${product.price!.toStringAsFixed(0)}/${product.unit?.name[0]}'
                                                    : '\$${product.price!.toStringAsFixed(0)}',
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
                      );
                    } else {
                      return const Text('Error loading product');
                    }
                  },
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
            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
            //     child: Row(
            //       children: [
            //         PhosphorIcon(PhosphorIcons.list(), size: 18),
            //         const Gap(size: 8.0),
            //         Text('Details',
            //             style: Theme.of(context)
            //                 .textTheme
            //                 .titleMedium
            //                 ?.copyWith(fontWeight: FontWeight.bold)),
            //       ],
            //     ),
            //   ),
            // ),
            SliverToBoxAdapter(
              child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                builder: (context, state) {
                  if (state is ProductDetailsLoading) {
                    return const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(child: TerpeneEmptyCard()),
                        ],
                      ),
                    );
                  }
                  if (state is ProductDetailsLoaded) {
                    if (state.cannabinoids.isEmpty && state.terpenes.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('No cannabinoid or terpene data added.'),
                          ],
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 0.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: state.cannabinoids.isNotEmpty &&
                                state.terpenes.isNotEmpty
                            ? MainAxisAlignment.spaceEvenly
                            : MainAxisAlignment.center,
                        children: [
                          // state.cannabinoids.isNotEmpty
                          //     ? Expanded(
                          //         child: CannabinoidChart(
                          //             cannabinoids: state.cannabinoids),
                          //       )
                          //     : const SizedBox(),
                          // const SizedBox(),
                          // const Gap(size: 4.0),
                          if (state.terpenes.isNotEmpty)
                            Flexible(
                                child: TerpeneChart(
                              terpenes: state.terpenes,
                            ))
                          else
                            const Flexible(child: TerpeneEmptyCard()),
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
                    if (state.cannabinoids.isEmpty && state.terpenes.isEmpty) {
                      return const SizedBox();
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 0.0),
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
                          // if (state.terpenes.isNotEmpty)
                          //   Flexible(
                          //       child: TerpeneChart(
                          //     terpenes: state.terpenes,
                          //   ))
                          // else
                          //   const SizedBox(),
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
    return AspectRatio(
      aspectRatio: 1.0,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Example of a terpene chart
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
                        dataSource: [
                          Terpene(name: 'Myrcene', amount: 20),
                          Terpene(name: 'Limonene', amount: 30),
                          Terpene(name: 'Caryophyllene', amount: 50),
                        ],
                        xValueMapper: (Terpene terpene, _) => terpene.name,
                        yValueMapper: (Terpene terpene, _) => terpene.amount,
                        pointColorMapper: (Terpene terpene, _) =>
                            Theme.of(context).colorScheme.surface,
                      ),
                    ],
                  )
                      .animate(
                        onComplete: (controller) => controller.repeat(),
                      )
                      .shimmer(
                        duration: const Duration(seconds: 1, milliseconds: 800),
                        curve: Curves.easeInOutSine,
                        color: Theme.of(context).colorScheme.tertiary,
                      )),
            ),
          ],
        ),
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
