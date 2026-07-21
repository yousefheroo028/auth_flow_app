import 'package:dart_either/dart_either.dart';
import 'package:auth_flow_app/core/error/exceptions.dart';
import 'package:auth_flow_app/core/error/failures.dart';
import 'package:auth_flow_app/features/auth/data/datasources/profile_datasource.dart';
import 'package:auth_flow_app/features/auth/domain/entities/user_entity.dart';
import 'package:auth_flow_app/features/auth/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource _profileDataSource;

  ProfileRepositoryImpl({
    required this._profileDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final user = await _profileDataSource.updateProfile(
        displayName: displayName,
        photoUrl: photoUrl,
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture({required String filePath}) async {
    try {
      final url = await _profileDataSource.uploadProfilePicture(filePath: filePath);
      return Right(url);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await _profileDataSource.deleteAccount();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
