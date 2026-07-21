import 'package:auth_flow_app/features/auth/domain/repositories/profile_repository.dart';
import 'package:auth_flow_app/features/auth/presentation/bloc/profile/profile_event.dart';
import 'package:auth_flow_app/features/auth/presentation/bloc/profile/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(const ProfileInitial()) {
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<UploadProfilePictureEvent>(_onUploadProfilePicture);
    on<DeleteAccountEvent>(_onDeleteAccount);
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    final result = await profileRepository.updateProfile(
      displayName: event.displayName,
      photoUrl: event.photoUrl,
    );

    result.fold(
      ifLeft: (failure) => emit(ProfileError(message: failure.message)),
      ifRight: (user) => emit(ProfileUpdated(user: user)),
    );
  }

  Future<void> _onUploadProfilePicture(
    UploadProfilePictureEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    final result = await profileRepository.uploadProfilePicture(filePath: event.filePath);

    result.fold(
      ifLeft: (failure) => emit(ProfileError(message: failure.message)),
      ifRight: (photoUrl) => emit(ProfilePictureUploaded(photoUrl: photoUrl)),
    );
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    final result = await profileRepository.deleteAccount();

    result.fold(
      ifLeft: (failure) => emit(ProfileError(message: failure.message)),
      ifRight: (_) => emit(const AccountDeleted()),
    );
  }
}
