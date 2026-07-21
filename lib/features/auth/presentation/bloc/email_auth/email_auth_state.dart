import 'package:equatable/equatable.dart';
import 'package:auth_flow_app/features/auth/domain/entities/user_entity.dart';

abstract class EmailAuthState extends Equatable {
  const EmailAuthState();

  @override
  List<Object?> get props => [];
}

class EmailAuthInitial extends EmailAuthState {
  const EmailAuthInitial();
}

class EmailAuthLoading extends EmailAuthState {
  const EmailAuthLoading();
}

class EmailAuthSuccess extends EmailAuthState {
  final UserEntity user;

  const EmailAuthSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class EmailAuthError extends EmailAuthState {
  final String message;

  const EmailAuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class PasswordResetRequestEmailSent extends EmailAuthState {
  final String message;
  final String email;

  const PasswordResetRequestEmailSent({required this.message, required this.email});

  @override
  List<Object?> get props => [message, email];
}

class PasswordResetRequestEmailVerify extends EmailAuthState {
  final String message;
  final String email;

  const PasswordResetRequestEmailVerify({required this.message, required this.email});

  @override
  List<Object?> get props => [message, email];
}

class PasswordResetDone extends EmailAuthState {
  const PasswordResetDone();
}

class MagicLinkSentState extends EmailAuthState {
  final String email;

  const MagicLinkSentState({required this.email});

  @override
  List<Object?> get props => [email];
}
