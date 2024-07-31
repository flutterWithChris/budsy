import 'package:canjo/app/system/bottom_nav.dart';
import 'package:canjo/consts.dart';
import 'package:canjo/login/cubit/login_cubit.dart';
import 'package:canjo/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
              ListTile(
                  leading: PhosphorIcon(PhosphorIcons.lightbulb()),
                  title: const Text('Brightness'),
                  trailing: BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (context, state) {
                      return DropdownButton<ThemeMode>(
                        value: state.themeMode ?? ThemeMode.system,
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
                          context.read<ThemeCubit>().setThemeMode(value!);
                        },
                      );
                    },
                  )),
              // ListTile(
              //   leading: const Icon(Icons.bug_report),
              //   title: const Text('Have an issue?'),
              //   onTap: () {
              //     // Report issue
              //   },
              // ),
              ListTile(
                leading: PhosphorIcon(PhosphorIcons.signOut()),
                title: const Text('Logout'),
                onTap: () async {
                  // Logout
                  await context.read<LoginCubit>().signOut();
                },
              ),

              // Privacy Policy
              ListTile(
                leading: PhosphorIcon(PhosphorIcons.lockSimple()),
                title: const Text('Privacy Policy'),
                onTap: () async {
                  await launchUrlString(privacyPolicyUrl,
                      mode: LaunchMode.externalApplication);
                },
              ),
              // Terms of Use
              ListTile(
                leading: PhosphorIcon(PhosphorIcons.bookOpen()),
                title: const Text('Terms of Use'),
                onTap: () async {
                  await launchUrlString(termsOfUse,
                      mode: LaunchMode.externalApplication);
                },
              ),
              // Contact Us
              ListTile(
                leading: PhosphorIcon(PhosphorIcons.mailbox()),
                title: const Text('Contact Us'),
                onTap: () async {
                  Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: supportEmail,
                      query: encodeQueryParameters({
                        'subject': 'Canjo Feedback',
                        'body': '',
                      }));
                  await launchUrlString(emailLaunchUri.toString(),
                      mode: LaunchMode.externalApplication);
                },
              ),
              // TODO: Implement account deletion
              ListTile(
                leading: PhosphorIcon(PhosphorIcons.trashSimple()),
                title: const Text('Delete Account'),
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Delete Account'),
                        content: const Text(
                            'Are you sure you want to delete your account? This action cannot be undone.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () async {
                              // Delete account
                              await context.read<LoginCubit>().deleteAccount();
                              if (context.mounted) {
                                context.pop();
                              }
                            },
                            child: const Text('Delete',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
