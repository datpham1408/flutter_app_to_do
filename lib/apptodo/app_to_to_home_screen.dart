import 'dart:io';
import 'package:app_to_do/apptodo/app_to_do_home_cubit.dart';
import 'package:app_to_do/apptodo/app_to_do_home_state.dart';
import 'package:app_to_do/apptodo/day_screen.dart';
import 'package:app_to_do/entity/task_entity.dart';
import 'package:app_to_do/main.dart';
import 'package:app_to_do/model/day_model.dart';
import 'package:app_to_do/router/route_constant.dart';
import 'package:app_to_do/utils/image.dart';
import 'package:app_to_do/utils/string.dart';
import 'package:app_to_do/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppToDoHomeScreen extends StatefulWidget {
  final String? email;

  const AppToDoHomeScreen({super.key, required this.email});

  @override
  State<AppToDoHomeScreen> createState() => _AppToDoScreenState();
}

class _AppToDoScreenState extends State<AppToDoHomeScreen> {
  final AppToDoHomeCubit _appToDoHomeCubit = getIt.get<AppToDoHomeCubit>();
  String? dateSelected;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _appToDoHomeCubit.getTaskByMatchingEmail(email: widget.email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: BlocProvider<AppToDoHomeCubit>(
        create: (_) => _appToDoHomeCubit,
        child: BlocConsumer<AppToDoHomeCubit, AppToDoHomeState>(
          listener: (_, AppToDoHomeState state) {
            _handleListener(state);
          },
          buildWhen: (_, AppToDoHomeState state) {
            return state is DayLoadedState;
          },
          builder: (_, AppToDoHomeState state) {
            return itemBody();
          },
        ),
      ),
    ));
  }

  Widget itemBody() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          itemAvatar(),
          itemTitle(),
          BlocBuilder<AppToDoHomeCubit, AppToDoHomeState>(
              buildWhen: (_, AppToDoHomeState state) {
            return state is DayLoadedState;
          }, builder: (_, AppToDoHomeState state) {
            if (state is DayLoadedState) {
              return SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: itemListDay(state: state));
            }
            return SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: itemListDay());
          }),
          BlocBuilder<AppToDoHomeCubit, AppToDoHomeState>(
              buildWhen: (_, AppToDoHomeState state) {
            return state is DayLoadedState;
          }, builder: (_, AppToDoHomeState state) {
            if (state is DayLoadedState) {
              return Expanded(child: itemListToDo(state: state));
            }
            return Expanded(child: itemListToDo());
          }),
        ],
      ),
    );
  }

  Widget itemListToDo({DayLoadedState? state}) {
    final List<TaskEntity>? task = state?.entity;
    return task?.length != null
        ? ListView.builder(
            itemCount: task?.length ?? 0,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final TaskEntity? entity = task?[index];
              return GestureDetector(
                  onTap: () {
                    _showBottomSheet(context, entity);
                  },
                  child: itemDetailListToDo(entity));
            },
          )
        : Container();
  }

  Widget itemDetailListToDo(TaskEntity? entity) {
    return Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Color(entity?.color ?? 0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entity?.title ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Utils.instance.sizeBoxHeight(14),
                  Row(
                    children: [
                      Image.asset(
                        clock,
                        height: 20,
                        color: Colors.white,
                        width: 20,
                      ),
                      Utils.instance.sizeBoxHeight(14),
                      Text(
                        '${entity?.startTime} -${entity?.endTime}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Utils.instance.sizeBoxHeight(14),
                  Text(entity?.note ?? '',
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
            Flexible(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(
                    entity?.image ?? '',
                  ),
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ));
  }

  Widget sizeWidthBox(double width) {
    return SizedBox(
      width: width,
    );
  }

  Widget itemListDay({DayLoadedState? state}) {
    final List<TaskEntity> list = state?.entity ?? [];
    final List<DayModel> listDay = [];

    for (int i = 0; i < list.length; i++) {
      final String date = list[i].date ?? '';
      final bool isUpdate = state?.isUpdated == true;
      final DayModel dayModel = DayModel(day: date, selected: isUpdate);
      if (!listDay.contains(dayModel)) {
        listDay.add(dayModel);
      }
    }
    listDay.sort((DayModel day1, DayModel day2) {
      return day1.day.compareTo(day2.day);
    });
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: listDay.length,
      itemBuilder: (context, index) {
        final DayModel model = listDay.elementAt(index);
        return BlocBuilder<AppToDoHomeCubit, AppToDoHomeState>(
          builder: (_, AppToDoHomeState state) {
            return Container(
              margin: const EdgeInsets.only(left: 16, right: 8),
              child: DayWidget(
                dayModel: model,
                callback: () {
                  if (model.selected == false) {
                    _appToDoHomeCubit.updateIndexSelected(
                        list, index, model.day);
                    handleTitleTask(model.day);
                  } else {
                    _appToDoHomeCubit.getTaskByMatchingEmail(
                        email: widget.email);
                    handleTitleTask('...');
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget itemTitle() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder<AppToDoHomeCubit, AppToDoHomeState>(
              builder: (_, AppToDoHomeState state) {
            return itemDay();
          }),
          GestureDetector(
            onTap: () {
              handleItemClickAddTask();
            },
            child: Container(
              height: 50,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: Colors.deepPurpleAccent,
              ),
              child: const Center(
                child: Text(
                  addTask,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> handleItemClickAddTask() async {
    await GoRouter.of(context).pushNamed(
      routerNameAddTask,
    );
    _appToDoHomeCubit.getTaskByMatchingEmail(email: widget.email);
  }

  Future<void> handleItemClickEdit(TaskEntity? taskEntity) async {
    await GoRouter.of(context).pushNamed(
      routerNameEditTask,
      extra: {'taskEntity': taskEntity},
    );

    _appToDoHomeCubit.getTaskByMatchingEmail(email: widget.email);
  }

  Widget itemDay() {
    final String date = dateSelected ?? '...';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date,
          style: const TextStyle(
              color: Colors.grey, fontSize: 23, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 4,
        ),
        const Text(day,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget itemAvatar() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
              onTap: () {
                _appToDoHomeCubit.deleteBoxTask();
              },
              child: Image.asset(moon)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(360),
                child: Image.asset(
                  google,
                  fit: BoxFit.fill,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _appToDoHomeCubit.handleLogOut(context);
                },
                child: Image.asset(dots),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context, TaskEntity? taskEntity) {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (BuildContext buildContext) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: Column(
            children: [
              Utils.instance.sizeBoxHeight(16),
              GestureDetector(
                  onTap: () {
                    _appToDoHomeCubit.updateTaskStatus(taskEntity, true);
                  },
                  child: itemDetailBottomSheet(
                      text: taskCompleted,
                      images: tick,
                      color: taskEntity?.status == true
                          ? Colors.lightBlue
                          : Colors.deepPurpleAccent,
                      colorTitle: taskEntity?.status == true
                          ? Colors.black
                          : Colors.white)),
              Utils.instance.sizeBoxHeight(16),
              GestureDetector(
                onTap: () async {
                  await _appToDoHomeCubit.deleteDataTask(taskEntity!);
                },
                child: itemDetailBottomSheet(
                    text: deleteTask,
                    images: trash,
                    color: Colors.redAccent,
                    colorTitle: Colors.white),
              ),
              Utils.instance.sizeBoxHeight(16),
              GestureDetector(
                onTap: () {
                  handleItemClickEdit(taskEntity);
                  Utils.instance.popBackStack(context);
                },
                child: itemDetailBottomSheet(
                    text: editTask,
                    images: pen,
                    color: Colors.green,
                    colorTitle: Colors.white),
              ),
              Utils.instance.sizeBoxHeight(10),
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child:
                      itemDetailBottomSheet(text: close, images: closeImage)),
            ],
          ),
        );
      },
    );
  }

  Widget itemDetailBottomSheet(
      {String? text, String? images, Color? color, Color? colorTitle}) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey),
        color: color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            images ?? '',
            color: colorTitle,
          ),
          Text(
            text ?? '',
            style: TextStyle(fontSize: 20, color: colorTitle),
          ),
        ],
      ),
    );
  }

  void _handleListener(AppToDoHomeState state) {
    if (state is DeleteAllTask) {
      Utils.instance.showToast('xoa thanh cong');
      _appToDoHomeCubit.getTaskByMatchingEmail(email: widget.email);
    }

    if (state is DeleteTask) {
      Navigator.pop(context);
      _appToDoHomeCubit.getTaskByMatchingEmail(email: widget.email);
    }

    if (state is UpdateTaskStatus) {
      Navigator.pop(context);
      _appToDoHomeCubit.getTaskByMatchingEmail(email: widget.email);
    }
  }

  void handleTitleTask(String title) {
    dateSelected = title;
  }
}
