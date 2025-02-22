part of 'analysis_bloc.dart';

@immutable
sealed class AnalysisEvent {}

class StartAnalysis extends AnalysisEvent {}

class LoadImage extends AnalysisEvent {
  final File image;

  LoadImage({required this.image});
}
