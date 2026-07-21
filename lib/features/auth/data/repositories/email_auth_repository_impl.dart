import 'package:dart_either/dart_either.dart';
import 'package:auth_flow_app/core/error/exceptions.dart';
import 'package:auth_flow_app/core/error/failures.dart';
import 'package:auth_flow_app/features/auth/data/datasources/email_auth_datasource.dart';
import 'package:auth_flow_app/features/auth/domain/entities/user_entity.dart';
import 'package:auth_flow_app/features/auth/domain/repositories/email_auth_repository.dart';

class EmailAuthRepositoryImpl implements EmailAuthRepository {
  final EmailAuthDataSource _emailAuthDataSource;

  EmailAuthRepositoryImpl({required this._emailAuthDataSource});

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final user = await _emailAuthDataSource.signUpWithEmail(
        email: email,
        password: password,
        name: name,
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
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _emailAuthDataSource.signInWithEmail(email: email, password: password);
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
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    try {
      await _emailAuthDataSource.resetPassword(email: email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail({required String email, required String otp}) async {
    try {
      await _emailAuthDataSource.verifyEmail(email: email, token: otp);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword({required String password}) async {
    try {
      await _emailAuthDataSource.updatePassword(password: password);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> sendMagicLink({required String email, String? emailRedirectTo}) async {
    try {
      await _emailAuthDataSource.sendMagicLink(email: email, emailRedirectTo: emailRedirectTo);
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
