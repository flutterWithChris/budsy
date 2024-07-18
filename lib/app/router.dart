import 'package:budsy/auth/bloc/auth_bloc.dart';
import 'package:budsy/journal/model/journal_entry.dart';
import 'package:budsy/journal/view/edit_entry_page.dart';
import 'package:budsy/login/view/login_page.dart';
import 'package:budsy/stash/model/product.dart';
import 'package:budsy/stash/view/edit_product.dart';
import 'package:budsy/stash/view/new_entry.dart';
import 'package:budsy/stash/qr_scan_screen.dart';
import 'package:budsy/journal/view/add_feeling_page.dart';
import 'package:budsy/journal/view/add_entry_page.dart';
import 'package:budsy/journal/view/journal_page.dart';
import 'package:budsy/stash/view/stash_page.dart';
import 'package:budsy/stash/view/view_product.dart';
import 'package:budsy/trends/trends_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

GoRouter goRouter = GoRouter(
  redirect: (context, state) {
    bool isAuthenticated =
        context.read<AuthBloc>().state.status == AuthStatus.authenticated;

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
    )
  ],
);
