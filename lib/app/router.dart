import 'package:budsy/stash/model/product.dart';
import 'package:budsy/stash/new_entry.dart';
import 'package:budsy/stash/qr_scan_screen.dart';
import 'package:budsy/journal/view/add_feeling_page.dart';
import 'package:budsy/journal/view/add_session_page.dart';
import 'package:budsy/journal/view/journal_page.dart';
import 'package:budsy/stash/stash_page.dart';
import 'package:budsy/stash/view_product.dart';
import 'package:budsy/trends/trends_page.dart';
import 'package:go_router/go_router.dart';

GoRouter goRouter = GoRouter(
  routes: [
    // Define a route that handles '/'
    GoRoute(
      path: '/',
      builder: (context, state) => const JournalPage(),
      routes: [
        GoRoute(
          path: 'add',
          builder: (context, state) => const AddFeelingPage(),
        ),
        GoRoute(
          path: 'add-session',
          builder: (context, state) => const AddSessionPage(),
        )
      ],
    ),
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
              })
        ]),
    GoRoute(
      path: '/trends',
      builder: (context, state) => const TrendsPage(),
    )
  ],
);
