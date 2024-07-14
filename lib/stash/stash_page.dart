import 'package:budsy/app/colors.dart';
import 'package:budsy/app/icons.dart';
import 'package:budsy/app/system/bottom_nav.dart';
import 'package:budsy/stash/bloc/product_details_bloc.dart';
import 'package:budsy/stash/bloc/stash_bloc.dart';
import 'package:budsy/stash/model/product.dart';
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
              return const Center(
                child: Text('No products found'),
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
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: Row(
                        children: [
                          PhosphorIcon(
                              PhosphorIcons.leaf(PhosphorIconsStyle.fill),
                              size: 18),
                          const SizedBox(width: 8.0),
                          Text(
                            'Current',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(),
                          ),
                        ],
                      ),
                    ),
                  ),
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
          final product = archived == true
              ? stash
                  .where((product) => product.archived == true)
                  .toList()[index]
              : stash
                  .where((product) => product.archived != true)
                  .toList()[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
            child: Card(
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
                        backgroundColor:
                            getColorForProductCategory(product.category!)),
                    icon: PhosphorIcon(getIconForCategory(product.category!)),
                  ),
                  title: Text(
                    product.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(product.type!.name.capitalize),
                  trailing: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IgnorePointer(
                        child: RatingBar(
                          initialRating: product.rating?.toDouble() ?? 0.0,
                          size: 14,
                          filledIcon:
                              PhosphorIcons.star(PhosphorIconsStyle.fill),
                          emptyIcon: PhosphorIcons.star(),
                          onRatingChanged: (rating) {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
