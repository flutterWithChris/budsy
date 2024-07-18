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
                ],
              )),
    );
  }
}
