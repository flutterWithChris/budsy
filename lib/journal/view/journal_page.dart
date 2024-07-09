import 'package:budsy/app/colors.dart';
import 'package:budsy/app/icons.dart';
import 'package:budsy/app/system/bottom_nav.dart';
import 'package:budsy/consts.dart';
import 'package:budsy/entries/mock/mock_products.dart';
import 'package:budsy/entries/model/journal_entry.dart';
import 'package:budsy/entries/model/product.dart';
import 'package:budsy/journal/mock/mock_journal_entries.dart';
import 'package:budsy/journal/view/add_journal_page.dart';
import 'package:budsy/journal/view/sheets/view_journal_entry_sheet.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,

      floatingActionButton: const JournalPageFAB(),
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

class JournalPageFAB extends StatelessWidget {
  const JournalPageFAB({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      distance: 72,
      duration: const Duration(milliseconds: 400),
      overlayStyle: const ExpandableFabOverlayStyle(color: Colors.black54),
      closeButtonBuilder: FloatingActionButtonBuilder(
        size: 60,
        builder: (context, onPressed, progress) => FloatingActionButton(
          onPressed: onPressed,
          child: PhosphorIcon(PhosphorIcons.xCircle(PhosphorIconsStyle.fill)),
        ),
      ),
      openButtonBuilder: FloatingActionButtonBuilder(
        size: 80,
        builder: (context, onPressed, progress) => FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          onPressed: onPressed,
          child: PhosphorIcon(PhosphorIcons.plus(PhosphorIconsStyle.bold)),
        ),
      ),
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  'Add Session',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                onPressed: () {
                  GoRouter.of(context).go('/journal/add');
                },
                child: PhosphorIcon(
                    PhosphorIcons.notepad(PhosphorIconsStyle.fill))),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  'Add Feeling',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                onPressed: () => context.push('/add'),
                child: PhosphorIcon(
                    PhosphorIcons.smiley(PhosphorIconsStyle.fill))),
          ],
        ),
      ],
    );
  }
}

class JournalEntryList extends StatefulWidget {
  const JournalEntryList({
    super.key,
  });

  @override
  State<JournalEntryList> createState() => _JournalEntryListState();
}

class _JournalEntryListState extends State<JournalEntryList> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          List<JournalEntry> journalEntries = mockJournalEntries;
          journalEntries.sort(
            (a, b) => b.createdAt.compareTo(a.createdAt),
          );
          JournalEntry journalEntry = journalEntries[index];
          if (journalEntry.type == EntryType.session) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: SessionListTile(journalEntry: journalEntry),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: FeelingListTile(journalEntry: journalEntry),
            );
          }
        },
        childCount: mockJournalEntries.length,
      ),
    );
  }
}

class FeelingListTile extends StatefulWidget {
  final JournalEntry journalEntry;
  const FeelingListTile({required this.journalEntry, super.key});

  @override
  State<FeelingListTile> createState() => _FeelingListTileState();
}

class _FeelingListTileState extends State<FeelingListTile>
    with SingleTickerProviderStateMixin {
  late var slidableController = SlidableController(this);

  bool slidableOpen = false;
  @override
  Widget build(BuildContext context) {
    JournalEntry journalEntry = widget.journalEntry;
    int feelingCount = journalEntry.feelings!.length;
    bool overFeelingAvatarLimit = journalEntry.feelings!.length > 3;
    int feelingAvatarLimit =
        overFeelingAvatarLimit ? 4 : journalEntry.feelings!.length;
    double circleAvatarRadius = calculateCircleAvatarRadius(feelingCount);
    double iconSize = calculateIconRadius(feelingCount);
    String feelingSummaryString =
        composeFeelingSummaryString(journalEntry.feelings!);
    double listTilePadding = journalEntry.feelings!.length > 2 ? 8.0 : 16.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Slidable(
            controller: slidableController,
            startActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {},
                  icon: PhosphorIcons.trashSimple(),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                  ),
                  backgroundColor: Colors.redAccent,
                ),
                SlidableAction(
                  onPressed: (context) {},
                  icon: PhosphorIcons.pencilSimple(),
                  // borderRadius: const BorderRadius.only(
                  //   topRight: Radius.circular(16.0),
                  //   bottomRight: Radius.circular(16.0),
                  // ),
                  backgroundColor: Colors.blueAccent,
                )
              ],
            ),
            child: Card(
              child: InkWell(
                onTap: () async {
                  slidableOpen
                      ? await slidableController.close().then((value) {
                          setState(() {
                            slidableOpen = !slidableOpen;
                          });
                        })
                      : await slidableController.openStartActionPane().then(
                          (value) {
                            setState(() {
                              slidableOpen = !slidableOpen;
                            });
                          },
                        );

                  print('Slidable open: $slidableOpen');
                  print('Tapped');
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: listTilePadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 4.0,
                            direction: Axis.horizontal,
                            runSpacing:
                                journalEntry.feelings!.length > 3 ? 4.0 : 0,
                            children: [
                              for (int i = 0; i < feelingAvatarLimit; i++)
                                CircleAvatar(
                                  radius: circleAvatarRadius,
                                  backgroundColor: getColorForFeeling(
                                      journalEntry.feelings![i]),
                                  child: PhosphorIcon(
                                    getIconForFeeling(
                                        journalEntry.feelings![i]),
                                    size: iconSize,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.white
                                        : null,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0, left: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                feelingSummaryString,
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
                      // Expanded(
                      //   flex: 4,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Row(
                      //       mainAxisSize: MainAxisSize.min,
                      //       mainAxisAlignment: MainAxisAlignment.end,
                      //       children: [
                      //         Flexible(
                      //           child: Chip(
                      //             visualDensity: VisualDensity.compact,
                      //             avatar: PhosphorIcon(
                      //               getIconForCategory(
                      //                   journalEntry.product.category!),
                      //               size: 16,
                      //             ),
                      //             label: Text(
                      //               journalEntry.product.name!,
                      //               maxLines: 1,
                      //               overflow: TextOverflow.fade,
                      //               softWrap: false,
                      //               style: Theme.of(context).textTheme.bodySmall,
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SessionListTile extends StatefulWidget {
  final JournalEntry journalEntry;
  const SessionListTile({required this.journalEntry, super.key});

  @override
  State<SessionListTile> createState() => _SessionListTileState();
}

class _SessionListTileState extends State<SessionListTile>
    with SingleTickerProviderStateMixin {
  late var slidableController = SlidableController(this);

  bool slidableOpen = false;
  @override
  Widget build(BuildContext context) {
    JournalEntry journalEntry = widget.journalEntry;
    Product product = journalEntry.product!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Slidable(
                controller: slidableController,
                startActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {},
                      icon: PhosphorIcons.trashSimple(),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                    SlidableAction(
                      onPressed: (context) {},
                      icon: PhosphorIcons.pencilSimple(),
                      // borderRadius: const BorderRadius.only(
                      //   topRight: Radius.circular(16.0),
                      //   bottomRight: Radius.circular(16.0),
                      // ),
                      backgroundColor: Colors.blueAccent,
                    )
                  ],
                ),
                child: InkWell(
                  onTap: () async {
                    slidableOpen
                        ? await slidableController.close().then((value) {
                            setState(() {
                              slidableOpen = !slidableOpen;
                            });
                          })
                        : await slidableController.openStartActionPane().then(
                            (value) {
                              setState(() {
                                slidableOpen = !slidableOpen;
                              });
                            },
                          );

                    print('Slidable open: $slidableOpen');
                    print('Tapped');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 4.0,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: getColorForProductCategory(
                                    product.category!),
                                child: PhosphorIcon(
                                  getIconForCategory(product.category!),
                                  size: 24,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 4.0, left: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  product.name!,
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
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                        ),
                        // Expanded(
                        //   flex: 4,
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: Row(
                        //       mainAxisSize: MainAxisSize.min,
                        //       mainAxisAlignment: MainAxisAlignment.end,
                        //       children: [
                        //         Flexible(
                        //           child: Chip(
                        //             visualDensity: VisualDensity.compact,
                        //             avatar: PhosphorIcon(
                        //               getIconForCategory(
                        //                   journalEntry.product!.category!),
                        //               size: 16,
                        //             ),
                        //             label: Text(
                        //               journalEntry.product!.name!,
                        //               maxLines: 1,
                        //               overflow: TextOverflow.fade,
                        //               softWrap: false,
                        //               style: Theme.of(context).textTheme.bodySmall,
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
