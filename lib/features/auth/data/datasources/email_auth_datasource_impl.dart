import 'package:auth_flow_app/core/error/exceptions.dart';
import 'package:auth_flow_app/features/auth/data/datasources/auth_client.dart';
import 'package:auth_flow_app/features/auth/data/datasources/email_auth_datasource.dart';
import 'package:auth_flow_app/features/auth/data/models/user_model.dart';

class EmailAuthDataSourceImpl implements EmailAuthDataSource {
  final AuthClient _authClient;

  EmailAuthDataSourceImpl(this._authClient);

  @override
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _authClient.signUp(email: email, password: password, name: name);
      if (response.user == null) {
        throw AuthException('Signing Up Failed.');
      }

      return UserModel.fromSupabase(response.user!);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to sign up: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authClient.signIn(email: email, password: password);

      if (response.user == null) {
        throw AuthException('Invalid Credintials');
      }

      return UserModel.fromSupabase(response.user!);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to sign in: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _authClient.requestPasswordReset(email: email);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to reset password: ${e.toString()}');
    }
  }

  @override
  Future<void> verifyEmail({required String email, required String token}) async {
    try {
      final response = await _authClient.verifyPasswordResetRequestUsingOTP(email: email, otp: token);
      if (response.user == null) {
        throw AuthException('Invalid OTP or the code expired.');
      }
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to verify email: ${e.toString()}');
    }
  }

  @override
  Future<void> updatePassword({required String password}) async {
    try {
      await _authClient.updatePassword(password: password);
    } catch (e) {
      throw ServerException('Failed to update password: ${e.toString()}');
    }
  }

  @override
  Future<void> sendMagicLink({required String email, String? emailRedirectTo}) async {
    try {
      await _authClient.sendMagicLink(email: email, emailRedirectTo: emailRedirectTo);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to send magic link: ${e.toString()}');
    }
  }
}
