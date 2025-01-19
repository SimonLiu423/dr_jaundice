part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class SaveProfile extends ProfileEvent {
  SaveProfile(this.profile);

  final Profile profile;
}

class LoadProfile extends ProfileEvent {}

class DeleteProfile extends ProfileEvent {}
