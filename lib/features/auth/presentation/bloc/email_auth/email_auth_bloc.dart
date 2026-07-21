import 'dart:async';

import 'package:auth_flow_app/features/auth/domain/repositories/email_auth_repository.dart';
import 'package:auth_flow_app/features/auth/presentation/bloc/email_auth/email_auth_event.dart';
import 'package:auth_flow_app/features/auth/presentation/bloc/email_auth/email_auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailAuthBloc extends Bloc<EmailAuthEvent, EmailAuthState> {
  final EmailAuthRepository emailAuthRepository;

  EmailAuthBloc({required this.emailAuthRepository}) : super(const EmailAuthInitial()) {
    on<SignUpWithEmailEvent>(_onSignUpWithEmail);
    on<SignInWithEmailEvent>(_onSignInWithEmail);
    on<ResetPasswordEvent>(_onResetPassword);
    on<VerifyEmailEvent>(_onVerifyEmail);
    on<UpdatePasswordEvent>(_onUpdatePassword);
    on<SendMagicLinkEvent>(_onSendMagicLink);
    on<ResetEmailAuthStateEvent>((event, emit) => emit(const EmailAuthInitial()));
  }

  Future<void> _onSignUpWithEmail(
    SignUpWithEmailEvent event,
    Emitter<EmailAuthState> emit,
  ) async {
    emit(const EmailAuthLoading());

    final result = await emailAuthRepository.signUpWithEmail(
      email: event.email,
      password: event.password,
      name: event.name,
    );

    result.fold(
      ifLeft: (failure) => emit(EmailAuthError(message: failure.message)),
      ifRight: (user) => emit(EmailAuthSuccess(user: user)),
    );
  }

  Future<void> _onSignInWithEmail(
    SignInWithEmailEvent event,
    Emitter<EmailAuthState> emit,
  ) async {
    emit(const EmailAuthLoading());

    final result = await emailAuthRepository.signInWithEmail(
      email: event.email,
      password: event.password,
    );

    result.fold(
      ifLeft: (failure) => emit(EmailAuthError(message: failure.message)),
      ifRight: (user) => emit(EmailAuthSuccess(user: user)),
    );
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<EmailAuthState> emit,
  ) async {
    emit(const EmailAuthLoading());

    final result = await emailAuthRepository.resetPassword(email: event.email);

    result.fold(
      ifLeft: (failure) => emit(EmailAuthError(message: failure.message)),
      ifRight: (_) => emit(PasswordResetRequestEmailSent(message: 'Password reset email has been sent', email: event.email)),
    );
  }

  Future<void> _onVerifyEmail(VerifyEmailEvent event, Emitter<EmailAuthState> emit) async {
    emit(const EmailAuthLoading());

    final result = await emailAuthRepository.verifyEmail(email: event.email, otp: event.otp);

    result.fold(
      ifLeft: (failure) => emit(EmailAuthError(message: failure.message)),
      ifRight: (_) => emit(PasswordResetRequestEmailVerify(message: 'Email verified', email: event.email)),
    );
  }

  Future<void> _onUpdatePassword(UpdatePasswordEvent event, Emitter<EmailAuthState> emit) async {
    emit(const EmailAuthLoading());

    final result = await emailAuthRepository.updatePassword(password: event.password);

    result.fold(
      ifLeft: (failure) => emit(EmailAuthError(message: failure.message)),
      ifRight: (_) => emit(const PasswordResetDone()),
    );
  }

  Future<void> _onSendMagicLink(
    SendMagicLinkEvent event,
    Emitter<EmailAuthState> emit,
  ) async {
    emit(const EmailAuthLoading());

    final result = await emailAuthRepository.sendMagicLink(
      email: event.email,
      emailRedirectTo: event.emailRedirectTo,
    );

    result.fold(
      ifLeft: (failure) => emit(EmailAuthError(message: failure.message)),
      ifRight: (_) => emit(MagicLinkSentState(email: event.email)),
    );
  }
}
