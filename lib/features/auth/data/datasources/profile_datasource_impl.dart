import 'package:auth_flow_app/core/error/exceptions.dart';
import 'package:auth_flow_app/features/auth/data/datasources/auth_client.dart';
import 'package:auth_flow_app/features/auth/data/datasources/profile_datasource.dart';
import 'package:auth_flow_app/features/auth/data/datasources/storage_client.dart';
import 'package:auth_flow_app/features/auth/data/models/user_model.dart';

class ProfileDataSourceImpl implements ProfileDataSource {
  final AuthClient _authClient;
  final StorageClient _storageClient;

  ProfileDataSourceImpl(this._authClient, this._storageClient);

  @override
  Future<UserModel> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final user = await _authClient.updateProfile(displayName, photoUrl);
      if (user.user == null) throw AuthException('The user is not found.');
      return UserModel.fromSupabase(user.user!);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to update profile: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadProfilePicture({required String filePath}) async {
    try {
      final newUrl = await _storageClient.uploadProfilePicture(filePath: filePath);
      return newUrl;
    } catch (e) {
      throw ServerException(
        'Failed to upload profile picture: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _authClient.deleteAccount();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to delete account: ${e.toString()}');
    }
  }
}
