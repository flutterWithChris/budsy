import 'package:budsy/entries/new_entry.dart';
import 'package:budsy/entries/qr_scan_screen.dart';
import 'package:budsy/journal/view/add_journal_page.dart';
import 'package:budsy/journal/view/add_session_page.dart';
import 'package:budsy/journal/view/journal_page.dart';
import 'package:budsy/stash/stash_page.dart';
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
          builder: (context, state) => const AddJournalEntryPage(),
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
    ),
    GoRoute(
      path: '/trends',
      builder: (context, state) => const TrendsPage(),
    )
  ],
);
