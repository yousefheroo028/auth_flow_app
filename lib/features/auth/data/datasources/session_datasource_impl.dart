import 'package:auth_flow_app/core/error/exceptions.dart';
import 'package:auth_flow_app/features/auth/data/datasources/auth_client.dart';
import 'package:auth_flow_app/features/auth/data/datasources/session_datasource.dart';
import 'package:auth_flow_app/features/auth/data/models/user_model.dart';

class SessionDataSourceImpl implements SessionDataSource {
  final AuthClient _authClient;

  SessionDataSourceImpl(this._authClient);

  @override
  UserModel? getCurrentUser() {
    try {
      final currentUser = _authClient.getCurrentUser;
      if (currentUser == null) throw AuthException('User is not signed.');
      return UserModel.fromSupabase(currentUser);
    } catch (e) {
      throw ServerException('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      _authClient.signOut();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to sign out: ${e.toString()}');
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _authClient.getAuthChange.map((event) {
      if (event.session == null) return null;
      return UserModel.fromSupabase(event.session!.user);
    });
  }
}
