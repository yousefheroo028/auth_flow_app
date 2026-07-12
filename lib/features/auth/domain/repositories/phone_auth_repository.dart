import 'package:auth_flow_app/core/error/failures.dart';
import 'package:auth_flow_app/features/auth/domain/entities/user_entity.dart';
import 'package:dart_either/dart_either.dart';

abstract class PhoneAuthRepository {
  Future<Either<Failure, void>> sendOTP({required String phoneNumber});

  Future<Either<Failure, UserEntity>> verifyOTP({
    required String phoneNumber,
    required String otpCode,
  });
}
