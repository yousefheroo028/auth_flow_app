import 'package:auth_flow_app/core/error/exceptions.dart';
import 'package:auth_flow_app/features/auth/data/datasources/auth_client.dart';
import 'package:auth_flow_app/features/auth/data/datasources/phone_auth_datasource.dart';
import 'package:auth_flow_app/features/auth/data/models/user_model.dart';

class PhoneAuthDataSourceImpl implements PhoneAuthDataSource {
  final AuthClient _authClient;

  PhoneAuthDataSourceImpl(this._authClient);

  @override
  Future<void> sendOTP({required String phoneNumber}) async {
    try {
      await _authClient.signInWithPhoneNumber(phoneNumber: phoneNumber);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to send OTP: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> verifyOTP({
    required String phoneNumber,
    required String otpCode,
  }) async {
    try {
      final response = await _authClient.verifyAuthWithPhoneNumber(phoneNumber: phoneNumber, otp: otpCode);
      if (response.user == null) {
        throw AuthException('Phone Number is not verified.');
      }

      return UserModel.fromSupabase(response.user!);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to verify OTP: ${e.toString()}');
    }
  }
}
