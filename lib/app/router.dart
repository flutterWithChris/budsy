import 'package:canjo/auth/bloc/auth_bloc.dart';
import 'package:canjo/consts.dart';
import 'package:canjo/journal/model/journal_entry.dart';
import 'package:canjo/journal/view/edit_entry_page.dart';
import 'package:canjo/login/view/login_page.dart';
import 'package:canjo/onboarding/onboarding_page.dart';
import 'package:canjo/settings/settings_page.dart';
import 'package:canjo/stash/model/product.dart';
import 'package:canjo/stash/view/edit_product.dart';
import 'package:canjo/stash/view/new_entry.dart';
import 'package:canjo/stash/qr_scan_screen.dart';
import 'package:canjo/journal/view/add_feeling_page.dart';
import 'package:canjo/journal/view/add_entry_page.dart';
import 'package:canjo/journal/view/journal_page.dart';
import 'package:canjo/stash/view/stash_page.dart';
import 'package:canjo/stash/view/view_product.dart';
import 'package:canjo/trends/trends_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

GoRouter goRouter = GoRouter(
  redirect: (context, state) async {
    bool isAuthenticated =
        context.read<AuthBloc>().state.status == AuthStatus.authenticated;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!isAuthenticated) {
      return '/login';
    }
    print(state.uri.toString());
    print(isAuthenticated);
    if (isAuthenticated && state.uri.toString() == '/login') {
      return '/';
    }

    return null;
  },
  routes: [
    // Define a route that handles '/'
    GoRoute(
      path: '/',
      builder: (context, state) => const JournalPage(),
      routes: [
        GoRoute(
          path: 'add-entry',
          builder: (context, state) => const AddEntryPage(),
        ),
        GoRoute(
          path: 'edit-entry/:id',
          builder: (context, state) {
            return EditEntryPage(
              journalEntry: state.extra as JournalEntry,
            );
          },
        ),
      ],
    ),
    GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    // Define a route that handles '/second'
    GoRoute(
      path: '/new-entry',
      builder: (context, state) => const NewEntryScreen(),
      routes: [
        GoRoute(
          path: 'qr-scan',
          builder: (context, state) => const QrScanScreen(),
        )
      ],
    ),
    GoRoute(
        path: '/stash',
        builder: (context, state) => const StashPage(),
        routes: [
          GoRoute(
              path: 'product/:id',
              builder: (context, state) {
                return ViewProductPage(
                  product: state.extra as Product,
                );
              },
              routes: [
                GoRoute(
                    path: 'edit',
                    builder: (context, state) {
                      return EditProductPage(
                        product: state.extra as Product,
                      );
                    })
              ]),
        ]),
    GoRoute(
      path: '/trends',
      builder: (context, state) => const TrendsPage(),
    ),
    GoRoute(
        path: '/settings', builder: (context, state) => const SettingsPage()),
  ],
);
