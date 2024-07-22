import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:canjo/app/colors.dart';
import 'package:canjo/app/icons.dart';
import 'package:canjo/app/snackbars.dart';
import 'package:canjo/app/system/bottom_nav.dart';
import 'package:canjo/journal/bloc/journal_bloc.dart';
import 'package:canjo/journal/cubit/feelings_cubit.dart';
import 'package:canjo/journal/model/feeling.dart';
import 'package:canjo/stash/bloc/stash_bloc.dart';
import 'package:canjo/stash/mock/mock_products.dart';
import 'package:canjo/journal/model/journal_entry.dart';
import 'package:canjo/stash/model/product.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uuid/uuid.dart';

class AddEntryPage extends StatefulWidget {
  const AddEntryPage({super.key});

  @override
  State<AddEntryPage> createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  List<Product> selectedProducts = [];
  List<Feeling> selectedFeelings = [];
  final TextEditingController notesController = TextEditingController();

  int intensity = 5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      // controller: controller,
      slivers: [
        const SliverAppBar.medium(
          title: Text('New Entry'),
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
                  BlocBuilder<StashBloc, StashState>(
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
                        return CustomDropdown<Product>.multiSelectSearch(
                          hintText: 'Add Product(s)',
                          // TODO: Replace with actual products
                          items: state.products,
                          overlayHeight:
                              MediaQuery.sizeOf(context).height * 0.4,
                          searchHintText: 'Search Products',
                          onListChanged: (value) {
                            setState(() {
                              selectedProducts = value;
                            });
                          },
                          headerListBuilder: (context, selectedItems, enabled) {
                            return Wrap(
                              runSpacing: 8,
                              children: [
                                for (var item in selectedItems)
                                  Flexible(
                                    child: Container(
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
                                          Icon(
                                              getIconForCategory(
                                                  item.category!),
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
                if (state is JournalEntryAdded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Entry added'),
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
                                type: EntryType.feeling,
                              );
                              context.read<JournalBloc>().add(AddJournalEntry(
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
                                      Flexible(
                                          child: Chip(
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
                                      )),
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
                                if (selectedFeelings.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    getErrorSnackBar(
                                        'Please select at least one feeling'),
                                  );
                                }
                                if (selectedProducts.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      getErrorSnackBar(
                                          'Please select at least one product'));
                                }

                                if (selectedFeelings.isEmpty ||
                                    selectedProducts.isEmpty) {
                                  return;
                                }

                                JournalEntry entry = JournalEntry(
                                  feelings: selectedFeelings,
                                  products: selectedProducts,
                                  notes: notesController.value.text.isNotEmpty
                                      ? notesController.value.text
                                      : null,
                                  type: EntryType.feeling,
                                );
                                context
                                    .read<JournalBloc>()
                                    .add(AddJournalEntry(entry));
                              },
                              child: const Text('Add Entry'),
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
