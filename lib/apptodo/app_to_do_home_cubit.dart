import 'package:app_to_do/apptodo/app_to_do_home_state.dart';
import 'package:app_to_do/entity/task_entity.dart';
import 'package:app_to_do/resources/hive_key.dart';
import 'package:app_to_do/resources/shared_key.dart';
import 'package:app_to_do/router/route_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppToDoHomeCubit extends Cubit<AppToDoHomeState> {
  AppToDoHomeCubit() : super(AppToDoHomeState());

  bool selected = false;

  Future<void> getDataTask() async {
    final Box<TaskEntity> box = await Hive.openBox<TaskEntity>('task');
    final List<TaskEntity> listEntity = box.values.toList();
    emit(DayLoadedState(entity: listEntity));
  }

  Future<void> handleLogOut(BuildContext context) async {
    GoRouter.of(context).pushNamed(routerNameLogin);
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('rememberMe');
  }

  Future<void> deleteDataTask(TaskEntity taskEntity) async {
    final Box<TaskEntity> box = await Hive.openBox<TaskEntity>('task');
    box.delete(taskEntity.key);
    emit(DeleteTask(taskEntity: taskEntity));
  }

  Future<void> updateIndexSelected(
      List<TaskEntity> listEntity, int index, String selectedDate) async {
    final Box<TaskEntity> box = await Hive.openBox<TaskEntity>('task');
    final List<TaskEntity> tasksByDate =
        box.values.where((task) => task.date == selectedDate).toList();
    emit(DayLoadedState(
        entity: tasksByDate, indexSelected: index, isUpdated: true));
  }

  Future<void> updateTaskStatus(TaskEntity? taskEntity, bool newStatus) async {
    taskEntity?.status = !taskEntity.status;

    taskEntity?.save();
    emit(UpdateTaskStatus(status: newStatus));
  }

  Future<void> deleteBoxTask() async {
    final Box<TaskEntity> box = await Hive.openBox<TaskEntity>('task');

    for (var element in box.values) {
      element.delete();
    }

    emit(DeleteAllTask());
  }

  Future<void> getTaskByMatchingEmail({String? email}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String? emailHive = email ?? pref.getString(SharedKey.email);
    final Box<TaskEntity> taskBox =
        await Hive.openBox<TaskEntity>(HiveKey.task);
    final List<TaskEntity> taskEntity =
        taskBox.values.where((task) => task.email == emailHive).toList();
    emit(DayLoadedState(entity: taskEntity));
  }
}
