import 'package:auth_flow_app/core/error/failures.dart';
import 'package:auth_flow_app/features/auth/domain/entities/user_entity.dart';
import 'package:dart_either/dart_either.dart';

abstract class SocialAuthRepository {
  Future<Either<Failure, UserEntity>> signInWithGoogle();

  Future<Either<Failure, void>> signInWithGitHub();
}
