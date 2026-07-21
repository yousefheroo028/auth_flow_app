import 'package:auth_flow_app/core/error/exceptions.dart' as app;
import 'package:auth_flow_app/features/auth/data/datasources/auth_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthClientSupabase implements AuthClient {
  final GoTrueClient _client;

  AuthClientSupabase(this._client);

  @override
  Future<AuthResponse> signIn({required String email, required String password}) async {
    return _client.signInWithPassword(email: email, password: password);
  }

  @override
  Future<AuthResponse> signUp({required String email, required String password, String? name}) async {
    return _client.signUp(email: email, password: password, data: {'name': name ?? ''});
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    return _client.resetPasswordForEmail(email);
  }

  @override
  Future<AuthResponse> verifyPasswordResetRequestUsingOTP({required String email, required String otp}) async {
    return _client.verifyOTP(type: OtpType.recovery, email: email, token: otp);
  }

  @override
  Future<UserResponse> updatePassword({required String password}) async {
    return _client.updateUser(UserAttributes(password: password));
  }

  @override
  Future<AuthResponse> signInWithIdToken(OAuthProvider provider, String idToken) async {
    return _client.signInWithIdToken(provider: provider, idToken: idToken);
  }

  @override
  Future<bool> signInWithOAuth(OAuthProvider provider, String callbackUrl) async {
    return _client.signInWithOAuth(provider, redirectTo: callbackUrl);
  }

  @override
  Future<void> signInWithPhoneNumber({required String phoneNumber}) async {
    return _client.signInWithOtp(phone: phoneNumber);
  }

  @override
  Future<AuthResponse> verifyAuthWithPhoneNumber({required String phoneNumber, required String otp}) async {
    return _client.verifyOTP(type: .sms, token: otp, phone: phoneNumber);
  }

  @override
  User? get getCurrentUser => _client.currentUser;

  @override
  Future<void> signOut() async {
    return _client.signOut();
  }

  @override
  Stream<AuthState> get getAuthChange => _client.onAuthStateChange;

  @override
  Future<UserResponse> updateProfile(String? displayName, String? photoUrl) async {
    final storage = Supabase.instance.client.storage.from('avatars');
    final userId = Supabase.instance.client.auth.currentUser!.id;
    await storage.remove(
      (await storage.list(
            path: userId,
          ))
          .map((FileObject e) => '$userId/${e.name}')
          .where((String element) => !storage.getPublicUrl(element).contains(photoUrl!))
          .toList(),
    );

    return _client.updateUser(
      UserAttributes(
        data: {
          if (displayName != null) 'full_name': displayName,
          if (displayName != null) 'name': displayName,
          if (photoUrl != null) 'picture': photoUrl,
          if (photoUrl != null) 'avatar_url': photoUrl,
        },
      ),
    );
  }

  @override
  Future<void> deleteAccount() async {
    final userId = _client.currentUser?.id;
    if (userId == null) throw app.AuthException('User is not signed in.');

    final response = await Supabase.instance.client.functions.invoke('delete-account', body: {'userId': userId});
    await _client.signOut(scope: .global);

    if (response.status != 200) {
      throw app.ServerException('Failed to delete account (status ${response.status}).');
    }
  }

  @override
  Future<void> sendMagicLink({required String email, String? emailRedirectTo}) {
    return _client.signInWithOtp(
      email: email,
      emailRedirectTo: emailRedirectTo ?? dotenv.get('REDIRECTION_DEEPLINK'),
    );
  }
}
