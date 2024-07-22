import 'package:budsy/profile/model/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class ProfileRepository {
  final sb.SupabaseClient _supabaseClient = sb.Supabase.instance.client;

  Future<User> getUser(String userId) async {
    try {
      final response =
          await _supabaseClient.from('users').select().eq('id', userId);
      print('Load User Response: $response');
      return User.fromJson(response.first);
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }

  Future<User?> createUser(User user) async {
    try {
      final response =
          await _supabaseClient.from('users').upsert(user.toJson()).select();
      print('***User created***');
      print('Create User Response: $response');
      return User.fromJson(response.first);
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _supabaseClient.from('users').upsert(user.toJson());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> deleteUser() async {
    try {
      await _supabaseClient.from('users').delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
