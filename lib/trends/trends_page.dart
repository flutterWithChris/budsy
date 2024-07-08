import 'package:budsy/app/colors.dart';
import 'package:budsy/app/icons.dart';
import 'package:budsy/app/system/bottom_nav.dart';
import 'package:budsy/consts.dart';
import 'package:budsy/entries/model/terpene.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class TrendsPage extends StatefulWidget {
  const TrendsPage({super.key});

  @override
  State<TrendsPage> createState() => _TrendsPageState();
}

class _TrendsPageState extends State<TrendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Trends'),
            floating: true,
            snap: true,
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  const Text('Favorite Terpenes'),
                  const Gap(size: 16),
                  Row(
                    children: [
                      for (Terpene terpene in terpenes)
                        Expanded(child: TerpeneAvatar(terpene))
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TerpeneAvatar extends StatelessWidget {
  final Terpene terpene;
  const TerpeneAvatar(
    this.terpene, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: getColorForTerpene(terpene),
          child: PhosphorIcon(
            getFilledIconForTerpene(terpene),
            size: 40,
          ),
        ),
        const Gap(size: 8),
        Text(
          terpene.name!,
          style: Theme.of(context).textTheme.titleSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
