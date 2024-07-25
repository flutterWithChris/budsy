import 'package:canjo/login/cubit/login_cubit.dart';
import 'package:canjo/subscription/bloc/subscription_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    super.key,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  static int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
        switch (index) {
          case 0:
            context.go('/stash');
            break;
          case 1:
            context.go('/');
            break;
          case 2:
            if (context.read<SubscriptionBloc>().state is SubscriptionInitial)
            {
              context.read<SubscriptionBloc>().add(SubscriptionInit(context.read<LoginCubit>().state.user?.id));
            }
            context.go('/trends');
          case 3:
            context.go('/settings');
            break;
        }
      },
      destinations: [
        NavigationDestination(
          icon: PhosphorIcon(PhosphorIcons.flower()),
          label: 'Stash',
        ),
        NavigationDestination(
          icon: PhosphorIcon(PhosphorIcons.calendar()),
          label: 'Journal',
        ),
        NavigationDestination(
          icon: PhosphorIcon(PhosphorIcons.chartDonut()),
          label: 'Trends',
        ),
        NavigationDestination(
          icon: PhosphorIcon(PhosphorIcons.gear()),
          label: 'Settings',
        ),
      ],
    );
  }
}
