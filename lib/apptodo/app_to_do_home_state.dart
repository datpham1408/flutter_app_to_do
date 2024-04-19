import 'package:app_to_do/entity/task_entity.dart';

class AppToDoHomeState {}

class DayLoadedState extends AppToDoHomeState {
  final List<TaskEntity> entity;
  final int? indexSelected;
  final bool isUpdated;

  DayLoadedState(
      {required this.entity, this.indexSelected, this.isUpdated = false});
}

class GetDataTask extends AppToDoHomeState {
  final List<TaskEntity> task;

  GetDataTask({required this.task});
}

class DeleteTask extends AppToDoHomeState {
  final TaskEntity taskEntity;

  DeleteTask({required this.taskEntity});
}

class UpdateTaskStatus extends AppToDoHomeState {
  final bool? status;

  UpdateTaskStatus({this.status});
}

class DeleteAllTask extends AppToDoHomeState {}

class GetTaskByMatchingEmail extends AppToDoHomeState {}
