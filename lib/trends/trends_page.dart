import 'dart:math';

import 'package:canjo/app/colors.dart';
import 'package:canjo/app/icons.dart';
import 'package:canjo/app/system/bottom_nav.dart';
import 'package:canjo/consts.dart';
import 'package:canjo/journal/bloc/journal_bloc.dart';
import 'package:canjo/journal/model/feeling.dart';
import 'package:canjo/stash/bloc/product_details_bloc.dart';
import 'package:canjo/stash/bloc/stash_bloc.dart';
import 'package:canjo/stash/mock/mock_products.dart';
import 'package:canjo/journal/model/journal_entry.dart';
import 'package:canjo/stash/model/product.dart';
import 'package:canjo/stash/model/terpene.dart';
import 'package:canjo/journal/mock/mock_journal_entries.dart';
import 'package:canjo/subscription/bloc/subscription_bloc.dart';
import 'package:canjo/subscription/sheets/subscription_offer_sheet.dart';
import 'package:canjo/trends/cubit/favorite_terpenes_cubit.dart';
import 'package:canjo/trends/feeling_trend_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:go_router/go_router.dart';
import 'package:list_ext/list_ext.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class TrendsPage extends StatefulWidget {
  const TrendsPage({super.key});

  @override
  State<TrendsPage> createState() => _TrendsPageState();
}

class _TrendsPageState extends State<TrendsPage> {
  Map<String, Map<Feeling, int>> trendsData = {};
  Map<String, Map<Feeling, int>> mockTrendsData = {};
  Map<Terpene, int> favoriteTerpenes = {};
  List<Product> mockRatingSortedProducts = [];
  @override
  void initState() {
    mockTrendsData = getProductFeelingTrends(mockJournalEntries);
    mockRatingSortedProducts = mockProducts;
    mockRatingSortedProducts.sort((a, b) => b.rating!.compareTo(a.rating!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      body: BlocBuilder<SubscriptionBloc, SubscriptionState>(
        builder: (context, state) {
          if (state is SubscriptionLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is SubscriptionError) {
            return const Center(
              child: Text('Error fetching subscription'),
            );
          }
          if (state is SubscriptionLoaded &&
              state.customerInfo != null &&
              state.customerInfo!.entitlements.active.isNotEmpty) {
            return BlocBuilder<JournalBloc, JournalState>(
              builder: (context, journalState) {
                if (journalState is JournalLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (journalState is JournalLoaded &&
                    journalState.entries.isNotNullOrEmpty) {
                  return BlocBuilder<StashBloc, StashState>(
                    builder: (context, stashState) {
                      if (stashState is StashLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (stashState is StashLoaded &&
                          stashState.products.isNotNullOrEmpty) {
                        trendsData =
                            getProductFeelingTrends(journalState.entries);

                        return CustomScrollView(
                          slivers: [
                            const SliverAppBar.medium(
                              title: Text('Trends'),
                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, left: 16.0, right: 24.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      PhosphorIcons.trendUp(),
                                      size: 20,
                                    ),
                                    const Gap(size: 8),
                                    Text(
                                      'Product / Feeling Trends',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ProductToFeelingWidget(trendsData: trendsData),
                            const SliverToBoxAdapter(
                              child: Gap(
                                size: 8,
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: BlocBuilder<FavoriteTerpenesCubit,
                                  FavoriteTerpenesState>(
                                builder: (context, state) {
                                  if (state is FavoriteTerpenesLoading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (state is FavoriteTerpenesLoaded) {
                                    return FavoriteTerpenesWidget(
                                        favoriteTerpenes: state.terpenes);
                                  } else {
                                    return const Center(
                                      child: Text('Something Went Wrong...'),
                                    );
                                  }
                                },
                              ),
                            ),
                            const SliverToBoxAdapter(
                              child: Gap(
                                size: 16,
                              ),
                            ),
                            BlocBuilder<StashBloc, StashState>(
                              builder: (context, state) {
                                if (state is StashError) {
                                  return const Center(
                                    child: Text('Error fetching stash'),
                                  );
                                }
                                if (state is StashLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (state is StashLoaded) {
                                  List<Product> ratingSortedProducts = state
                                      .products
                                      .where(
                                          (element) => element.rating != null)
                                      .toList()
                                    ..sort((a, b) =>
                                        b.rating!.compareTo(a.rating!));
                                  return FavoriteProductsWidget(
                                    ratingSortedProducts: ratingSortedProducts,
                                  );
                                } else {
                                  return const Center(
                                    child: Text('Something Went Wrong...'),
                                  );
                                }
                              },
                            ),
                            TotalsWidget(
                              journalEntries: journalState.entries,
                            ),
                            const SliverToBoxAdapter(
                              child: Gap(
                                size: 32,
                              ),
                            )
                          ],
                        );
                      }
                      if (stashState is StashLoaded &&
                          stashState.products.isEmpty) {
                        return const Center(
                          child: Text('No products in stash'),
                        );
                      } else {
                        return const Center(
                          child: Text('Something Went Wrong...'),
                        );
                      }
                    },
                  );
                }
                if (journalState is JournalLoaded &&
                    journalState.entries.isEmpty) {
                  return const Center(
                    child: Text('No journal entries'),
                  );
                } else {
                  return const Center(
                    child: Text('Something Went Wrong...'),
                  );
                } 
              },
            );
          }
          if (state is SubscriptionLoaded &&
              state.customerInfo != null &&
              state.customerInfo!.entitlements.active.isEmpty) {
           
            return const LockedTrendsPage();
          } else {
            return const Center(
              child: Text('Something Went Wrong...'),
            );
          }
        },
      ),
    );
  }
}

class LockedTrendsPage extends StatefulWidget {
  const LockedTrendsPage({
    super.key,

  });

 

  @override
  State<LockedTrendsPage> createState() => _LockedTrendsPageState();
}

class _LockedTrendsPageState extends State<LockedTrendsPage> {

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      ExampleTrendsWidgets(),
      Positioned.fill(
          child: Padding(
        padding: const EdgeInsets.only(top: 120),
        child: Container(
          color: 
          Theme.of(context).brightness == Brightness.dark
          ? Colors.black54
          : Colors.white54
        ),
      )),
      // Overlay subscription offer
      Positioned(
        child: Padding(
          padding: const EdgeInsets.only(top: 120),
          child: Container(
            //  color: Theme.of(context).colorScheme.primaryContainer,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: 
                 Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white,
                  blurRadius: 60,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(80.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    PhosphorIcons.lockOpen(),
                    size: 64,
                  ),
                  const Gap(size: 16),
                  Text(
                    'Unlock Trends',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Gap(size: 8),
                  Text(
                    'Subscribe to unlock trends and more',
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                  const Gap(size: 16),
                  FilledButton(
                    onPressed: () {
                      context.read<SubscriptionBloc>().add(ShowPaywall());
                    },
                    child: const Text('Subscribe'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}

class ExampleTrendsWidgets extends StatefulWidget {
  const ExampleTrendsWidgets({
    super.key,
  });

  @override
  State<ExampleTrendsWidgets> createState() => _ExampleTrendsWidgetsState();
}

class _ExampleTrendsWidgetsState extends State<ExampleTrendsWidgets> {
  Map<String, Map<Feeling, int>> mockTrendsData = {};
  List<Product> mockRatingSortedProducts = [];

  @override
  void initState() {
    // TODO: implement initState
    mockTrendsData = getProductFeelingTrends(mockJournalEntries);
    mockRatingSortedProducts = mockProducts;
    mockRatingSortedProducts.sort((a, b) => b.rating!.compareTo(a.rating!));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar.medium(
          title: Text('Trends'),
        ),
        // Example Trends Widgets
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              left: 16.0,
              right: 24.0,
            ),
            child: Row(
              children: [
                Icon(
                  PhosphorIcons.trendUp(),
                  size: 20,
                ),
                const Gap(size: 8),
                Text(
                  'Product / Feeling Trends',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
        ProductToFeelingWidget(trendsData: mockTrendsData, mockMode: true),
        const SliverToBoxAdapter(
          child: Gap(
            size: 8,
          ),
        ),
        SliverToBoxAdapter(
          child: FavoriteTerpenesWidget(
              favoriteTerpenes: terpenes.take(3).toList()),
        ),
        const SliverToBoxAdapter(
          child: Gap(
            size: 16,
          ),
        ),
        FavoriteProductsWidget(ratingSortedProducts: mockRatingSortedProducts),

        TotalsWidget(journalEntries: mockJournalEntries),
        const SliverToBoxAdapter(
          child: Gap(
            size: 32,
          ),
        )
      ],
    );
  }
}

class FavoriteProductsWidget extends StatelessWidget {
  final List<Product> ratingSortedProducts;
  const FavoriteProductsWidget({
    required this.ratingSortedProducts,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // List<Product> ratingSortedProducts = context.read<StashBloc>().state.products

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  PhosphorIcons.heart(PhosphorIconsStyle.fill),
                  size: 20,
                ),
                const Gap(size: 8),
                Text(
                  'Favorite Products',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const Gap(size: 16),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0;
                      i <
                          (ratingSortedProducts.length > 3
                              ? 3
                              : ratingSortedProducts.length);
                      i++)
                    InkWell(
                      onTap: () {
                        // Navigate to product details page
                        context.read<ProductDetailsBloc>().add(
                              FetchProductDetails(ratingSortedProducts[i]),
                            );
                        context.push(
                            '/stash/product/${ratingSortedProducts[i].id}',
                            extra: ratingSortedProducts[i]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: getColorForProductCategory(
                                      ratingSortedProducts[i].category!),
                                  child: PhosphorIcon(
                                    getIconForCategory(
                                        ratingSortedProducts[i].category!),
                                    size: 24,
                                  ),
                                ),
                                title: Text(ratingSortedProducts[i].name!),
                                subtitle: Wrap(
                                  children: [
                                    for (int index = 0;
                                        index < ratingSortedProducts[i].rating!;
                                        index++)
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.chevron_right_rounded),
                                  onPressed: () {
                                    // Navigate to product details page
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TotalsWidget extends StatelessWidget {
  final List<JournalEntry> journalEntries;
  const TotalsWidget({
    required this.journalEntries,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0),
        child: Column(
          children: [
            const Gap(size: 8),
            Row(
              children: [
                Icon(
                  PhosphorIcons.listNumbers(PhosphorIconsStyle.fill),
                  size: 20,
                ),
                const Gap(size: 8),
                Text(
                  'Totals',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const Gap(size: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      '${journalEntries.where((entry) => entry.type == EntryType.session).length}',
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Text(
                      'Sessions',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${journalEntries.expand((entry) => entry.feelings!).length}',
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Text(
                      'Feelings',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${journalEntries.expand((element) => element.products!).length}',
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Text(
                      'Products',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FavoriteTerpenesWidget extends StatelessWidget {
  const FavoriteTerpenesWidget({
    super.key,
    required this.favoriteTerpenes,
  });

  final List<Terpene> favoriteTerpenes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                PhosphorIcons.leaf(PhosphorIconsStyle.fill),
                size: 20,
              ),
              const Gap(size: 8),
              Text(
                'Favorite Terpenes',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const Gap(size: 16),
          Row(
            children: [
              for (Terpene terpene in favoriteTerpenes)
                Expanded(child: TerpeneAvatar(terpene))
            ],
          )
        ],
      ),
    );
  }
}

class ProductToFeelingWidget extends StatelessWidget {
  final bool? mockMode;
  const ProductToFeelingWidget({
    super.key,
    required this.trendsData,
    this.mockMode,
  });

  final Map<String, Map<Feeling, int>> trendsData;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 8.0,
        ),
        child: SizedBox(
          height: 126,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            children: [
              for (String productName in trendsData.keys)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FeelingTrendChart(trendsData, productName,
                      mockMode: mockMode),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class TerpeneAvatar extends StatelessWidget {
  final Terpene terpene;
  const TerpeneAvatar(
    this.terpene, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: getColorForTerpene(terpene),
          child: PhosphorIcon(
            getFilledIconForTerpene(terpene),
            size: 40,
            color: terpene.name == 'Limonene'
                ? const Color.fromARGB(255, 20, 20, 20)
                : Colors.white,
          ),
        ),
        const Gap(size: 8),
        Text(
          terpene.name!,
          style: Theme.of(context).textTheme.titleSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

Map<String, Map<Feeling, int>> getProductFeelingTrends(
    List<JournalEntry> journalEntries) {
  final Map<String, Map<Feeling, int>> productFeelingTrends = {};

  for (JournalEntry entry in journalEntries) {
    final List<String> productNames =
        entry.products!.map((product) => product.name!).toList();

    // Check for feelings within the same journal entry
    if (entry.feelings != null && entry.feelings!.isNotEmpty) {
      for (String productName in productNames) {
        for (Feeling feeling in entry.feelings!) {
          if (!productFeelingTrends.containsKey(productName)) {
            productFeelingTrends[productName] = {};
          }

          if (productFeelingTrends[productName]!.containsKey(feeling)) {
            productFeelingTrends[productName]![feeling] =
                productFeelingTrends[productName]![feeling]! + 1;
          } else {
            productFeelingTrends[productName]![feeling] = 1;
          }
        }
      }
    }
  }
  return productFeelingTrends;
}

// Iterate through session journal entries, gathering terpenes, then seeing what feelings follow them. If the feelings are positive, add the terpene to the map of favorite terpenes with a count of how many times it was followed by a positive feeling. Return the map of favorite terpenes with the count of how many times they were followed by a positive feeling
Map<Terpene, int> getFavoriteTerpenes(
    List<JournalEntry> journalEntries, BuildContext context) {
  final Map<Terpene, int> favoriteTerpenes = {};

  for (JournalEntry entry in journalEntries) {
    if (entry.products.isNotNullOrEmpty) {
      final List<Product> products = context
          .read<StashBloc>()
          .state
          .products!
          .where((element) =>
              entry.products!.any((product) => product.id == element.id))
          .toList(); // Get the products of the entry
      final List<Terpene> terpenes = products
          .where((product) => product.terpenes != null)
          .toList()
          .map((product) => product.terpenes!)
          .expand((element) => element)
          .toList(); // Get the terpenes of the product

      // Check for feelings within the same journal entry
      if (entry.feelings != null && entry.feelings!.isNotEmpty) {
        for (Feeling feeling in entry.feelings!) {
          if (feeling.name == 'happy' ||
              feeling.name == 'creative' ||
              feeling.name == 'social' ||
              feeling.name == 'energetic' ||
              feeling.name == 'focus' ||
              feeling.name == 'calm') {
            for (Terpene terpene in terpenes) {
              if (favoriteTerpenes.keys
                  .any((element) => element.name == terpene.name)) {
                favoriteTerpenes[favoriteTerpenes.keys.firstWhere(
                        (element) => element.name == terpene.name)] =
                    favoriteTerpenes[favoriteTerpenes.keys.firstWhere(
                            (element) => element.name == terpene.name)]! +
                        1;
              } else {
                favoriteTerpenes[terpene] = 1;
              }
            }
          }
        }
      }
    }
  }
  return favoriteTerpenes;
}
