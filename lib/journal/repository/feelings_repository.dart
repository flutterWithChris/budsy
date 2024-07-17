import 'package:budsy/journal/model/feeling.dart';
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
    } catch (e) {
      print(e);
      return [];
    }
  }
}
