import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required this.prefs}) : super(ProfileInitial()) {
    on<SaveProfile>(_onSaveProfile);
    on<LoadProfile>(_onLoadProfile);
    on<DeleteProfile>(_onDeleteProfile);
  }

  final SharedPreferences prefs;
  Profile? profile;

  Future<void> _onSaveProfile(
      SaveProfile event, Emitter<ProfileState> emit) async {
    profile = event.profile;
    await prefs.setString('profile', jsonEncode(event.profile.toJson()));
    emit(ProfileLoaded());
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    final profileJson = prefs.getString('profile');
    if (profileJson == null) {
      emit(ProfileRequired());
      return;
    }
    profile = Profile.fromJson(jsonDecode(profileJson));
    emit(ProfileLoaded());
  }

  Future<void> _onDeleteProfile(
      DeleteProfile event, Emitter<ProfileState> emit) async {
    await prefs.remove('profile');
    profile = null;
    emit(ProfileRequired());
  }
}
