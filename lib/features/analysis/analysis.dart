import 'dart:developer';

import 'package:flutter/material.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/n_background2.png'),
          fit: BoxFit.cover,
          opacity: 1,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Analysis'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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
        ),
      ),
    );
  }
}
