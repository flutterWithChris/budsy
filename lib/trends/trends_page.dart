import 'package:budsy/app/colors.dart';
import 'package:budsy/app/icons.dart';
import 'package:budsy/app/system/bottom_nav.dart';
import 'package:budsy/consts.dart';
import 'package:budsy/stash/mock/mock_products.dart';
import 'package:budsy/journal/model/journal_entry.dart';
import 'package:budsy/stash/model/product.dart';
import 'package:budsy/stash/model/terpene.dart';
import 'package:budsy/journal/mock/mock_journal_entries.dart';
import 'package:budsy/trends/feeling_trend_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TrendsPage extends StatefulWidget {
  const TrendsPage({super.key});

  @override
  State<TrendsPage> createState() => _TrendsPageState();
}

class _TrendsPageState extends State<TrendsPage> {
  Map<String, Map<Feeling, int>> trendsData = getProductFeelingTrends([]);
  Map<Terpene, int> favoriteTerpenes = getFavoriteTerpenes([]);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.medium(
            title: Text('Trends'),
            floating: true,
            snap: true,
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 16.0, left: 16.0, right: 24.0),
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
          ProductToFeelingWidget(trendsData: trendsData),
          const SliverToBoxAdapter(
            child: Gap(
              size: 8,
            ),
          ),
          FavoriteTerpenesWidget(favoriteTerpenes: favoriteTerpenes),
          const SliverToBoxAdapter(
            child: Gap(
              size: 16,
            ),
          ),
          const FavoriteProductsWidget(),
          const TotalsWidget(),
          const SliverToBoxAdapter(
            child: Gap(
              size: 32,
            ),
          )
        ],
      ),
    );
  }
}

class FavoriteProductsWidget extends StatelessWidget {
  const FavoriteProductsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Product> ratingSortedProducts = [Product()]
        .where((element) => element.rating != null)
        .toList()
      ..sort((a, b) => b.rating!.compareTo(a.rating!));
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
                  for (int i = 0; i < 3; i++)
                    InkWell(
                      onTap: () {
                        // Navigate to product details page
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
  const TotalsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<JournalEntry> mockJournalEntries = [];
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
                      '${mockJournalEntries.where((entry) => entry.type == EntryType.session).length}',
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
                      '${mockJournalEntries.where((entry) => entry.type == EntryType.feeling).length}',
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
                      '${mockJournalEntries.where((entry) => entry.type == EntryType.session).expand((element) => element.products!).length}',
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

  final Map<Terpene, int> favoriteTerpenes;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
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
                for (Terpene terpene in favoriteTerpenes.keys.toList())
                  Expanded(child: TerpeneAvatar(terpene))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ProductToFeelingWidget extends StatelessWidget {
  const ProductToFeelingWidget({
    super.key,
    required this.trendsData,
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
                  child: FeelingTrendChart(trendsData, productName),
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
    if (entry.type == EntryType.session) {
      final List<String> productNames = entry.products!
          .map((product) => product.name!)
          .toList(); // Get the name of the product
      // Iterate through the following journal entries of the type 'feeling' and count them, stopping when the next journal entry is a 'session'.
      for (int i = journalEntries.indexOf(entry) + 1;
          i < journalEntries.length;
          i++) {
        final JournalEntry nextEntry = journalEntries[i];
        if (nextEntry.type == EntryType.feeling) {
          for (String productName in productNames)
            for (Feeling feeling in nextEntry.feelings!) {
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
        } else if (nextEntry.type == EntryType.session) {
          break;
        }
      }
    }
  }
  print('productFeelingTrends: $productFeelingTrends');
  return productFeelingTrends;
}

// Iterate through session journal entries, gathering terpenes, then seeing what feelings follow them. If the feelings are positive, add the terpene to the map of favorite terpenes with a count of how many times it was followed by a positive feeling. Return the map of favorite terpenes with the count of how many times they were followed by a positive feeling
Map<Terpene, int> getFavoriteTerpenes(List<JournalEntry> journalEntries) {
  final Map<Terpene, int> favoriteTerpenes = {};

  for (JournalEntry entry in journalEntries) {
    if (entry.type == EntryType.session) {
      final List<Terpene> terpenes = entry.products!
          .map((product) => product.terpenes!)
          .expand((element) => element)
          .toList(); // Get the terpenes of the product
      for (int i = journalEntries.indexOf(entry) + 1;
          i < journalEntries.length;
          i++) {
        final JournalEntry nextEntry = journalEntries[i];
        if (nextEntry.type == EntryType.feeling) {
          for (Feeling feeling in nextEntry.feelings!) {
            if (feeling == Feeling.happy ||
                feeling == Feeling.creative ||
                feeling == Feeling.social ||
                feeling == Feeling.energetic ||
                feeling == Feeling.focus ||
                feeling == Feeling.calm) {
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
        } else if (nextEntry.type == EntryType.session) {
          break;
        }
      }
    }
  }
  print('favoriteTerpenes: $favoriteTerpenes');
  return favoriteTerpenes;
}
