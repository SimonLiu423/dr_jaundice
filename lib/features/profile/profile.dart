import 'package:dr_jaundice/core/getit.dart';
import 'package:dr_jaundice/core/profile_bloc/profile_bloc.dart';
import 'package:dr_jaundice/features/home/widgets/first_launch_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/n_background1.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Profile'),
        ),
        body: BlocProvider<ProfileBloc>.value(
          value: sl<ProfileBloc>(),
          child: const ProfileEditDialog(),
        ),
      ),
    );
  }
}
