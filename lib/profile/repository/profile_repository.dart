import 'package:canjo/app/snackbars.dart';
import 'package:canjo/consts.dart';
import 'package:canjo/profile/model/user.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class ProfileRepository {
  final sb.SupabaseClient _supabaseClient = sb.Supabase.instance.client;

  Future<User?> getUser(String userId) async {
    try {
      final response =
          await _supabaseClient.from('users').select().eq('id', userId);
      return User.fromJson(response.first);
    } catch (e, stackTrace) {
      scaffoldKey.currentState?.showSnackBar(
        getErrorSnackBar('Failed to fetch user data. Please try again.'),
      );
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<User?> createUser(User user) async {
    try {
      final response =
          await _supabaseClient.from('users').upsert(user.toJson()).select();
      return User.fromJson(response.first);
    } catch (e, stackTrace) {
      scaffoldKey.currentState?.showSnackBar(
        getErrorSnackBar('Failed to create user. Please try again.'),
      );
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _supabaseClient.from('users').upsert(user.toJson());
    } catch (e, stackTrace) {
      scaffoldKey.currentState?.showSnackBar(
        getErrorSnackBar('Failed to update user. Please try again.'),
      );
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> deleteUser() async {
    try {
      await _supabaseClient.from('users').delete();
    } catch (e, stackTrace) {
      scaffoldKey.currentState?.showSnackBar(
        getErrorSnackBar('Failed to delete user. Please try again.'),
      );
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
    }
  }
}
