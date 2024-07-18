import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:budsy/app/icons.dart';
import 'package:budsy/app/snackbars.dart';
import 'package:budsy/app/system/bottom_nav.dart';
import 'package:budsy/consts.dart';
import 'package:budsy/stash/bloc/product_details_bloc.dart';
import 'package:budsy/stash/bloc/stash_bloc.dart';
import 'package:budsy/stash/model/cannabinoid.dart';
import 'package:budsy/stash/model/product.dart';
import 'package:budsy/stash/model/terpene.dart';
import 'package:budsy/lab_reports/lab_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class EditProductPage extends StatefulWidget {
  final Product product;
  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
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

  XFile? _imageFile;

  List<Cannabinoid> selectedCannabinoids = [];
  List<Cannabinoid>? requiredCannabinoids;
  List<Terpene> selectedTerpenes = [];
  List<Terpene> allTerpenes = [];
  Product? _productDraft;
  @override
  void initState() {
    print('Product: ${widget.product.toString()}');
    _productDraft = widget.product;
    selectedCannabinoids =
        context.read<ProductDetailsBloc>().state.cannabinoids ?? [];
    selectedTerpenes = context.read<ProductDetailsBloc>().state.terpenes ?? [];
    allTerpenes = context.read<StashBloc>().allTerpenes ?? [];
    _nameController.text = widget.product.name ?? '';
    _costController.text = widget.product.price?.toString() ?? '';
    _dispensaryController.text = widget.product.dispensary ?? '';
    _brandController.text = widget.product.brand ?? '';
    _flowerUnit = widget.product.unit;
    _selectedCategoryIcon = getIconForCategory(widget.product.category!);
    if (widget.product.type != null) {
      // _selectedTypeIcon = getIconForFlowerType(widget.product.type!);
    }

    super.initState();
  }

  // void _addCannabinoid() {
  //   setState(() {
  //     if (selectedCannabinoids.length + 2 >= cannabinoids.length) {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text('You have already added all available cannabinoids'),
  //       ));
  //       return;
  //     }
  //     selectedCannabinoids.add(cannabinoids[selectedCannabinoids.length + 2]);
  //   });
  // }

  // void _updateCannabinoid(Cannabinoid cannabinoid, double value) {
  //   setState(() {
  //     selectedCannabinoids.remove(cannabinoid);
  //   });
  // }

  // void _removeCannabinoid(Cannabinoid cannabinoid) {
  //   setState(() {
  //     selectedCannabinoids.remove(cannabinoid);
  //   });
  // }

  void _addTerpene() {
    setState(() {
      if (selectedTerpenes.length >= terpenes.length) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('You have already added all available terpenes'),
        ));
        return;
      }
      selectedTerpenes.add(allTerpenes
          .where((terpene) {
            return selectedTerpenes.contains(terpene) == false;
          })
          .toList()
          .first);
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
    print('requiredCannabinoids: $requiredCannabinoids');
    return Scaffold(
        bottomNavigationBar: const BottomNavBar(),
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(slivers: [
                const SliverAppBar(
                  title: Text(
                    'Edit Product',
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _imageFile != null
                                ? Flexible(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 16.0),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
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
                                      padding:
                                          const EdgeInsets.only(right: 16.0),
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

                                                    _productDraft =
                                                        _productDraft?.copyWith(
                                                      images: [filePath],
                                                    );
                                                    print(
                                                        'Product: ${_productDraft.toString()}');
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
                                                    await showImagePicker(
                                                            context)
                                                        .then((value) async {
                                                      if (value != null) {
                                                        final filePath =
                                                            value.path;
                                                        setState(() {
                                                          _filePath = filePath;
                                                          _imageFile = value;
                                                        });

                                                        _productDraft =
                                                            _productDraft
                                                                ?.copyWith(
                                                          images: [filePath],
                                                        );
                                                        print(
                                                            'Product: ${_productDraft.toString()}');
                                                      }
                                                    });
                                                  } catch (e) {
                                                    print(e);
                                                  }
                                                },
                                                icon: PhosphorIcon(
                                                  PhosphorIcons.imageSquare(
                                                      PhosphorIconsStyle
                                                          .duotone),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                              _productDraft = _productDraft
                                                  ?.copyWith(name: value);
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
                                    initialSelection: _productDraft?.category,
                                    menuStyle: MenuStyle(
                                      shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                    ),
                                    onSelected: (value) {
                                      setState(() {
                                        if (value != null) {
                                          _productDraft = _productDraft
                                              ?.copyWith(category: value);
                                          print(
                                              'Product: ${_productDraft.toString()}');
                                          switch (value) {
                                            case ProductCategory.flower:
                                              _selectedCategoryIcon =
                                                  PhosphorIcons.plant(
                                                      PhosphorIconsStyle
                                                          .duotone);
                                              break;
                                            case ProductCategory.edible:
                                              _selectedCategoryIcon =
                                                  PhosphorIcons.cookie(
                                                      PhosphorIconsStyle
                                                          .duotone);
                                              break;
                                            case ProductCategory.concentrate:
                                              _selectedCategoryIcon =
                                                  PhosphorIcons.drop(
                                                      PhosphorIconsStyle
                                                          .duotone);
                                              break;
                                            case ProductCategory.cartridge:
                                              _selectedCategoryIcon =
                                                  PhosphorIcons.cloud(
                                                      PhosphorIconsStyle
                                                          .duotone);
                                              break;
                                            case ProductCategory.topical:
                                              _selectedCategoryIcon =
                                                  PhosphorIcons.jarLabel(
                                                      PhosphorIconsStyle
                                                          .duotone);
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
                                        leadingIcon: PhosphorIcon(
                                            PhosphorIcons.plant(
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
                                        leadingIcon: PhosphorIcon(
                                            PhosphorIcons.drop(
                                                PhosphorIconsStyle.duotone)),
                                        label: 'Concentrate',
                                        value: ProductCategory.concentrate,
                                      ),
                                      DropdownMenuEntry(
                                        leadingIcon: PhosphorIcon(
                                            PhosphorIcons.cloud(
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
                                    initialSelection: _productDraft?.type,
                                    expandedInsets: EdgeInsets.zero,
                                    label: const Text('Type'),
                                    leadingIcon: _selectedTypeIcon == null
                                        ? null
                                        : PhosphorIcon(_selectedTypeIcon!),
                                    onSelected: (value) {
                                      setState(() {
                                        if (value != null) {
                                          _productDraft = _productDraft
                                              ?.copyWith(type: value);
                                          print(
                                              'Product: ${_productDraft.toString()}');
                                          switch (value) {
                                            case FlowerType.sativa:
                                              _selectedTypeIcon =
                                                  PhosphorIcons.lightning(
                                                      PhosphorIconsStyle
                                                          .duotone);
                                              break;
                                            case FlowerType.indica:
                                              _selectedTypeIcon =
                                                  PhosphorIcons.waves(
                                                      PhosphorIconsStyle
                                                          .duotone);
                                              break;
                                            case FlowerType.hybrid:
                                              _selectedTypeIcon =
                                                  PhosphorIcons.intersect(
                                                      PhosphorIconsStyle
                                                          .duotone);
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
                                        leadingIcon: PhosphorIcon(
                                            PhosphorIcons.waves(
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
                                controller: _costController,
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
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text('\$'),
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                      minWidth: 20, minHeight: 0),
                                ),
                              ),
                            ),
                            const Gap(size: 16),
                            Expanded(
                              child: DropdownMenu(
                                  initialSelection: _flowerUnit,
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
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _dispensaryController,
                                textCapitalization: TextCapitalization.words,
                                decoration: const InputDecoration(
                                  labelText: 'Dispensary',
                                  hintText: 'Green Thumb, The Green Door, etc',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                            ),
                            const Gap(size: 16),
                            Expanded(
                              child: TextField(
                                controller: _brandController,
                                textCapitalization: TextCapitalization.words,
                                decoration: const InputDecoration(
                                  labelText: 'Brand',
                                  hintText: 'Cookies, Bloom Farms, etc.',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(size: 16),
                        // if (requiredCannabinoids != null)
                        //   for (Cannabinoid cannabinoid in selectedCannabinoids)
                        //     CannabinoidTextFields(
                        //         cannabinoid: cannabinoid,
                        //         selectedCannabinoids: selectedCannabinoids),
                        Row(
                          children: [
                            PhosphorIcon(
                              PhosphorIcons.hexagon(
                                PhosphorIconsStyle.duotone,
                              ),
                              size: 20,
                            ),
                            const Gap(size: 8),
                            Text(
                              'Cannabinoids',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const Gap(size: 8),
                        // Dropdown for Cannabinoids
                        for (Cannabinoid cannabinoid in selectedCannabinoids)
                          CannabinoidTextFields(
                              cannabinoid: cannabinoid,
                              selectedCannabinoids: selectedCannabinoids),
                        const Gap(size: 8),

                        OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              if (selectedCannabinoids.length >=
                                  context
                                      .read<StashBloc>()
                                      .allCannabinoids!
                                      .length) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'You have already added all available cannabinoids'),
                                  ),
                                );
                                return;
                              }
                              selectedCannabinoids.add(context
                                  .read<StashBloc>()
                                  .allCannabinoids!
                                  .where((cannabinoid) =>
                                      selectedCannabinoids
                                          .contains(cannabinoid) ==
                                      false)
                                  .toList()
                                  .first); // Add the next cannabinoid in the list
                            });
                          },
                          icon: PhosphorIcon(
                            PhosphorIcons.hexagon(PhosphorIconsStyle.duotone),
                          ),
                          label: const Text('Add Cannabinoid'),
                        ),
                        const Gap(size: 8),
                        Row(
                          children: [
                            PhosphorIcon(
                              PhosphorIcons.leaf(PhosphorIconsStyle.duotone),
                              size: 20,
                            ),
                            const Gap(size: 8),
                            Text('Terpenes',
                                style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                        const Gap(size: 8),
                        // Terpene entry fields
                        for (Terpene terpene in selectedTerpenes)
                          TerpeneSelectionFields(
                            selectedTerpenes: selectedTerpenes,
                            allTerpenes: allTerpenes,
                            terpene: terpene,
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
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                              backgroundColor: Colors.red),
                          icon: PhosphorIcon(
                            PhosphorIcons.trash(PhosphorIconsStyle.fill),
                            size: 20,
                            color: Colors.white,
                          ),
                          label: const Text('Delete Product',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Delete Product'),
                                  content: const Text(
                                      'Are you sure you want to delete this product?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        context.pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                      style: FilledButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed: () {
                                        // context.read<StashBloc>().add(
                                        //     DeleteProduct(widget.product.id!));
                                        context.pop();
                                      },
                                      child: const Text('Delete',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              // decoration: BoxDecoration(
              //   color: Theme.of(context).colorScheme.surface,
              //   boxShadow: [
              //     BoxShadow(
              //       color: Theme.of(context)
              //           .colorScheme
              //           .onSurface
              //           .withOpacity(0.1),
              //       offset: const Offset(0, -2),
              //       blurRadius: 4,
              //     ),
              //   ],
              // ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: BlocConsumer<StashBloc, StashState>(
                        listener: (context, state) async {
                          if (state is StashError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              getErrorSnackBar(state.message),
                            );
                          }
                          if (state is StashUpdated) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              getSuccessSnackBar(
                                  'Product updated successfully'),
                            );

                            context
                                .read<ProductDetailsBloc>()
                                .add(FetchProductDetails(widget.product));
                            await Future.delayed(
                                const Duration(milliseconds: 400));
                            context.pop();
                          }
                        },
                        builder: (context, state) {
                          if (state is StashLoading) {
                            return FilledButton.tonal(
                              onPressed: () {},
                              child: const CircularProgressIndicator.adaptive(),
                            );
                          }
                          return FilledButton.tonalIcon(
                            onPressed: () async {
                              Product product = _productDraft!.copyWith(
                                name: _nameController.value.text,
                                // description: de,
                                category: _productDraft?.category,
                                type: _productDraft?.type,
                                price: double.tryParse(_costController.text),
                                unit: _flowerUnit,
                                dispensary: _dispensaryController.text,
                                brand: _brandController.text,
                                cannabinoids: [...selectedCannabinoids],
                                terpenes: selectedTerpenes,
                              );
                              context.read<StashBloc>().add(UpdateProduct(
                                  product,
                                  _imageFile != null ? [_imageFile!] : []));
                              // GoRouter.of(context).go('/stash');
                            },
                            icon: PhosphorIcon(
                              PhosphorIcons.pencil(PhosphorIconsStyle.fill),
                            ),
                            label: const Text('Update Product'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
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

class TerpeneSelectionFields extends StatefulWidget {
  final List<Terpene> selectedTerpenes;
  final List<Terpene> allTerpenes;
  final Terpene terpene;
  const TerpeneSelectionFields(
      {required this.selectedTerpenes,
      required this.allTerpenes,
      required this.terpene,
      super.key});

  @override
  State<TerpeneSelectionFields> createState() => _TerpeneSelectionFieldsState();
}

class _TerpeneSelectionFieldsState extends State<TerpeneSelectionFields> {
  double terpeneValue = 0.0;
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    _valueController.text = widget.terpene.amount.toString();
    _nameController.text = widget.terpene.name!;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0, top: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: DropdownMenu(
              controller: _nameController,
              initialSelection: widget.terpene,
              menuStyle: MenuStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              inputDecorationTheme:
                  Theme.of(context).inputDecorationTheme.copyWith(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
              onSelected: (value) {
                setState(() {
                  if (value != null) {
                    widget.selectedTerpenes.remove(widget.terpene);
                    widget.selectedTerpenes.add(value);
                  }
                });
              },
              // onSelected: (terpene) {
              //   // Add terpene to list if not already present
              //   // if (selectedTerpenes.any(
              //   //     (selectedTerpene) =>
              //   //         selectedTerpene['name'] == terpene)) {
              //   //   return;
              //   // }
              // },
              leadingIcon:
                  PhosphorIcon(getIconForTerpene(widget.terpene), size: 20),
              label: const Text('Terpene'),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries: widget.allTerpenes
                  .map((t) => DropdownMenuEntry(
                        label: t.name!,
                        value: t,
                        leadingIcon: PhosphorIcon(getIconForTerpene(t)),
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
            flex: 2,
            child: TextField(
              textAlign: TextAlign.end,
              controller: _valueController,
              onChanged: (value) {
                setState(() {
                  terpeneValue = double.tryParse(value) ?? 0.0;
                  widget.selectedTerpenes.removeWhere(
                      (element) => element.name == widget.terpene.name);
                  widget.selectedTerpenes.add(widget.terpene.copyWith(
                    // Update terpene value
                    amount: terpeneValue,
                  ));
                  print(
                      'Selected Terpenes: ${widget.selectedTerpenes.toString()}');
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
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton.outlined(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.center,
                  onPressed: () {
                    setState(() {
                      widget.selectedTerpenes.remove(widget.terpene);
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
    Cannabinoid cannabinoid = widget.cannabinoid;
    List<Cannabinoid> selectedCannabinoids = widget.selectedCannabinoids;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: DropdownMenu<Cannabinoid>(
                controller: _nameController,
                initialSelection: cannabinoid,
                menuStyle: MenuStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                inputDecorationTheme:
                    Theme.of(context).inputDecorationTheme.copyWith(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                onSelected: (cannabinoid) {
                  // Add cannabinoid to list if not already present
                  if (selectedCannabinoids.contains(cannabinoid)) {
                    return;
                  }
                  setState(() {
                    selectedCannabinoids
                        .add(cannabinoid!.copyWith(amount: 0.0));
                  });
                },
                label: const Text('Cannabinoid'),
                expandedInsets: EdgeInsets.zero,
                dropdownMenuEntries:
                    context.read<StashBloc>().allCannabinoids!.map((c) {
                  print('Cannabinoid: $c');
                  return DropdownMenuEntry(
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
                  );
                }).toList()),
          ),
          const Gap(size: 16),
          Expanded(
            flex: 3,
            child: TextField(
              controller: _valueController,
              onChanged: (value) {
                setState(() {
                  selectedCannabinoids.removeWhere(
                      (element) => element.name == cannabinoid.name);
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
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          if (cannabinoid.name != 'THC' && cannabinoid.name != 'CBD')
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    alignment: Alignment.center,
                    onPressed: () {
                      setState(() {
                        selectedCannabinoids.remove(cannabinoid);
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
