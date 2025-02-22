part of 'analysis_bloc.dart';

@immutable
sealed class AnalysisState {}

final class AnalysisInitial extends AnalysisState {}

final class AnalysisLoading extends AnalysisState {}

final class AnalysisLoaded extends AnalysisState {
  final String result;

  AnalysisLoaded({required this.result});
}

final class ImageLoaded extends AnalysisState {
  final File image;

  ImageLoaded({required this.image});
}