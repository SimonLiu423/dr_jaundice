import 'package:dr_jaundice/core/profile_bloc/profile_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> setupGetIt() async {
  sl.registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance());
  sl.registerSingleton<ProfileBloc>(
      ProfileBloc(prefs: sl<SharedPreferences>()));
}
