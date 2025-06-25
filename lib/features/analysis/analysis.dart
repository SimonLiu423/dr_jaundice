import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'bloc/analysis_bloc.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key, this.image});

  final File? image;

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  final _picker = ImagePicker();

  final _bloc = AnalysisBloc();

  @override
  void initState() {
    super.initState();
    if (widget.image != null) {
      _bloc.add(LoadImage(image: widget.image!));
    }
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        _bloc.add(LoadImage(image: File(pickedFile.path)));
      }
    } catch (e) {
      log('Error picking image: $e');
      String errorMessage = '無法取得照片，請確認相機權限是否已開啟';
      if (e is PlatformException) {
        if (e.code == 'camera_access_denied') {
          errorMessage = '相機權限已被拒絕，請至設定開啟權限';
        } else if (e.code == 'photo_access_denied') {
          errorMessage = '相簿權限已被拒絕，請至設定開啟權限';
        }
      }

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('錯誤'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('確定'),
              ),
            ],
          ),
        );
      }
    }
  }

  Widget _buildAnalysisView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Image.file(
            context.read<AnalysisBloc>().image!,
            fit: BoxFit.contain,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final buttonWidth =
                  (constraints.maxWidth - 30) / 5; // Account for padding
              final iconSize =
                  buttonWidth * 0.9; // Slightly smaller than container
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    iconSize: buttonWidth,
                    icon: Image.asset(
                      'assets/images/n_home.png',
                      height: iconSize,
                    ),
                    onPressed: () {
                      log('home pressed');
                    },
                  ),
                  IconButton(
                    iconSize: buttonWidth,
                    icon: Image.asset(
                      'assets/images/n_rotate.png',
                      height: iconSize,
                    ),
                    onPressed: () {
                      log('rotate pressed');
                    },
                  ),
                  IconButton(
                    iconSize: buttonWidth,
                    icon: Image.asset(
                      'assets/images/n_analysis.png',
                      height: iconSize,
                    ),
                    onPressed: () {
                      log('analysis pressed');
                      _bloc.add(StartAnalysis());
                    },
                  ),
                  IconButton(
                    iconSize: buttonWidth,
                    icon: Image.asset(
                      'assets/images/n_result.png',
                      height: iconSize,
                    ),
                    onPressed: () {
                      log('result pressed');
                      showResultsDialog(
                        context,
                        context.read<AnalysisBloc>().jvValue,
                        context.read<AnalysisBloc>().riskNumber,
                      );
                    },
                  ),
                  IconButton(
                    iconSize: buttonWidth,
                    icon: Image.asset(
                      'assets/images/n_reset1.png',
                      height: iconSize,
                    ),
                    onPressed: () {
                      log('reset pressed');
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageSelectionView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '請選擇要分析的照片',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onPressed: () => _pickImage(context, ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text('拍攝照片'),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onPressed: () => _pickImage(context, ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text('從相簿選擇'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/n_background1.png'),
            fit: BoxFit.cover,
            opacity: 1,
          ),
        ),
        child: BlocConsumer<AnalysisBloc, AnalysisState>(
          listener: (context, state) {
            if (state is AnalysisLoaded) {
              showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('成功'),
                  content: Text(state.result),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('確定'),
                    ),
                  ],
                ),
              );
            } else if (state is AnalysisError) {
              showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('錯誤'),
                  content: Text(state.message),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('確定'),
                    ),
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    title: const Text('黃疸分析'),
                  ),
                  body: state is AnalysisInitial
                      ? _buildImageSelectionView(context)
                      : _buildAnalysisView(context),
                ),
                if (state is AnalysisLoading)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: Colors.white,
                          ),
                          SizedBox(height: 16),
                          Text(
                            '分析中...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Risk calculation logic ported from ResultViewController.m
const List<List<double>> _stbTable = [
  [4.5, 5.6, 6.9],
  [4.6, 5.7, 7.2],
  [4.7, 5.8, 7.4],
  [4.8, 6, 7.5],
  [4.9, 6.1, 7.6],
  [4.9, 6.3, 7.7],
  [5, 6.4, 7.8],
  [5.2, 6.6, 8.1],
  [5.3, 6.7, 8.4],
  [5.5, 6.9, 8.6],
  [5.6, 7, 8.9],
  [5.8, 7.2, 9.2],
  [6, 7.5, 9.4],
  [6.1, 7.7, 9.7],
  [6.3, 8, 10],
  [6.5, 8.2, 10.3],
  [6.7, 8.5, 10.5],
  [6.9, 8.7, 10.8],
  [7, 8.9, 11.1],
  [7.2, 9.2, 11.4],
  [7.4, 9.4, 11.6],
  [7.6, 9.7, 11.9],
  [7.8, 9.9, 12.2],
  [7.9, 10, 12.3],
  [7.9, 10.1, 12.3],
  [8, 10.1, 12.4],
  [8.1, 10.2, 12.5],
  [8.2, 10.4, 12.7],
  [8.4, 10.5, 12.8],
  [8.5, 10.7, 13],
  [8.6, 10.8, 13.2],
  [8.7, 11, 13.3],
  [8.8, 11.1, 13.5],
  [8.9, 11.3, 13.7],
  [8.9, 11.4, 13.8],
  [9, 11.6, 14],
  [9.1, 11.7, 14.2],
  [9.2, 11.9, 14.3],
  [9.3, 12, 14.5],
  [9.4, 12.2, 14.7],
  [9.4, 12.3, 14.8],
  [9.5, 12.5, 15],
  [9.6, 12.6, 15.2],
  [9.7, 12.7, 15.2],
  [9.9, 12.7, 15.3],
  [10, 12.8, 15.4],
  [10.1, 12.9, 15.4],
  [10.3, 12.9, 15.5],
  [10.4, 13, 15.5],
  [10.5, 13.1, 15.6],
  [10.7, 13.1, 15.7],
  [10.8, 13.2, 15.7],
  [10.9, 13.3, 15.8],
  [11.1, 13.3, 15.9],
  [11.2, 13.4, 15.9],
  [11.2, 13.5, 16],
  [11.3, 13.6, 16.1],
  [11.3, 13.7, 16.1],
  [11.3, 13.8, 16.2],
  [11.4, 13.9, 16.3],
  [11.4, 14, 16.3],
  [11.4, 14.1, 16.4],
  [11.5, 14.2, 16.5],
  [11.5, 14.3, 16.5],
  [11.5, 14.4, 16.6],
  [11.6, 14.5, 16.6],
  [11.6, 14.6, 16.7],
  [11.7, 14.7, 16.8],
  [11.7, 14.7, 16.8],
  [11.8, 14.8, 16.9],
  [11.9, 14.8, 16.9],
  [11.9, 14.9, 17],
  [12, 14.9, 17.1],
  [12.1, 15, 17.1],
  [12.1, 15, 17.2],
  [12.2, 15.1, 17.2],
  [12.3, 15.1, 17.3],
  [12.3, 15.2, 17.3],
  [12.4, 15.2, 17.4],
  [12.4, 15.2, 17.4],
  [12.5, 15.3, 17.4],
  [12.5, 15.3, 17.4],
  [12.5, 15.3, 17.4],
  [12.6, 15.3, 17.4],
  [12.6, 15.4, 17.5],
  [12.7, 15.4, 17.5],
  [12.7, 15.4, 17.5],
  [12.7, 15.4, 17.5],
  [12.8, 15.5, 17.5],
  [12.8, 15.5, 17.5],
  [12.8, 15.5, 17.5],
  [12.9, 15.5, 17.5],
  [12.9, 15.6, 17.5],
  [12.9, 15.6, 17.5],
  [13, 15.6, 17.5],
  [13, 15.6, 17.5],
  [13, 15.7, 17.6],
  [13.1, 15.7, 17.6],
  [13.1, 15.7, 17.6],
  [13.1, 15.7, 17.6],
  [13.2, 15.8, 17.6],
  [13.2, 15.8, 17.6],
  [13.2, 15.8, 17.6],
  [13.2, 15.8, 17.6],
  [13.2, 15.8, 17.6],
  [13.2, 15.7, 17.6],
  [13.2, 15.7, 17.5],
  [13.2, 15.7, 17.5],
  [13.2, 15.7, 17.5],
  [13.2, 15.7, 17.5],
  [13.2, 15.6, 17.5],
  [13.2, 15.6, 17.5],
  [13.2, 15.6, 17.5],
  [13.2, 15.6, 17.4],
  [13.2, 15.6, 17.4],
  [13.2, 15.5, 17.4],
  [13.2, 15.5, 17.4],
  [13.2, 15.5, 17.4],
  [13.2, 15.5, 17.4],
  [13.2, 15.5, 17.4],
  [13.2, 15.4, 17.4],
  [13.2, 15.4, 17.3],
  [13.2, 15.4, 17.3],
  [13.2, 15.4, 17.3],
  [13.2, 15.3, 17.3],
  [13.2, 15.3, 17.3],
  [13.2, 15.3, 17.3],
  [13.2, 15.3, 17.3],
  [13.2, 15.3, 17.3],
  [13.2, 15.3, 17.4],
  [13.2, 15.3, 17.4],
  [13.3, 15.3, 17.5],
  [13.3, 15.3, 17.5],
  [13.3, 15.3, 17.5],
  [13.3, 15.3, 17.6],
  [13.3, 15.3, 17.6],
  [13.3, 15.3, 17.6],
  [13.3, 15.4, 17.7],
  [13.3, 15.4, 17.7],
  [13.3, 15.4, 17.7],
  [13.3, 15.4, 17.8],
  [13.4, 15.4, 17.8],
  [13.4, 15.4, 17.9],
  [13.4, 15.4, 17.9],
  [13.4, 15.4, 17.9],
  [13.4, 15.4, 18],
  [13.4, 15.4, 18],
  [13.4, 15.4, 18],
  [13.4, 15.4, 18.1],
  [13.4, 15.4, 18.1],
  [13.4, 15.4, 18.2],
];

const List<String> _riskLevels = ['低風險', '中低風險', '中高風險', '高度風險'];
const List<String> _riskTexts = [
  '本APP之檢測結果有可能因為現場光源、陰影反光、成相品質等因素影響，建議內容僅為參考之用，無法取代實際的血液檢測及醫療行為，請依寶寶實際膚變化以及照顧情形判斷，如有任何疑問請洽詢小兒科醫師評估。',
  '本APP之檢測結果有可能因為現場光源、陰影反光、成相品質等因素影響，建議內容僅為參考之用，無法取代實際的血液檢測及醫療行為，請依寶寶實際膚變化以及照顧情形判斷，如有任何疑問請洽詢小兒科醫師評估。',
  '預估黃疸值偏高，建議洽詢小兒科醫師評估，如果寶寶出現虛弱、吸吮力減弱、嗜睡、嘔吐、全身皮膚明顯泛黃或大便呈灰白色時，應立即就醫。切勿自行以陽光或一般日光燈照射，不但無效還有可能造成寶寶眼睛的傷害。',
  '預估黃疸值偏高，建議洽詢小兒科醫師評估，如果寶寶出現虛弱、吸吮力減弱、嗜睡、嘔吐、全身皮膚明顯泛黃或大便呈灰白色時，應立即就醫。切勿自行以陽光或一般日光燈照射，不但無效還有可能造成寶寶眼睛的傷害。',
];

Map<String, dynamic> calculateRisk(double jvValue, {int birthHour = 48}) {
  // Clamp birthHour to 18~144
  final int hour = birthHour.clamp(18, 144);
  final List<double> range = _stbTable[hour - 18];
  int riskNumber = 0;
  if (jvValue <= range[0]) {
    riskNumber = 0;
  } else if (jvValue <= range[1]) {
    riskNumber = 1;
  } else if (jvValue <= range[2]) {
    riskNumber = 2;
  } else {
    riskNumber = 3;
  }
  return {
    'risk': _riskLevels[riskNumber],
    'riskText': _riskTexts[riskNumber],
    'riskNumber': riskNumber,
  };
}

Future<void> showResultsDialog(
    BuildContext context, double? jvValue, int? riskNumber,
    {int birthHour = 48}) async {
  if (jvValue == null || riskNumber == null) {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('無分析結果'),
        content: const Text('請先進行分析。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('確定'),
          ),
        ],
      ),
    );
    return;
  }
  final risk = _riskLevels[riskNumber];
  final riskText = _riskTexts[riskNumber];
  await showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/n_background3.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('JV值',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            SizedBox(height: 8),
            Text(jvValue.toStringAsFixed(2),
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange)),
            SizedBox(height: 16),
            Text('風險等級',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            SizedBox(height: 8),
            Text(risk,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red)),
            SizedBox(height: 16),
            Text('風險說明',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            SizedBox(height: 8),
            Text(riskText,
                style: TextStyle(fontSize: 16, color: Colors.black87)),
            SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('確定'),
            ),
          ],
        ),
      ),
    ),
  );
}
