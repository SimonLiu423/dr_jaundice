part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileRequired extends ProfileState {}

final class ProfileLoaded extends ProfileState {}
