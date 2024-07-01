import 'package:budsy/app/colors.dart';
import 'package:budsy/app/icons.dart';
import 'package:budsy/app/system/bottom_nav.dart';
import 'package:budsy/consts.dart';
import 'package:budsy/entries/mock/mock_products.dart';
import 'package:budsy/entries/model/journal_entry.dart';
import 'package:budsy/journal/mock/mock_journal_entries.dart';
import 'package:budsy/journal/view/add_journal_page.dart';
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
          context.push('/add');
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
          int feelingCount = journalEntry.feelings.length;
          bool overFeelingAvatarLimit = journalEntry.feelings.length > 3;
          int feelingAvatarLimit =
              overFeelingAvatarLimit ? 3 : journalEntry.feelings.length;
          double circleAvatarRadius = calculateCircleAvatarRadius(feelingCount);
          double iconSize = calculateIconRadius(feelingCount);
          String feelingSummaryString =
              composeFeelingSummaryString(journalEntry.feelings);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2),
            child: Card(
              child: InkWell(
                onTap: () {
                  //  context.go('/product/${product.id}');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 4.0,
                          children: [
                            for (int i = 0; i < feelingAvatarLimit; i++)
                              CircleAvatar(
                                radius: circleAvatarRadius,
                                backgroundColor: getColorForFeeling(
                                    journalEntry.feelings[i]),
                                child: PhosphorIcon(
                                  getIconForFeeling(journalEntry.feelings[i]),
                                  size: iconSize,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0, left: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                composeFeelingSummaryString(
                                    journalEntry.feelings),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                  Jiffy.parseFromDateTime(
                                          journalEntry.createdAt)
                                      .fromNow(),
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Chip(
                                  visualDensity: VisualDensity.compact,
                                  avatar: PhosphorIcon(
                                    getIconForCategory(
                                        journalEntry.product.category!),
                                    size: 16,
                                  ),
                                  label: Text(
                                    journalEntry.product.name!,
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        childCount: mockJournalEntries.length,
      ),
    );
  }

  double calculateCircleAvatarRadius(int feelingCount) {
    if (feelingCount == 1) {
      return 18;
    } else {
      return 14;
    }
  }

  double calculateIconRadius(int feelingCount) {
    if (feelingCount == 1) {
      return 24;
    } else {
      return 18;
    }
  }

// Put together the feeling summary string using commas if longer than 2 and an '&' for the last feeling.
  String composeFeelingSummaryString(List<Feeling> feelings) {
    String feelingSummaryString = '';
    for (int i = 0; i < feelings.length; i++) {
      if (i == 0) {
        feelingSummaryString += feelings[i].name.capitalize;
      } else if (i == feelings.length - 1) {
        feelingSummaryString += ' & ${feelings[i].name.capitalize}';
      } else {
        feelingSummaryString += ', ${feelings[i].name.capitalize}';
      }
    }
    return feelingSummaryString;
  }
}
