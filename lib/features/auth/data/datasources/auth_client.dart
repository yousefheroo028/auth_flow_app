import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthClient {
  Future<AuthResponse> signUp({required String email, required String password, String name});
  Future<AuthResponse> signIn({required String email, required String password});
  Future<void> requestPasswordReset({required String email});
  Future<AuthResponse> verifyPasswordResetRequestUsingOTP({required String email, required String otp});
  Future<void> sendMagicLink({required String email, String? emailRedirectTo});
  Future<UserResponse> updatePassword({required String password});
  Future<AuthResponse> signInWithIdToken(OAuthProvider provider, String idToken);
  Future<bool> signInWithOAuth(OAuthProvider provider, String callbackUrl);
  Future<void> signInWithPhoneNumber({required String phoneNumber});
  Future<AuthResponse> verifyAuthWithPhoneNumber({required String phoneNumber, required String otp});
  User? get getCurrentUser;
  Future<void> signOut();
  Stream<AuthState> get getAuthChange;
  Future<UserResponse> updateProfile(String? displayName, String? photoUrl);
  Future<void> deleteAccount();
}
