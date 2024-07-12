import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:budsy/app/system/bottom_nav.dart';
import 'package:budsy/consts.dart';
import 'package:budsy/stash/mock/mock_products.dart';
import 'package:budsy/stash/model/cannabinoid.dart';
import 'package:budsy/stash/model/product.dart';
import 'package:budsy/stash/model/terpene.dart';
import 'package:budsy/lab_reports/lab_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NewEntryScreen extends StatefulWidget {
  const NewEntryScreen({super.key});

  @override
  State<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  String? _filePath;
  LabReport? labReport;
  final bool _isProcessing = false;
  IconData? _selectedCategoryIcon;
  IconData? _selectedTypeIcon;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _dispensaryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  FlowerUnit? _flowerUnit;
  Product _product = Product(
    id: null,
    name: null,
    images: [],
    description: null,
    category: null,
    type: null,
    price: null,
    weight: null,
    unit: null,
    dispensary: null,
    brand: null,
    cannabinoids: [],
    terpenes: [],
  );

  XFile? _imageFile;

  List<Cannabinoid> selectedCannabinoids = [];
  List<Cannabinoid> requiredCannabinoids = [
    cannabinoids[0].copyWith(amount: 0),
    cannabinoids[1].copyWith(amount: 0),
  ];
  List<Terpene> selectedTerpenes = [];

  @override
  void initState() {
    super.initState();
  }

  void _addCannabinoid() {
    setState(() {
      if (selectedCannabinoids.length + 2 >= cannabinoids.length) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('You have already added all available cannabinoids'),
        ));
        return;
      }
      selectedCannabinoids.add(cannabinoids[selectedCannabinoids.length + 2]);
    });
  }

  void _updateCannabinoid(Cannabinoid cannabinoid, double value) {
    setState(() {
      selectedCannabinoids.remove(cannabinoid);
    });
  }

  void _removeCannabinoid(Cannabinoid cannabinoid) {
    setState(() {
      selectedCannabinoids.remove(cannabinoid);
    });
  }

  void _addTerpene() {
    setState(() {
      if (selectedTerpenes.length >= terpenes.length) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('You have already added all available terpenes'),
        ));
        return;
      }
      selectedTerpenes.add(terpenes[selectedTerpenes.length]);
    });
  }

  void _updateTerpene(Terpene terpene, double value) {
    setState(() {
      selectedTerpenes.removeWhere((element) => element.name == terpene.name);
      selectedTerpenes.add(terpene);
    });
  }

  void _removeTerpene(String terpene) {
    setState(() {
      selectedTerpenes.removeWhere((element) => element.name == terpene);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('selectedCannabinoids: $selectedCannabinoids');
    return Scaffold(
        bottomNavigationBar: const BottomNavBar(),
        appBar: AppBar(
          title: const Text('Add To Stash'),
        ),
        body: CustomScrollView(slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      _imageFile != null
                          ? Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.file(
                                      File(_imageFile!.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Card(
                                    // decoration: BoxDecoration(
                                    //   borderRadius: BorderRadius.circular(16),
                                    //   border: Border.all(
                                    //     color: Theme.of(context)
                                    //         .colorScheme
                                    //         .onSurface,
                                    //   ),
                                    // ),
                                    child: InkWell(
                                      onTap: () async {
                                        try {
                                          await showImagePicker(context)
                                              .then((value) async {
                                            if (value != null) {
                                              final filePath = value.path;
                                              setState(() {
                                                _filePath = filePath;
                                                _imageFile = value;
                                              });

                                              _product = _product.copyWith(
                                                images: [filePath],
                                              );
                                              print(
                                                  'Product: ${_product.toString()}');
                                            }
                                          });
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      child: Center(
                                        child: IconButton(
                                          onPressed: () async {
                                            try {
                                              await showImagePicker(context)
                                                  .then((value) async {
                                                if (value != null) {
                                                  final filePath = value.path;
                                                  setState(() {
                                                    _filePath = filePath;
                                                    _imageFile = value;
                                                  });

                                                  _product = _product.copyWith(
                                                    images: [filePath],
                                                  );
                                                  print(
                                                      'Product: ${_product.toString()}');
                                                }
                                              });
                                            } catch (e) {
                                              print(e);
                                            }
                                          },
                                          icon: PhosphorIcon(
                                            PhosphorIcons.imageSquare(
                                                PhosphorIconsStyle.duotone),
                                            size: 32,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // _imageFile != null
                                //     ? const SizedBox()
                                //     : IconButton.filled(
                                //         onPressed: () async {
                                //           try {
                                //             await showImagePicker(context);
                                //           } catch (e) {
                                //             print(e);
                                //           }
                                //         },
                                //         icon: const Icon(Icons.camera)),
                                // _imageFile != null
                                //     ? const SizedBox()
                                //     : const Gap(size: 8),
                                Expanded(
                                    flex: 5,
                                    child: TextField(
                                      controller: _nameController,
                                      onChanged: (value) => setState(() {
                                        _product =
                                            _product.copyWith(name: value);
                                      }),
                                      textCapitalization:
                                          TextCapitalization.words,
                                      decoration: const InputDecoration(
                                        label: Text('Name'),
                                        hintText:
                                            'Jack Herer, Dreamberry Gummies, etc.',
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                    )),
                              ],
                            ),
                            const Gap(size: 16),
                            DropdownMenu(
                              menuStyle: MenuStyle(
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                              onSelected: (value) {
                                setState(() {
                                  if (value != null) {
                                    _product =
                                        _product.copyWith(category: value);
                                    print('Product: ${_product.toString()}');
                                    switch (value) {
                                      case ProductCategory.flower:
                                        _selectedCategoryIcon =
                                            PhosphorIcons.plant(
                                                PhosphorIconsStyle.duotone);
                                        break;
                                      case ProductCategory.edible:
                                        _selectedCategoryIcon =
                                            PhosphorIcons.cookie(
                                                PhosphorIconsStyle.duotone);
                                        break;
                                      case ProductCategory.concentrate:
                                        _selectedCategoryIcon =
                                            PhosphorIcons.drop(
                                                PhosphorIconsStyle.duotone);
                                        break;
                                      case ProductCategory.cartridge:
                                        _selectedCategoryIcon =
                                            PhosphorIcons.cloud(
                                                PhosphorIconsStyle.duotone);
                                        break;
                                      case ProductCategory.topical:
                                        _selectedCategoryIcon =
                                            PhosphorIcons.jarLabel(
                                                PhosphorIconsStyle.duotone);
                                        break;
                                      default:
                                        _selectedCategoryIcon = null;
                                    }
                                  }
                                });
                              },
                              label: const Text('Category'),
                              leadingIcon: _selectedCategoryIcon == null
                                  ? null
                                  : PhosphorIcon(_selectedCategoryIcon!),
                              expandedInsets: EdgeInsets.zero,
                              dropdownMenuEntries: [
                                DropdownMenuEntry(
                                  leadingIcon: PhosphorIcon(PhosphorIcons.plant(
                                      PhosphorIconsStyle.duotone)),
                                  label: 'Flower',
                                  value: ProductCategory.flower,
                                ),
                                DropdownMenuEntry(
                                  leadingIcon: PhosphorIcon(
                                      PhosphorIcons.cookie(
                                          PhosphorIconsStyle.duotone)),
                                  label: 'Edible',
                                  value: ProductCategory.edible,
                                ),
                                DropdownMenuEntry(
                                  leadingIcon: PhosphorIcon(PhosphorIcons.drop(
                                      PhosphorIconsStyle.duotone)),
                                  label: 'Concentrate',
                                  value: ProductCategory.concentrate,
                                ),
                                DropdownMenuEntry(
                                  leadingIcon: PhosphorIcon(PhosphorIcons.cloud(
                                      PhosphorIconsStyle.duotone)),
                                  label: 'Vape',
                                  value: ProductCategory.cartridge,
                                ),
                                DropdownMenuEntry(
                                  leadingIcon: PhosphorIcon(
                                      PhosphorIcons.jarLabel(
                                          PhosphorIconsStyle.duotone)),
                                  label: 'Topical',
                                  value: ProductCategory.topical,
                                ),
                              ],
                            ),
                            const Gap(size: 16),
                            DropdownMenu(
                              expandedInsets: EdgeInsets.zero,
                              label: const Text('Type'),
                              leadingIcon: _selectedTypeIcon == null
                                  ? null
                                  : PhosphorIcon(_selectedTypeIcon!),
                              onSelected: (value) {
                                setState(() {
                                  if (value != null) {
                                    _product = _product.copyWith(type: value);
                                    print('Product: ${_product.toString()}');
                                    switch (value) {
                                      case FlowerType.sativa:
                                        _selectedTypeIcon =
                                            PhosphorIcons.lightning(
                                                PhosphorIconsStyle.duotone);
                                        break;
                                      case FlowerType.indica:
                                        _selectedTypeIcon = PhosphorIcons.waves(
                                            PhosphorIconsStyle.duotone);
                                        break;
                                      case FlowerType.hybrid:
                                        _selectedTypeIcon =
                                            PhosphorIcons.intersect(
                                                PhosphorIconsStyle.duotone);
                                        break;
                                      default:
                                        _selectedTypeIcon = null;
                                    }
                                  }
                                });
                              },
                              dropdownMenuEntries: [
                                DropdownMenuEntry(
                                  leadingIcon: PhosphorIcon(
                                      PhosphorIcons.lightning(
                                          PhosphorIconsStyle.duotone)),
                                  label: 'Sativa',
                                  value: FlowerType.sativa,
                                ),
                                DropdownMenuEntry(
                                  leadingIcon: PhosphorIcon(PhosphorIcons.waves(
                                      PhosphorIconsStyle.duotone)),
                                  label: 'Indica',
                                  value: FlowerType.indica,
                                ),
                                DropdownMenuEntry(
                                  leadingIcon: PhosphorIcon(
                                      PhosphorIcons.intersect(
                                          PhosphorIconsStyle.duotone)),
                                  label: 'Hybrid',
                                  value: FlowerType.hybrid,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(size: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a cost';
                            } else if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            label: Text('Cost'),
                            hintText: '100, 50, 25, etc.',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text('\$'),
                            ),
                            prefixIconConstraints:
                                BoxConstraints(minWidth: 20, minHeight: 0),
                          ),
                        ),
                      ),
                      const Gap(size: 16),
                      Expanded(
                        child: DropdownMenu(
                            menuStyle: MenuStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                            onSelected: (value) => setState(() {
                                  _flowerUnit = value;
                                }),
                            expandedInsets: EdgeInsets.zero,
                            dropdownMenuEntries: const [
                              DropdownMenuEntry(
                                label: 'Gram (1g)',
                                value: FlowerUnit.gram,
                              ),
                              DropdownMenuEntry(
                                label: 'Eighth (3.5g)',
                                value: FlowerUnit.eighth,
                              ),
                              DropdownMenuEntry(
                                label: 'Quarter (7g)',
                                value: FlowerUnit.quarter,
                              ),
                              DropdownMenuEntry(
                                label: 'Half (14g)',
                                value: FlowerUnit.half,
                              ),
                              DropdownMenuEntry(
                                label: 'Ounce (28g)',
                                value: FlowerUnit.ounce,
                              ),
                            ],
                            label: const Text('Unit')),
                      ),
                    ],
                  ),
                  const Gap(size: 16),
                  const Row(
                    children: [
                      Expanded(
                        child: TextField(
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText: 'Dispensary',
                            hintText: 'Green Thumb, The Green Door, etc',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                      Gap(size: 16),
                      Expanded(
                        child: TextField(
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText: 'Brand',
                            hintText: 'Cookies, Bloom Farms, etc.',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(size: 8),
                  for (Cannabinoid cannabinoid in requiredCannabinoids)
                    CannabinoidTextFields(
                        cannabinoid: cannabinoid,
                        selectedCannabinoids: requiredCannabinoids),
                  // Dropdown for Cannabinoids
                  for (Cannabinoid cannabinoid in selectedCannabinoids)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: DropdownMenu<Cannabinoid>(
                              initialSelection: cannabinoid,
                              menuStyle: MenuStyle(
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                              inputDecorationTheme: Theme.of(context)
                                  .inputDecorationTheme
                                  .copyWith(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                              onSelected: (cannabinoid) {
                                // Add cannabinoid to list if not already present
                                if (selectedCannabinoids
                                    .contains(cannabinoid)) {
                                  return;
                                }
                                setState(() {
                                  selectedCannabinoids
                                      .add(cannabinoid!.copyWith(amount: 0.0));
                                });
                              },
                              label: const Text('Cannabinoid'),
                              expandedInsets: EdgeInsets.zero,
                              dropdownMenuEntries: cannabinoids
                                  // .where((c) => !selectedCannabinoids.any(
                                  //     (selectedCannabinoid) =>
                                  //         selectedCannabinoid['name'] == c))
                                  .map((c) => DropdownMenuEntry(
                                        label: c.name!,
                                        value: c,
                                        labelWidget: Row(
                                          children: [
                                            Text(
                                              c.name!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                          const Gap(size: 16),
                          Expanded(
                            flex: 3,
                            child: TextField(
                              controller: TextEditingController.fromValue(
                                TextEditingValue(
                                  text: cannabinoid.amount.toString() ?? '',
                                  selection: TextSelection.collapsed(
                                    offset:
                                        cannabinoid.amount?.toString().length ??
                                            0,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  selectedCannabinoids.removeWhere((element) =>
                                      element.name == cannabinoid.name);
                                  selectedCannabinoids.add(cannabinoid.copyWith(
                                    amount: double.tryParse(value),
                                  ));
                                  print(
                                      'Selected Cannabinoids: ${selectedCannabinoids.toString()}');
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'Value',
                                suffixText: '%',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          if (cannabinoid.name != 'THC' &&
                              cannabinoid.name != 'CBD')
                            Flexible(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    alignment: Alignment.center,
                                    onPressed: () {
                                      setState(() {
                                        selectedCannabinoids
                                            .remove(cannabinoid);
                                      });
                                    },
                                    icon: const Icon(
                                        Icons.remove_circle_outline_rounded),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  const Gap(size: 8),
                  OutlinedButton.icon(
                    onPressed: _addCannabinoid,
                    icon: PhosphorIcon(
                      PhosphorIcons.hexagon(PhosphorIconsStyle.duotone),
                    ),
                    label: const Text('Add Cannabinoid'),
                  ),
                  const Gap(size: 8),
                  // Terpene entry fields
                  for (Terpene terpene in selectedTerpenes)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0, top: 4.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: DropdownMenu(
                              initialSelection: terpene ?? '',
                              menuStyle: MenuStyle(
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                              inputDecorationTheme: Theme.of(context)
                                  .inputDecorationTheme
                                  .copyWith(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                              // onSelected: (terpene) {
                              //   // Add terpene to list if not already present
                              //   // if (selectedTerpenes.any(
                              //   //     (selectedTerpene) =>
                              //   //         selectedTerpene['name'] == terpene)) {
                              //   //   return;
                              //   // }
                              // },

                              label: const Text('Terpene'),
                              expandedInsets: EdgeInsets.zero,
                              dropdownMenuEntries: terpenes
                                  .map((t) => DropdownMenuEntry(
                                        label: t.name!,
                                        value: t,
                                        labelWidget: Row(
                                          children: [
                                            Text(
                                              t.name!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                          const Gap(size: 8),
                          Expanded(
                            flex: 3,
                            child: TextField(
                              controller: TextEditingController.fromValue(
                                TextEditingValue(
                                  text: terpene.amount?.toString() ?? '',
                                  selection: TextSelection.collapsed(
                                    offset:
                                        terpene.amount?.toString().length ?? 0,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  selectedTerpenes.removeWhere((element) =>
                                      element.name == terpene.name);
                                  selectedTerpenes.add(terpene.copyWith(
                                    amount: double.tryParse(value),
                                  ));
                                  print(
                                      'Selected Terpenes: ${selectedTerpenes.toString()}');
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'Value',
                                suffixText: '%',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  alignment: Alignment.center,
                                  onPressed: () {
                                    setState(() {
                                      selectedTerpenes.remove(terpene);
                                    });
                                  },
                                  icon: const Icon(
                                      Icons.remove_circle_outline_rounded),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Gap(size: 8),
                  OutlinedButton.icon(
                    onPressed: _addTerpene,
                    icon: PhosphorIcon(
                      PhosphorIcons.leaf(PhosphorIconsStyle.duotone),
                    ),
                    label: const Text('Add Terpene'),
                  ),
                  _isProcessing
                      ? const CircularProgressIndicator.adaptive()
                      : Text(labReport?.toString() ?? ''),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: () async {
                            Product product = Product(
                              id: null,
                              name: _nameController.value.text,
                              images: _imageFile != null
                                  ? [_imageFile!.path]
                                  : _product.images,
                              description: null,
                              category: _product.category,
                              type: _product.type,
                              price: double.tryParse(_costController.text),
                              weight: null,
                              unit: _flowerUnit,
                              dispensary: _dispensaryController.text,
                              brand: _brandController.text,
                              cannabinoids: [
                                ...requiredCannabinoids,
                                ...selectedCannabinoids
                              ],
                              terpenes: selectedTerpenes,
                            );
                            setState(() {
                              mockProducts.add(product);
                            });
                          },
                          icon: PhosphorIcon(
                            PhosphorIcons.plusCircle(
                                PhosphorIconsStyle.regular),
                          ),
                          label: const Text('Add To Stash'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]));
  }

  Future<dynamic> showImagePicker(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text('Camera'),
                    onTap: () async {
                      final ImagePicker imagePicker = ImagePicker();
                      final XFile? image = await imagePicker.pickImage(
                          source: ImageSource.camera);
                      print(image);
                      if (image != null) {
                        final filePath = image.path;
                        setState(() {
                          _filePath = filePath;
                          _imageFile = image;
                        });

                        // await _sendFileToApi(filePath);
                        context.pop();
                      } else {
                        // User canceled the picker
                        setState(() {
                          _filePath = null;
                        });
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo),
                    title: const Text('Gallery'),
                    onTap: () async {
                      final ImagePicker imagePicker = ImagePicker();
                      final XFile? image = await imagePicker.pickImage(
                          source: ImageSource.gallery);
                      print(image);
                      if (image != null) {
                        final filePath = image.path;
                        setState(() {
                          _filePath = filePath;
                          _imageFile = image;
                        });

                        // await _sendFileToApi(filePath);
                        Navigator.pop(context, image);
                      } else {
                        // User canceled the picker
                        setState(() {
                          _filePath = null;
                        });
                      }
                    },
                  ),
                ],
              );
            });
      },
    );
  }
}

class CannabinoidTextFields extends StatefulWidget {
  final Cannabinoid cannabinoid;
  List<Cannabinoid> selectedCannabinoids;
  CannabinoidTextFields(
      {required this.cannabinoid,
      required this.selectedCannabinoids,
      super.key});

  @override
  State<CannabinoidTextFields> createState() => _CannabinoidTextFieldsState();
}

class _CannabinoidTextFieldsState extends State<CannabinoidTextFields> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    _nameController.text = widget.cannabinoid.name!;
    _valueController.text = widget.cannabinoid.amount.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Cannabinoid',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              readOnly: true,
              canRequestFocus: false,
            ),
          ),
          const Gap(size: 16),
          Expanded(
            flex: 3,
            child: TextField(
              controller: _valueController,
              onChanged: (value) {
                setState(() {
                  widget.selectedCannabinoids.removeWhere(
                      (element) => element.name == widget.cannabinoid.name);
                  widget.selectedCannabinoids.add(widget.cannabinoid.copyWith(
                    amount: double.tryParse(value),
                  ));
                  print(
                      'Selected Cannabinoids: ${widget.selectedCannabinoids.toString()}');
                });
              },
              decoration: const InputDecoration(
                labelText: 'Value',
                suffixText: '%',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          if (widget.cannabinoid.name != 'THC' &&
              widget.cannabinoid.name != 'CBD')
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    alignment: Alignment.center,
                    onPressed: () {
                      setState(() {
                        widget.selectedCannabinoids.remove(widget.cannabinoid);
                      });
                    },
                    icon: const Icon(Icons.remove_circle_outline_rounded),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
