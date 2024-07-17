import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:budsy/app/colors.dart';
import 'package:budsy/app/icons.dart';
import 'package:budsy/journal/bloc/journal_bloc.dart';
import 'package:budsy/journal/cubit/feelings_cubit.dart';
import 'package:budsy/journal/model/feeling.dart';
import 'package:budsy/journal/model/journal_entry.dart';
import 'package:budsy/stash/model/product.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddFeelingPage extends StatefulWidget {
  const AddFeelingPage({super.key});

  @override
  State<AddFeelingPage> createState() => _AddFeelingPageState();
}

class _AddFeelingPageState extends State<AddFeelingPage> {
  JournalEntry? journalEntry;
  List<Feeling> selectedFeelings = [];
  Product? selectedProduct;
  int intensity = 5;
  @override
  Widget build(BuildContext context) {
    PhosphorIconData icon = PhosphorIcons.warning();
    print('$icon: ${icon.fontFamily}:${icon.codePoint}');

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.9,
          initialChildSize: 0.65,
          builder: (context, controller) => CustomScrollView(
                controller: controller,
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add Feeling',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          IconButton.filledTonal(
                              onPressed: () => context.pop(),
                              style: IconButton.styleFrom(
                                  fixedSize: const Size(32, 32),
                                  minimumSize: const Size(32, 32)),
                              icon: Icon(
                                  PhosphorIcons.x(PhosphorIconsStyle.bold),
                                  size: 16))
                        ],
                      ),
                    ),
                  ),
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
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
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
                                        context
                                            .read<JournalBloc>()
                                            .add(AddJournalEntry(
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
                                      return const Text(
                                          'Error loading feelings');
                                    }
                                    if (state is FeelingsLoaded &&
                                        state.feelings.isNotEmpty) {
                                      return CustomDropdown<
                                          Feeling>.multiSelectSearch(
                                        items: state.feelings,
                                        overlayHeight:
                                            MediaQuery.sizeOf(context).height *
                                                0.4,
                                        onListChanged: (selectedFeelings) {
                                          setState(() {
                                            this.selectedFeelings =
                                                selectedFeelings;
                                          });
                                        },
                                        hintText: 'Select Feeling(s)',
                                        searchHintText: 'Search Feelings',
                                        headerListBuilder: (context,
                                            selecteFeelings, enabled) {
                                          return Wrap(
                                            runSpacing: 8,
                                            spacing: 8,
                                            children: [
                                              for (var feeling
                                                  in selectedFeelings)
                                                Flexible(
                                                    child: Chip(
                                                  color: WidgetStatePropertyAll(
                                                      getColorForFeeling(
                                                          feeling)),
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  label: Text(
                                                    feeling.name!.capitalize,
                                                    style: TextStyle(
                                                      color:
                                                          getContrastingColor(
                                                        getColorForFeeling(
                                                            feeling),
                                                      ),
                                                    ),
                                                  ),
                                                  avatar:
                                                      feeling.icon != null &&
                                                              feeling.icon!
                                                                  .isNotEmpty
                                                          ? PhosphorIcon(
                                                              getIconForFeeling(
                                                                  feeling),
                                                              size: 16,
                                                              color: getContrastingColor(
                                                                  getColorForFeeling(
                                                                      feeling)),
                                                            )
                                                          : null,
                                                  side: BorderSide.none,
                                                  backgroundColor:
                                                      getColorForFeeling(
                                                          feeling),
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
                                            listItemDecoration:
                                                ListItemDecoration(
                                              selectedColor: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                            ),
                                            searchFieldDecoration:
                                                SearchFieldDecoration(
                                              fillColor: Theme.of(context)
                                                  .inputDecorationTheme
                                                  .fillColor,
                                            )),
                                        listItemBuilder: (context, feeling,
                                            isSelected, onItemSelect) {
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
                                                            getColorForFeeling(
                                                                feeling)),
                                                        visualDensity:
                                                            VisualDensity
                                                                .compact,
                                                        label: Text(
                                                          feeling
                                                              .name!.capitalize,
                                                          style: TextStyle(
                                                              color: getContrastingColor(
                                                                  getColorForFeeling(
                                                                      feeling))),
                                                        ),
                                                        avatar: PhosphorIcon(
                                                          getIconForFeeling(
                                                              feeling),
                                                          size: 16,
                                                          color: getContrastingColor(
                                                              getColorForFeeling(
                                                                  feeling)),
                                                        ),
                                                        side: BorderSide.none,
                                                        backgroundColor:
                                                            getColorForFeeling(
                                                                feeling),
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
                                          JournalEntry entry = JournalEntry(
                                            feelings: selectedFeelings,
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
                                          context
                                              .read<FeelingsCubit>()
                                              .getFeelings();
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
              )),
    );
  }
}
