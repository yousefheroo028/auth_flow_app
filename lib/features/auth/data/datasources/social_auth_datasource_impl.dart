import 'package:auth_flow_app/core/error/exceptions.dart';
import 'package:auth_flow_app/features/auth/data/models/user_model.dart';
import 'package:auth_flow_app/features/auth/data/datasources/social_auth_datasource.dart';
import 'package:auth_flow_app/features/auth/data/datasources/auth_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialAuthDataSourceImpl implements SocialAuthDataSource {
  final AuthClient _authClient;
  final GoogleSignIn _googleSignIn = .instance;
  bool isGoogleInitialized = false;

  SocialAuthDataSourceImpl(this._authClient);
  Future<void> initializeGoogleSignIn() async {
    if (isGoogleInitialized) return;
    await _googleSignIn.initialize(serverClientId: dotenv.get('GOOGLE_CLIENT_ID'));
    isGoogleInitialized = true;
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      await initializeGoogleSignIn();
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final token = googleUser.authentication.idToken;
      if (token == null) throw ServerException('Google Authentication failed.');
      final response = await _authClient.signInWithIdToken(.google, token);
      if (response.user == null) throw AuthException('Signing in with Google failed.');
      return UserModel.fromSupabase(response.user!);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to sign in with Google: ${e.toString()}');
    }
  }

  @override
  Future<void> signInWithGitHub() async {
    try {
      final isAuthenticated = await _authClient.signInWithOAuth(.github, dotenv.get('CALL_BACK_FROM_SUPABASE'));
      if (!isAuthenticated) throw ServerException('Authentication Failed.');
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to sign in with GitHub: ${e.toString()}');
    }
  }
}
