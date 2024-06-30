import 'package:budsy/app/colors.dart';
import 'package:budsy/app/icons.dart';
import 'package:budsy/app/system/bottom_nav.dart';
import 'package:budsy/consts.dart';
import 'package:budsy/entries/mock/mock_products.dart';
import 'package:budsy/journal/mock/mock_journal_entries.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

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
              'Journal',
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
                    'Today',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                  ),
                  const Gap(size: 4.0),
                  const Icon(Icons.chevron_right_rounded)
                ],
              ),
            ),
          ),
          const JournalEntryList(),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                children: [
                  Text(
                    'Yesterday',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                  ),
                  const Gap(size: 4.0),
                  const Icon(Icons.chevron_right_rounded)
                ],
              ),
            ),
          ),
          const JournalEntryList(),
        ],
      ),
    );
  }
}

class JournalEntryList extends StatelessWidget {
  const JournalEntryList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final journalEntry = mockJournalEntries[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2),
            child: Card(
              child: InkWell(
                onTap: () {
                  //  context.go('/product/${product.id}');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: IconButton.filledTonal(
                          style: IconButton.styleFrom(
                            backgroundColor:
                                getColorForFeeling(journalEntry.feeling),
                          ),
                          onPressed: () {},
                          icon: PhosphorIcon(
                              getIconForFeeling(journalEntry.feeling)),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Feeling ${journalEntry.feeling.name.capitalize}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(Jiffy.parseFromDateTime(journalEntry.createdAt)
                                .fromNow()),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Chip(
                                visualDensity: VisualDensity.compact,
                                avatar: PhosphorIcon(getIconForCategory(
                                    journalEntry.product.category!)),
                                label: Text(
                                  journalEntry.product.name!,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                ),
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
          );
        },
        childCount: mockProducts.length,
      ),
    );
  }
}
