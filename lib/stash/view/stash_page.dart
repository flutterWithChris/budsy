import 'package:canjo/app/colors.dart';
import 'package:canjo/app/icons.dart';
import 'package:canjo/app/system/bottom_nav.dart';
import 'package:canjo/stash/bloc/product_details_bloc.dart';
import 'package:canjo/stash/bloc/stash_bloc.dart';
import 'package:canjo/stash/mock/mock_products.dart';
import 'package:canjo/stash/model/product.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class StashPage extends StatelessWidget {
  const StashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/new-entry');
        },
        child: const Icon(Icons.add),
      ),
      // appBar: AppBar(
      //   title: const Text('Journal'),
      // ),
      bottomNavigationBar: const BottomNavBar(),
      body: BlocBuilder<StashBloc, StashState>(
        builder: (context, state) {
          if (state is StashLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is StashError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          }
          if (state is StashLoaded) {
            if (state.products.isEmpty) {
              return CustomScrollView(
                slivers: [
                  const SliverAppBar.medium(
                    title: Text(
                      'Stash',
                    ),
                  ),
                  SliverFillRemaining(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              for (Product product in mockProducts.take(5))
                                Opacity(
                                    opacity: 0.8,
                                    child: ProductCard(product: product)),
                            ],
                          ),
                        ),
                        Positioned.fill(
                            child: Container(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.black.withOpacity(0.5)
                                    : Colors.white54)),
                        Positioned(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.black
                                      : Colors.white,
                                  blurRadius: 48,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(80.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  PhosphorIcon(
                                    PhosphorIcons.warningCircle(
                                        PhosphorIconsStyle.fill),
                                    size: 48,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 16.0),
                                    child: Center(
                                      child: Text('No products found'),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await context.push('/new-entry');
                                    },
                                    child: const Text('Add a product'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return CustomScrollView(
                slivers: [
                  SliverAppBar.medium(
                    title: Text(
                      'Stash',
                      style: GoogleFonts.roboto().copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                    floating: true,
                    snap: true,
                    actions: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search),
                      ),
                    ],
                  ),
                  // SliverToBoxAdapter(
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 16.0, vertical: 16.0),
                  //     child: Row(
                  //       children: [
                  //         PhosphorIcon(
                  //             PhosphorIcons.leaf(PhosphorIconsStyle.fill),
                  //             size: 18),
                  //         const SizedBox(width: 8.0),
                  //         Text(
                  //           'Current',
                  //           style: Theme.of(context)
                  //               .textTheme
                  //               .titleMedium
                  //               ?.copyWith(),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    sliver: StashList(stash: state.products),
                  ),
                  if ([].any((product) => product.archived == true))
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16.0),
                        child: Row(
                          children: [
                            PhosphorIcon(
                                PhosphorIcons.archive(PhosphorIconsStyle.fill),
                                size: 18),
                            const SizedBox(width: 8.0),
                            Text(
                              'Archived',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (state.products.any((product) => product.archived == true))
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0),
                      sliver: StashList(
                          stash: state.products
                              .where(
                                (product) => product.archived == true,
                              )
                              .toList(),
                          archived: true),
                    ),
                ],
              );
            }
          } else {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
        },
      ),
    );
  }
}

class StashList extends StatelessWidget {
  final bool? archived;
  final List<Product> stash;
  const StashList({
    this.archived,
    required this.stash,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          List<Product> stashDateSorted = archived == true
              ? stash.where((product) => product.archived == true).toList()
              : stash.where((product) => product.archived != true).toList();
          stashDateSorted.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
          final product = stashDateSorted[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            child: ProductCard(product: product),
          );
        },
        childCount: archived == true
            ? stash.where((product) => product.archived == true).toList().length
            : stash
                .where((product) => product.archived != true)
                .toList()
                .length,
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          context.read<ProductDetailsBloc>().add(
                FetchProductDetails(product),
              );
          context.push('/stash/product/${product.id}', extra: product);
        },
        child: ListTile(
          leading: IconButton.filledTonal(
            onPressed: () {},
            style: IconButton.styleFrom(
                backgroundColor: getColorForProductCategory(product.category!)),
            icon: PhosphorIcon(
              getIconForCategory(product.category!),
              color: getContrastingColor(
                  getColorForProductCategory(product.category!)),
            ),
          ),
          title: Text(
            product.name!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: product.dispensary != null || product.type != null
              ? Text(product.dispensary ?? product.type!.name.capitalize)
              : null,
          trailing: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IgnorePointer(
                child: RatingBar(
                  initialRating: product.rating?.toDouble() ?? 0.0,
                  size: 14,
                  filledIcon: PhosphorIcons.star(PhosphorIconsStyle.fill),
                  emptyIcon: PhosphorIcons.star(),
                  onRatingChanged: (rating) {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
