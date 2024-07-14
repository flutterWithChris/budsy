import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class AuthRepository {
  final supabase.SupabaseClient _supabase = supabase.Supabase.instance.client;

  Future<supabase.AuthResponse> signInWithGoogle() async {
    try {
      /// Web Client ID that you registered with Google Cloud.
      String? webClientId = dotenv.env['GOOGLE_WEB_OAUTH_CLIENT_ID'];

      String? androidClientId = dotenv.env['GOOGLE_ANDROID_OAUTH_CLIENT_ID'];

      ///
      /// iOS Client ID that you registered with Google Cloud.
      String? iosClientId = dotenv.env['GOOGLE_IOS_OAUTH_CLIENT_ID'];

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: Platform.isAndroid ? null : iosClientId,
        serverClientId: webClientId,
      );
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      return await _supabase.auth.signInWithIdToken(
        provider: supabase.OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Stream<supabase.AuthState> get authStateChanges =>
      _supabase.auth.onAuthStateChange;

  Future<supabase.AuthResponse> signInWithApple() async {
    try {
      final rawNonce = _supabase.auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        throw const supabase.AuthException(
            'Could not find ID Token from generated credential.');
      }

      return _supabase.auth.signInWithIdToken(
        provider: supabase.OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
