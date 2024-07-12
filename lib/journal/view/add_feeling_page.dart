import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:budsy/app/colors.dart';
import 'package:budsy/app/icons.dart';
import 'package:budsy/stash/model/journal_entry.dart';
import 'package:budsy/stash/model/product.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
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
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomDropdown<Feeling>.multiSelectSearch(
                            items: Feeling.values,
                            overlayHeight:
                                MediaQuery.sizeOf(context).height * 0.4,
                            onListChanged: (selectedFeelings) {
                              setState(() {
                                this.selectedFeelings = selectedFeelings;
                              });
                            },
                            hintText: 'Select Feeling(s)',
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
                                      label: Text(feeling.name.capitalize),
                                      avatar: PhosphorIcon(
                                        getIconForFeeling(feeling),
                                        size: 16,
                                        color: Colors.white,
                                      ),
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
                                            label:
                                                Text(feeling.name.capitalize),
                                            avatar: PhosphorIcon(
                                              getIconForFeeling(feeling),
                                              size: 16,
                                              color: Colors.white,
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
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Add Entry'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
    );
  }
}
