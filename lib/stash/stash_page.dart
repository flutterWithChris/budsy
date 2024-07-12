import 'package:budsy/app/colors.dart';
import 'package:budsy/app/icons.dart';
import 'package:budsy/app/system/bottom_nav.dart';
import 'package:budsy/consts.dart';
import 'package:budsy/stash/mock/mock_products.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class StashPage extends StatelessWidget {
  const StashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/new-entry');
        },
        child: const Icon(Icons.add),
      ),
      // appBar: AppBar(
      //   title: const Text('Journal'),
      // ),
      bottomNavigationBar: const BottomNavBar(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Text(
              'Stash',
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                children: [
                  Text(
                    'Current',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                  ),
                  const Gap(size: 4.0),
                  const Icon(Icons.chevron_right_rounded)
                ],
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 0.0),
            sliver: StashList(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                children: [
                  Text(
                    'Archived',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                  ),
                  const Gap(size: 4.0),
                  const Icon(Icons.chevron_right_rounded)
                ],
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 0.0),
            sliver: StashList(),
          ),
        ],
      ),
    );
  }
}

class StashList extends StatelessWidget {
  const StashList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final product = mockProducts[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            child: Card(
              child: InkWell(
                onTap: () {
                  context.push('/stash/product/${product.id}', extra: product);
                },
                child: ListTile(
                  leading: IconButton.filledTonal(
                    onPressed: () {},
                    style: IconButton.styleFrom(
                        backgroundColor:
                            getColorForProductCategory(product.category!)),
                    icon: PhosphorIcon(getIconForCategory(product.category!)),
                  ),
                  title: Text(
                    product.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(product.type!.name.capitalize),
                  trailing: SizedBox(
                    width: 100.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: PieChart(
                                  PieChartData(
                                    centerSpaceRadius: 10,
                                    sections: [
                                      for (var cannabinoid
                                          in product.cannabinoids!)
                                        PieChartSectionData(
                                          radius: 4,
                                          color: cannabinoid.color,
                                          value: cannabinoid.amount,
                                          showTitle: false,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(size: 24.0),
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: PieChart(
                                  PieChartData(
                                    centerSpaceRadius: 10,
                                    sections: [
                                      for (var terpene in product.terpenes!)
                                        PieChartSectionData(
                                          radius: 4,
                                          color: terpene.color,
                                          value: terpene.amount,
                                          showTitle: false,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(size: 8.0),
                        Flexible(
                          child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.chevron_right_rounded)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        childCount: mockProducts.length,
      ),
    );
  }
}
