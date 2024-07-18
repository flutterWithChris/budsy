import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:budsy/app/colors.dart';
import 'package:budsy/app/icons.dart';
import 'package:budsy/app/system/bottom_nav.dart';
import 'package:budsy/journal/bloc/journal_bloc.dart';
import 'package:budsy/journal/cubit/feelings_cubit.dart';
import 'package:budsy/journal/model/feeling.dart';
import 'package:budsy/stash/bloc/stash_bloc.dart';
import 'package:budsy/stash/mock/mock_products.dart';
import 'package:budsy/journal/model/journal_entry.dart';
import 'package:budsy/stash/model/product.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uuid/uuid.dart';

class EditEntryPage extends StatefulWidget {
  final JournalEntry journalEntry;
  const EditEntryPage({
    required this.journalEntry,
    super.key,
  });

  @override
  State<EditEntryPage> createState() => _EditEntryPageState();
}

class _EditEntryPageState extends State<EditEntryPage> {
  List<Product> selectedProducts = [];
  List<Feeling> selectedFeelings = [];
  final TextEditingController notesController = TextEditingController();

  int intensity = 5;

  @override
  void initState() {
    // TODO: implement initState

    selectedFeelings = widget.journalEntry.feelings ?? [];
    // selectedProducts = widget.journalEntry.products ?? [];
    notesController.text = widget.journalEntry.notes ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Editing Entry: ${widget.journalEntry.id}');
    return Scaffold(
        body: CustomScrollView(
      // controller: controller,
      slivers: [
        const SliverAppBar.medium(
          title: Text('Edit Entry'),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 16,
          ),
        ),
        SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: BlocBuilder<JournalBloc, JournalState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocConsumer<StashBloc, StashState>(
                    listener: (context, state) {
                      if (state is StashError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                          ),
                        );
                      }
                      // if (state is StashLoaded && state.products.isNotEmpty) {
                      //   setState(() {
                      //     selectedProducts = state.products.where((element) {
                      //       return selectedProducts
                      //           .map((e) => e.id)
                      //           .contains(element.id);
                      //     }).toList();
                      //     print('Selected Products: $selectedProducts');
                      //   });
                      // }
                    },
                    builder: (context, state) {
                      if (state is StashError) {
                        return Center(
                          child: Text(state.message),
                        );
                      }
                      if (state is StashLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is StashLoaded && state.products.isNotEmpty) {
                        print('Loaded');
                        return CustomDropdown<Product>.multiSelectSearch(
                          hintText: 'Add Product(s)',
                          initialItems: widget.journalEntry.products != null &&
                                  selectedProducts.isEmpty
                              ? state.products.where((element) {
                                  return widget.journalEntry.products!
                                      .map((e) => e.id)
                                      .contains(element.id);
                                }).toList()
                              : null,
                          // TODO: Replace with actual products
                          items: state.products,
                          overlayHeight:
                              MediaQuery.sizeOf(context).height * 0.4,
                          searchHintText: 'Search Products',
                          onListChanged: (value) {
                            selectedProducts = value;
                          },
                          headerListBuilder: (context, selectedItems, enabled) {
                            return Wrap(
                              runSpacing: 8,
                              children: [
                                for (var item in selectedItems)
                                  Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: getColorForProductCategory(
                                          item.category!),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(getIconForCategory(item.category!),
                                            size: 16),
                                        const SizedBox(width: 8),
                                        Text(
                                          item.name!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          },
                          decoration: CustomDropdownDecoration(
                              expandedFillColor: Theme.of(context)
                                  .inputDecorationTheme
                                  .fillColor,
                              closedFillColor: Theme.of(context)
                                  .inputDecorationTheme
                                  .fillColor,
                              listItemDecoration: ListItemDecoration(
                                selectedColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              searchFieldDecoration: SearchFieldDecoration(
                                fillColor: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor,
                              )),
                          listItemPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          listItemBuilder:
                              (context, item, isSelected, onItemSelect) {
                            return Row(
                              children: [
                                Container(
                                  child: InkWell(
                                    onTap: () {
                                      onItemSelect();
                                    },
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: isSelected,
                                          onChanged: (value) {
                                            onItemSelect();
                                          },
                                        ),
                                        Chip(
                                          backgroundColor:
                                              getColorForProductCategory(
                                                  item.category!),
                                          visualDensity: VisualDensity.compact,
                                          label: Text(
                                            item.name!,
                                            style: TextStyle(
                                              color: getContrastingColor(
                                                getColorForProductCategory(
                                                    item.category!),
                                              ),
                                            ),
                                          ),
                                          avatar: Icon(
                                              getIconForCategory(
                                                  item.category!),
                                              color: getContrastingColor(
                                                  getColorForProductCategory(
                                                      item.category!)),
                                              size: 16),
                                          side: BorderSide.none,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      }
                      if (state is StashLoaded && state.products.isEmpty) {
                        // TODO: Add a button to add your first product
                        return FilledButton(
                          onPressed: () {
                            context.go('/stash/add');
                          },
                          child: const Text('Add your first product'),
                        );
                      } else {
                        return const Text('Error loading stash!');
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        )),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BlocConsumer<JournalBloc, JournalState>(
              listener: (context, state) async {
                if (state is JournalError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                }
                if (state is JournalEntryUpdated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Entry updated'),
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                    ),
                  );
                  context.pop();
                }
              },
              builder: (context, state) {
                if (state is JournalError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(state.message),
                          TextButton(
                            onPressed: () {
                              JournalEntry entry = JournalEntry(
                                feelings: selectedFeelings,
                                products: selectedProducts,
                                type: EntryType.feeling,
                              );
                              context
                                  .read<JournalBloc>()
                                  .add(UpdateJournalEntry(
                                    entry,
                                  ));
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is JournalLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is JournalLoaded) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<FeelingsCubit, FeelingsState>(
                        builder: (context, state) {
                          if (state is FeelingsError) {
                            return Center(
                              child: Text(state.message),
                            );
                          }
                          if (state is FeelingsLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is FeelingsLoaded &&
                              state.feelings.isEmpty) {
                            return const Text('Error loading feelings');
                          }
                          if (state is FeelingsLoaded &&
                              state.feelings.isNotEmpty) {
                            return CustomDropdown<Feeling>.multiSelectSearch(
                              items: state.feelings,
                              initialItems: state.feelings.where((element) {
                                return selectedFeelings
                                    .map((e) => e.id)
                                    .contains(element.id);
                              }).toList(),
                              overlayHeight:
                                  MediaQuery.sizeOf(context).height * 0.4,
                              onListChanged: (selectedFeelings) {
                                setState(() {
                                  this.selectedFeelings = selectedFeelings;
                                });
                              },
                              hintText: 'Add Feeling(s)',
                              searchHintText: 'Search Feelings',
                              headerListBuilder:
                                  (context, selecteFeelings, enabled) {
                                return Wrap(
                                  runSpacing: 8,
                                  spacing: 8,
                                  children: [
                                    for (var feeling in selectedFeelings)
                                      Chip(
                                        color: WidgetStatePropertyAll(
                                            getColorForFeeling(feeling)),
                                        visualDensity: VisualDensity.compact,
                                        label: Text(
                                          feeling.name!.capitalize,
                                          style: TextStyle(
                                            color: getContrastingColor(
                                              getColorForFeeling(feeling),
                                            ),
                                          ),
                                        ),
                                        avatar: feeling.icon != null &&
                                                feeling.icon!.isNotEmpty
                                            ? PhosphorIcon(
                                                getIconForFeeling(feeling),
                                                size: 16,
                                                color: getContrastingColor(
                                                    getColorForFeeling(
                                                        feeling)),
                                              )
                                            : null,
                                        side: BorderSide.none,
                                        backgroundColor:
                                            getColorForFeeling(feeling),
                                      ),
                                  ],
                                );
                              },
                              decoration: CustomDropdownDecoration(
                                  expandedFillColor: Theme.of(context)
                                      .inputDecorationTheme
                                      .fillColor,
                                  closedFillColor: Theme.of(context)
                                      .inputDecorationTheme
                                      .fillColor,
                                  listItemDecoration: ListItemDecoration(
                                    selectedColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                  ),
                                  searchFieldDecoration: SearchFieldDecoration(
                                    fillColor: Theme.of(context)
                                        .inputDecorationTheme
                                        .fillColor,
                                  )),
                              listItemPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              listItemBuilder:
                                  (context, feeling, isSelected, onItemSelect) {
                                return Row(
                                  children: [
                                    Container(
                                      child: InkWell(
                                        onTap: () {
                                          onItemSelect();
                                        },
                                        child: Row(
                                          children: [
                                            Checkbox(
                                              value: isSelected,
                                              onChanged: (value) {
                                                onItemSelect();
                                              },
                                            ),
                                            Chip(
                                              color: WidgetStatePropertyAll(
                                                  getColorForFeeling(feeling)),
                                              visualDensity:
                                                  VisualDensity.compact,
                                              label: Text(
                                                feeling.name!.capitalize,
                                                style: TextStyle(
                                                    color: getContrastingColor(
                                                        getColorForFeeling(
                                                            feeling))),
                                              ),
                                              avatar: PhosphorIcon(
                                                getIconForFeeling(feeling),
                                                size: 16,
                                                color: getContrastingColor(
                                                    getColorForFeeling(
                                                        feeling)),
                                              ),
                                              side: BorderSide.none,
                                              backgroundColor:
                                                  getColorForFeeling(feeling),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          } else {
                            return const Text('Something went wrong');
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     TextButton(
                      //         onPressed: () {},
                      //         child: const Text('Date: Now')),
                      //   ],
                      // ),
                      TextField(
                        controller: notesController,
                        decoration: InputDecoration(
                          labelText: 'Notes',
                          hintText: 'Add notes',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      BlocBuilder<FeelingsCubit, FeelingsState>(
                        builder: (context, state) {
                          if (state is FeelingsError) {
                            return Center(
                              child: Text(state.message),
                            );
                          }
                          if (state is FeelingsLoading) {
                            return const SizedBox();
                          }
                          if (state is FeelingsLoaded &&
                              state.feelings.isNotEmpty) {
                            return ElevatedButton(
                              onPressed: () {
                                JournalEntry updatedEntry =
                                    widget.journalEntry.copyWith(
                                  feelings: selectedFeelings,
                                  products: selectedProducts,
                                  type: EntryType.feeling,
                                );
                                print('Updated Entry: $updatedEntry');
                                print('Updated Products: $selectedProducts');
                                print('Updated Feelings: $selectedFeelings');

                                context
                                    .read<JournalBloc>()
                                    .add(UpdateJournalEntry(updatedEntry));
                              },
                              child: const Text('Update Entry'),
                            );
                          }
                          if (state is FeelingsLoaded &&
                              state.feelings.isEmpty) {
                            return ElevatedButton(
                              onPressed: () {
                                context.read<FeelingsCubit>().getFeelings();
                              },
                              child: const Text('Retry'),
                            );
                          } else {
                            return const Text('Something went wrong');
                          }
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  );
                } else {
                  return const Text('Something went wrong');
                }
              },
            ),
          ),
        ),
      ],
    ));
  }
}
