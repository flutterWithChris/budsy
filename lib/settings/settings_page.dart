import 'package:budsy/app/system/bottom_nav.dart';
import 'package:budsy/auth/bloc/auth_bloc.dart';
import 'package:budsy/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.medium(
            title: Text('Settings'),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Text('Account',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
              // TODO: Make brightness change work
              ListTile(
                  leading: PhosphorIcon(PhosphorIcons.lightbulb()),
                  title: const Text('Brightness'),
                  trailing: DropdownButton<ThemeMode>(
                    value: ThemeMode.system,
                    items: const [
                      DropdownMenuItem(
                          value: ThemeMode.system, child: Text('System')),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('Light'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('Dark'),
                      ),
                    ],
                    onChanged: (value) {
                      // Change theme brightness
                    },
                  )),
              // TODO: Implement issue reporting
              ListTile(
                leading: const Icon(Icons.bug_report),
                title: const Text('Have an issue?'),
                onTap: () {
                  // Report issue
                },
              ),
              // TODO: Implement logout
              ListTile(
                leading: PhosphorIcon(PhosphorIcons.signOut()),
                title: const Text('Logout'),
                onTap: () async {
                  // Logout
                  await context.read<LoginCubit>().signOut();
                },
              ),
              // TODO: Implement account deletion
              ListTile(
                leading: PhosphorIcon(PhosphorIcons.trashSimple()),
                title: const Text('Delete Account'),
                onTap: () {
                  // Delete account
                },
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
