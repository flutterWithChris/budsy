import 'package:canjo/app/snackbars.dart';
import 'package:canjo/consts.dart';
import 'package:canjo/journal/model/feeling.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeelingsRepository {
  final SupabaseClient client = Supabase.instance.client;

  Future<List<Feeling>> getFeelings() async {
    try {
      final response = await client.from('feelings').select();
      print(response);
      List<Feeling> feelings =
          response.map((e) => Feeling.fromJson(e)).toList();
      return feelings;
    } catch (e, stackTrace) {
      scaffoldKey.currentState?.showSnackBar(
        getErrorSnackBar('Failed to fetch feelings. Please try again.'),
      );
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }
}
