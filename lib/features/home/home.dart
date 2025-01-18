import 'package:dr_jaundice/core/profile_bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:dr_jaundice/features/analysis/analysis.dart';
import 'package:dr_jaundice/features/history/history.dart';
import 'package:dr_jaundice/features/profile/profile.dart';
import 'package:dr_jaundice/features/take_picture/take_picture.dart';
import 'package:dr_jaundice/features/home/widgets/round_image_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dr_jaundice/features/home/widgets/first_launch_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Remove splash screen after screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileRequired) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const FirstLaunchDialog(),
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        return Container(
          // Set background image
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/n_background.png'),
              fit: BoxFit.cover,
              opacity: 1,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Column(
                children: [
                  Text('tester'),
                  Text('180時（7日12時）'),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.girl, size: 50),
                  onPressed: () {
                    // Add menu action here
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  flex: 75, // 75% main content
                  child: _HomeButtons(),
                ),
                const Expanded(
                  flex: 25, // 25% empty space
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HomeButtons extends StatelessWidget {
  static const double buttonSize = 150;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RoundImageButton(
              image: 'assets/images/n_personal_data.png',
              size: buttonSize,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                );
              },
            ),
            RoundImageButton(
              image: 'assets/images/n_history.png',
              size: buttonSize,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryPage(),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RoundImageButton(
              image: 'assets/images/n_taking_picture.png',
              size: buttonSize,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TakePicturePage(),
                  ),
                );
              },
            ),
            RoundImageButton(
              image: 'assets/images/n_jaundice_analysis.png',
              size: buttonSize,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnalysisPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
