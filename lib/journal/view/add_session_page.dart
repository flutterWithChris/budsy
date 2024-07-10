import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:budsy/app/icons.dart';
import 'package:budsy/app/system/bottom_nav.dart';
import 'package:budsy/entries/mock/mock_products.dart';
import 'package:budsy/entries/model/journal_entry.dart';
import 'package:budsy/entries/model/product.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddSessionPage extends StatefulWidget {
  const AddSessionPage({super.key});

  @override
  State<AddSessionPage> createState() => _AddSessionPageState();
}

class _AddSessionPageState extends State<AddSessionPage> {
  List<Product> selectedProducts = [];
  int intensity = 5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const BottomNavBar(),
        body: CustomScrollView(slivers: [
          SliverAppBar(
            title: const Text('Add Session'),
            floating: true,
            snap: true,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomDropdown<Product>.multiSelectSearch(
                  hintText: 'Select Product(s)',
                  items: mockProducts,
                  onListChanged: (selectedProducts) {
                    setState(() {
                      this.selectedProducts = selectedProducts;
                    });
                    print('Selected Products: $selectedProducts');
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
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
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
                          ),
                      ],
                    );
                  },
                  decoration: CustomDropdownDecoration(
                      expandedFillColor:
                          Theme.of(context).inputDecorationTheme.fillColor,
                      closedFillColor:
                          Theme.of(context).inputDecorationTheme.fillColor,
                      listItemDecoration: ListItemDecoration(
                        selectedColor:
                            Theme.of(context).colorScheme.primaryContainer,
                      ),
                      searchFieldDecoration: SearchFieldDecoration(
                        fillColor:
                            Theme.of(context).inputDecorationTheme.fillColor,
                      )),
                  listItemBuilder: (context, item, isSelected, onItemSelect) {
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
                                Text(item.name!),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final entry = JournalEntry(
                      id: const Uuid().v4(),
                      createdAt: DateTime.now(),
                      type: EntryType.feeling,
                      products: selectedProducts,
                      // feelings: selectedFeelings,
                      intensity: intensity,
                    );
                    // context.read<JournalBloc>().add(AddJournalEntry(entry));
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          )),
        ]));
  }
}
