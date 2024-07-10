import 'package:budsy/app/colors.dart';
import 'package:budsy/app/icons.dart';
import 'package:budsy/app/system/bottom_nav.dart';
import 'package:budsy/consts.dart';
import 'package:budsy/entries/mock/mock_products.dart';
import 'package:budsy/entries/model/journal_entry.dart';
import 'package:budsy/entries/model/product.dart';
import 'package:budsy/entries/model/terpene.dart';
import 'package:budsy/journal/mock/mock_journal_entries.dart';
import 'package:budsy/trends/feeling_trend_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TrendsPage extends StatefulWidget {
  const TrendsPage({super.key});

  @override
  State<TrendsPage> createState() => _TrendsPageState();
}

class _TrendsPageState extends State<TrendsPage> {
  Map<String, Map<Feeling, int>> trendsData =
      getProductFeelingTrends(mockJournalEntries);
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
          const SliverAppBar(
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
                    size: 24,
                  ),
                  const Gap(size: 16),
                  Text(
                    'Product / Feeling Trends',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: SizedBox(
                height: 140,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
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
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  const Text('Favorite Terpenes'),
                  const Gap(size: 16),
                  Row(
                    children: [
                      for (Terpene terpene in terpenes)
                        Expanded(child: TerpeneAvatar(terpene))
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
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
      final String productName = entry.product!.name!;
      // Iterate through the following journal entries of the type 'feeling' and count them, stopping when the next journal entry is a 'session'.
      for (int i = journalEntries.indexOf(entry) + 1;
          i < journalEntries.length;
          i++) {
        final JournalEntry nextEntry = journalEntries[i];
        if (nextEntry.type == EntryType.feeling) {
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
