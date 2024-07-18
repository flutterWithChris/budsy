import 'package:budsy/app/colors.dart';
import 'package:budsy/app/icons.dart';
import 'package:budsy/app/system/bottom_nav.dart';
import 'package:budsy/consts.dart';
import 'package:budsy/journal/bloc/journal_bloc.dart';
import 'package:budsy/journal/model/feeling.dart';
import 'package:budsy/journal/model/journal_entry.dart';
import 'package:budsy/stash/model/product.dart';
import 'package:budsy/journal/view/add_feeling_page.dart';
import 'package:budsy/journal/view/add_entry_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:list_ext/list_ext.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const JournalPageFAB(),
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
        ],
      ),
    );
  }
}

class JournalPageFAB extends StatefulWidget {
  const JournalPageFAB({
    super.key,
  });

  @override
  State<JournalPageFAB> createState() => _JournalPageFABState();
}

class _JournalPageFABState extends State<JournalPageFAB> {
  final _fabKey = GlobalKey<ExpandableFabState>();
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      // key: _fabKey,
      onPressed: () async => context.push('/add-entry'),
      child: const Icon(Icons.add),
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
    return BlocBuilder<JournalBloc, JournalState>(
      builder: (context, state) {
        if (state is JournalLoading) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        if (state is JournalLoaded && state.entries.isNotEmpty) {
          print('Journal Loaded & Entries not empty');
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                List<JournalEntry> journalEntries = state.entries;
                print('Journal Entries In Widget: $journalEntries');
                journalEntries.sort(
                  (a, b) => b.createdAt!.compareTo(a.createdAt!),
                );
                JournalEntry journalEntry = journalEntries[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: FeelingListTile(journalEntry: journalEntry),
                );
              },
              childCount: state.entries.length,
            ),
          );
        }
        if (state is JournalLoaded && state.entries.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('No journal entries found'),
              ),
            ),
          );
        } else {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('Something went wrong'),
              ),
            ),
          );
        }
      },
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
    bool hasProducts =
        journalEntry.products != null && journalEntry.products!.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            child: InkWell(
              onTap: () async => await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return ViewEntrySheet(
                      entry: widget.journalEntry,
                    );
                  }),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: listTilePadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: hasProducts
                            ? const EdgeInsets.only(left: 8.0)
                            : const EdgeInsets.only(right: 8.0),
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
                                  getIconForFeeling(journalEntry.feelings![i]),
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
                      flex: hasProducts ? 2 : 3,
                      child: Padding(
                        padding: hasProducts
                            ? const EdgeInsets.only(left: 16.0)
                            : const EdgeInsets.only(left: 0.0),
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
                                Jiffy.parseFromDateTime(journalEntry.createdAt!)
                                    .fromNow(),
                                style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ),
                    if (hasProducts)
                      Expanded(
                        flex: 2,
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
                                        journalEntry.products!.first.category!),
                                    size: 16,
                                  ),
                                  label: Text(
                                    journalEntry.products!.first.name!,
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ),
                              if (journalEntry.products!.length > 1)
                                const Gap(size: 8.0),
                              if (journalEntry.products!.length > 1)
                                Text(
                                  '+${journalEntry.products!.length - 1}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
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
    List<Product> product = journalEntry.products!;
    String productSummaryString = composeProductSummaryString(product);
    print('Product Summary String: $productSummaryString');
    List<ProductCategory> productCategories = [];
    // Add product categories to list if they don't already exist
    for (Product product in journalEntry.products!) {
      if (!productCategories.contains(product.category)) {
        productCategories.add(product.category!);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Card(
        child: InkWell(
          onTap: () async => await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return ViewSessionSheet(
                  session: widget.journalEntry,
                );
              }),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
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
                            for (int i = 0; i < productCategories.length; i++)
                              CircleAvatar(
                                radius: calculateCircleAvatarRadius(
                                    productCategories.length),
                                backgroundColor: getColorForProductCategory(
                                    productCategories[i]),
                                child: PhosphorIcon(
                                  getIconForCategory(productCategories[i]),
                                  size: calculateIconRadius(
                                      productCategories.length),
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
                          padding: const EdgeInsets.only(
                            right: 16.0,
                            left: 12.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                productSummaryString,
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
                                          journalEntry.createdAt!)
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ViewSessionSheet extends StatelessWidget {
  final JournalEntry session;
  const ViewSessionSheet({required this.session, super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Session',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Feeling bottom sheet
class ViewEntrySheet extends StatelessWidget {
  final JournalEntry entry;
  const ViewEntrySheet({required this.entry, super.key});

  @override
  Widget build(BuildContext context) {
    List<ProductCategory> productCategories = [];
    print('Entry ${entry.id} Products: ${entry.products}');
    // Add product categories to list if they don't already exist
    for (Product product in entry.products!) {
      if (!productCategories.contains(product.category)) {
        productCategories.add(product.category!);
      }
    }
    String categorySummaryString =
        composeCategorySummaryString(entry.products!);
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.25,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Entry',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () => context.push(
                                    '/edit-entry/${entry.id}',
                                    extra: entry),
                                icon: PhosphorIcon(PhosphorIcons.pencil(
                                    PhosphorIconsStyle.fill))),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Gap(size: 8.0),
                    Row(
                      children: [
                        if (entry.products.isNotNullOrEmpty)
                          ProductCategorySummary(
                            productCategories: productCategories,
                          ),
                        const Gap(size: 8.0),
                        Text(
                          composeProductSummaryString(entry.products!),
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const Gap(size: 16.0),
                    Text(
                      'Feelings',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Gap(size: 8.0),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 0.0,
                      children: [
                        for (Feeling feeling in entry.feelings!)
                          Chip(
                            backgroundColor: getColorForFeeling(feeling),
                            side: BorderSide.none,
                            avatar: PhosphorIcon(
                              getIconForFeeling(feeling),
                              size: 16.0,
                              color: getContrastingColor(
                                getColorForFeeling(feeling),
                              ),
                            ),
                            label: Text(
                              feeling.name!.capitalize,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: getContrastingColor(
                                          getColorForFeeling(feeling))),
                            ),
                          ),
                      ],
                    ),
                    const Gap(size: 16.0),
                    if (entry.notes != null && entry.notes!.isNotEmpty)
                      Column(
                        children: [
                          Text(
                            'Notes',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const Gap(size: 8.0),
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Wrap with product categories & icons
class ProductCategorySummary extends StatelessWidget {
  final List<ProductCategory> productCategories;
  const ProductCategorySummary({required this.productCategories, super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: [
        for (ProductCategory category in productCategories)
          CircleAvatar(
            radius: 14.0,
            backgroundColor: getColorForProductCategory(category),
            child: PhosphorIcon(
              getIconForCategory(
                category,
              ),
              size: 14.0,
              color: getContrastingColor(
                Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
          )
      ],
    );
  }
}

// Compose product summary string, e.g. "Product A, Product B, & Product C". Commas separate each product, and the last product is preceded by an ampersand.
String composeProductSummaryString(List<Product> products) {
  String productSummaryString = '';
  for (int i = 0; i < products.length; i++) {
    if (products.length == 1) {
      productSummaryString += products[i].name!;
    } else {
      if (i == products.length - 1) {
        productSummaryString += '& ${products[i].name}';
      } else if (products.length > 2) {
        productSummaryString += '${products[i].name}, ';
      } else if (products.length <= 2) {
        productSummaryString += '${products[i].name} ';
      }
    }
  }
  return productSummaryString;
}

// Compose category summary string, e.g. "Category A, Category B, & Category C". Commas separate each category, and the last category is preceded by an ampersand.
String composeCategorySummaryString(List<Product> products) {
  List<ProductCategory> productCategories = [];
  for (Product product in products) {
    if (!productCategories.contains(product.category)) {
      productCategories.add(product.category!);
    }
  }
  String categorySummaryString = '';
  for (int i = 0; i < productCategories.length; i++) {
    if (productCategories.length == 1) {
      categorySummaryString += productCategories[i].name.capitalize;
    } else {
      if (i == productCategories.length - 1) {
        categorySummaryString += '& ${productCategories[i].name.capitalize}';
      } else if (productCategories.length > 2) {
        categorySummaryString += '${productCategories[i].name.capitalize}, ';
      } else if (productCategories.length <= 2) {
        categorySummaryString += '${productCategories[i].name.capitalize} ';
      }
    }
  }
  return categorySummaryString;
}
