import 'dart:io';
import '../../../core/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'analysis_event.dart';
part 'analysis_state.dart';

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  AnalysisBloc() : super(AnalysisInitial()) {
    on<StartAnalysis>(_onStartAnalysis);
    on<LoadImage>(_onLoadImage);
  }

  final dio = Dio();
  File? image;

  Future<void> _onLoadImage(
      LoadImage event, Emitter<AnalysisState> emit) async {
    image = event.image;
    emit(ImageLoaded(image: image!));
  }

  Future<void> _onStartAnalysis(
      StartAnalysis event, Emitter<AnalysisState> emit) async {
    emit(AnalysisLoading());

    // TODO(SimonLiu423): Revise this part when the API is ready
    await Future.delayed(const Duration(seconds: 2));

    // final result = await dio.post(
    //   '$apiUrl/analyze',
    //   data: FormData.fromMap({
    //     'image': MultipartFile.fromFileSync(image!.path),
    //   }),
    // );

    emit(AnalysisLoaded(result: 'Success'));
  }
}
