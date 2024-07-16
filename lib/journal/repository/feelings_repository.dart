import 'package:budsy/journal/model/feeling.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeelingsRepository {
  final SupabaseClient client = Supabase.instance.client;

  Future<List<Feeling>> getFeelings() async {
    final response = await client.from('feelings').select();
    List<Feeling> feelings = [];
    response.map((feeling) => feelings.add(Feeling.fromJson(feeling)));
    return feelings;
  }
}
