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
  double? jvValue;
  int? riskNumber;

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

    // Simulate a response from backend for demonstration
    final dynamic responseJVValue =
        21.85; // Change this value to test different cases
    final int responseRiskNumber = 2; // Example: 中高風險

    final String? errorMessage = _getErrorMessage(responseJVValue);
    if (errorMessage != null) {
      emit(AnalysisError(message: errorMessage));
      return;
    }

    // If value is not negative and can be parsed as double, treat as success
    if (responseJVValue is num && responseJVValue >= 0) {
      emit(AnalysisLoaded(result: '處理完成!\nJV = $responseJVValue'));
      jvValue = responseJVValue.toDouble();
      riskNumber = responseRiskNumber;
      return;
    }

    // If value can't be parsed as double, just show the raw string
    emit(AnalysisError(message: responseJVValue.toString()));
  }

  String? _getErrorMessage(dynamic JV) {
    int? value;
    if (JV is int) {
      value = JV;
    } else if (JV is String) {
      value = int.tryParse(JV);
    } else if (JV is double) {
      value = JV.toInt();
    }
    if (value == null || value >= 0) return null;
    switch (value) {
      case -100:
        return '照片上傳錯誤！';
      case -111:
        return 'Load yoloColorPatternDetector error!';
      case -110:
        return 'yoloColorPatternDetector not found!';
      case -113:
      case -112:
        return '找不到色塊！\n請將色塊擺在正確位置！';
      case -411:
        return 'Load yoloChestDetector error!';
      case -410:
        return 'yoloChestDetector not found!';
      case -413:
      case -412:
        return '請儘量露出嬰兒胸部！';
      case -200:
        return '光線不是很理想，請儘量使用亮一點的白光！\n或者是色塊有反光現象！';
      case -300:
        return '光線不是很理想，請儘量使用亮一點的白光！';
      case -400:
      case -500:
        return '胸部區域反光或被衣服遮住！';
      default:
        return '未知錯誤！\n請重新取像！';
    }
  }
}
