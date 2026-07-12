import 'package:auth_flow_app/core/error/failures.dart';
import 'package:auth_flow_app/features/auth/domain/entities/user_entity.dart';
import 'package:dart_either/dart_either.dart';

abstract class SessionRepository {
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, void>> signOut();

  Stream<UserEntity?> get authStateChanges;
}
