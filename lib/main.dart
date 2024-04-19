import 'package:app_to_do/apptodo/app_to_do_cubit.dart';
import 'package:app_to_do/apptodo/app_to_do_home_cubit.dart';
import 'package:app_to_do/entity/task_adapter.dart';
import 'package:app_to_do/entity/user_adapter.dart';
import 'package:app_to_do/login/login_cubit.dart';
import 'package:app_to_do/router/my_application.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'register/register_cubit.dart';

final GetIt getIt = GetIt.instance;
SharedPreferences? preferences;

void main() async {
  await initGetIt();
  await initCubit();
  await initHive();
  await initSharedPreferences();
  runApp(const Application());
}

Future<void> initGetIt() async {}

Future<void> initCubit() async {
  getIt.registerLazySingleton<AppToDoHomeCubit>(() => AppToDoHomeCubit());
  getIt.registerLazySingleton<AppToDoCubit>(() => AppToDoCubit());
  getIt.registerLazySingleton<LoginCubit>(() => LoginCubit());
  getIt.registerLazySingleton<RegisterCubit>(() => RegisterCubit());
}

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(TaskAdapter());
}

Future<void> initSharedPreferences() async {
}

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApplication(),
    );
  }
}
