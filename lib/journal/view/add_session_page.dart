import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:budsy/app/colors.dart';
import 'package:budsy/app/icons.dart';
import 'package:budsy/app/system/bottom_nav.dart';
import 'package:budsy/stash/mock/mock_products.dart';
import 'package:budsy/journal/model/journal_entry.dart';
import 'package:budsy/stash/model/product.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
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
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.9,
        initialChildSize: 0.65,
        builder: (context, controller) {
          return CustomScrollView(
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
                        'Add Session',
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
                          icon: Icon(PhosphorIcons.x(PhosphorIconsStyle.bold),
                              size: 16))
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomDropdown<Product>.multiSelectSearch(
                      hintText: 'Select Product(s)',
                      // TODO: Replace with actual products
                      items: const [],
                      overlayHeight: MediaQuery.sizeOf(context).height * 0.4,
                      searchHintText: 'Search Products',
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
                            fillColor: Theme.of(context)
                                .inputDecorationTheme
                                .fillColor,
                          )),
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
                                    Icon(getIconForCategory(item.category!),
                                        size: 18),
                                    const SizedBox(width: 8),
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
                      child: const Text('Add Session'),
                    ),
                  ],
                ),
              )),
            ],
          );
        },
      ),
    );
  }
}
