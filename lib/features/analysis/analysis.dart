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
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('分析結果'),
                  content: Text(state.result),
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
