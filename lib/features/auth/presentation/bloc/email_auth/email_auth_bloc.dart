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
    on<SendMagicLinkEvent>(_onSendMagicLink);
  }

  Future<void> _onSignUpWithEmail(
    SignUpWithEmailEvent event,
    Emitter<EmailAuthState> emit,
  ) async {
    emit(const EmailAuthLoading());

    final result = await emailAuthRepository.signUpWithEmail(
      email: event.email,
      password: event.password,
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
      ifRight: (_) => emit(const EmailSent(message: 'Password reset email sent')),
    );
  }

  Future<void> _onSendMagicLink(
    SendMagicLinkEvent event,
    Emitter<EmailAuthState> emit,
  ) async {
    emit(const EmailAuthLoading());

    final result = await emailAuthRepository.sendMagicLink(email: event.email);

    result.fold(
      ifLeft: (failure) => emit(EmailAuthError(message: failure.message)),
      ifRight: (_) => emit(const EmailSent(message: 'Magic link sent to your email')),
    );
  }
}
