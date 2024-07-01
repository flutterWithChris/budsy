import 'package:budsy/app/colors.dart';
import 'package:budsy/app/icons.dart';
import 'package:budsy/app/system/bottom_nav.dart';
import 'package:budsy/consts.dart';
import 'package:budsy/entries/mock/mock_products.dart';
import 'package:budsy/entries/model/journal_entry.dart';
import 'package:budsy/entries/model/product.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddJournalEntryPage extends StatefulWidget {
  const AddJournalEntryPage({super.key});

  @override
  State<AddJournalEntryPage> createState() => _AddJournalEntryPageState();
}

class _AddJournalEntryPageState extends State<AddJournalEntryPage> {
  JournalEntry? journalEntry;
  List<Feeling> selectedFeelings = [];
  Product? selectedProduct;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const BottomNavBar(),
        body: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              title: const Text('Add Journal Entry'),
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
                    DropdownMenu<Product>(
                      label: const Text('Product'),
                      expandedInsets: EdgeInsets.zero,
                      enableFilter: true,
                      requestFocusOnTap: true,
                      menuStyle: MenuStyle(
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                      onSelected: (product) {
                        setState(() {
                          selectedProduct = product;
                        });
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        FocusScope.of(context).unfocus();
                      },
                      dropdownMenuEntries: mockProducts.map((product) {
                        return DropdownMenuEntry(
                          label: product.name!,
                          value: product,
                        );
                      }).toList(),
                    ),
                    const Gap(size: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add Feelings',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        spacing: 16,
                        // runSpacing: 8,
                        children: Feeling.values.map((feeling) {
                          return InputChip(
                            showCheckmark: false,
                            selected: selectedFeelings.contains(feeling),
                            selectedColor: getColorForFeeling(feeling),
                            color: selectedFeelings.contains(feeling)
                                ? null
                                : WidgetStatePropertyAll(
                                    Colors.blueGrey[500],
                                  ),
                            disabledColor: getColorForFeeling(feeling),
                            visualDensity: VisualDensity.compact,
                            label: Text(feeling.name.capitalize),
                            onSelected: (value) => setState(() {
                              if (selectedFeelings.contains(feeling)) {
                                selectedFeelings.remove(feeling);
                              } else {
                                selectedFeelings.add(feeling);
                              }
                            }),
                            avatar: PhosphorIcon(
                              getIconForFeeling(feeling),
                              size: 16,
                              color: Colors.white,
                            ),
                            side: BorderSide.none,
                            backgroundColor: getColorForFeeling(feeling),
                            deleteIcon: selectedFeelings.contains(feeling)
                                ? const Icon(Icons.close, size: 16)
                                : null,
                            onDeleted: selectedFeelings.contains(feeling)
                                ? () {
                                    setState(() {
                                      selectedFeelings.remove(feeling);
                                    });
                                  }
                                : null,
                          );
                        }).toList(),
                      ),
                    ),
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
        ));
  }
}
