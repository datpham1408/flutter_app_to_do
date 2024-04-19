import 'dart:io';

import 'package:app_to_do/apptodo/app_to_do_cubit.dart';
import 'package:app_to_do/apptodo/app_to_do_state.dart';
import 'package:app_to_do/entity/task_entity.dart';
import 'package:app_to_do/main.dart';
import 'package:app_to_do/model/color_model.dart';
import 'package:app_to_do/router/route_constant.dart';
import 'package:app_to_do/utils/image.dart';
import 'package:app_to_do/utils/string.dart';
import 'package:app_to_do/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';


class AddTaskV2Screen extends StatefulWidget {
  //taskEntity co the bi null
  TaskEntity? taskEntity;

  AddTaskV2Screen({super.key, this.taskEntity});

  @override
  State<AddTaskV2Screen> createState() => _AddTaskV2ScreenState();
}

class _AddTaskV2ScreenState extends State<AddTaskV2Screen> {
  final TextEditingController _textEditingControllerTitle =
      TextEditingController();
  final TextEditingController _textEditingControllerNote =
      TextEditingController();
  final TextEditingController _textEditingControllerRemind =
      TextEditingController();
  final TextEditingController _textEditingControllerRepeat =
      TextEditingController();
  int? selectedColor;
  final List<ColorModel> _colorList = <ColorModel>[
    ColorModel(color: Colors.deepPurpleAccent.value, selected: true),
    ColorModel(color: Colors.redAccent.value),
    ColorModel(color: Colors.orangeAccent.value),
    ColorModel(color: Colors.green.value),
  ];
  String? image;

  final AppToDoCubit _appToDoCubit = getIt.get<AppToDoCubit>();

  String? timeDate;

  String? startTime;

  String? endTime;
  String? datePicker = '10/1/2024';
  String? hintStartTime = '7:41 AM';
  String? hintEndTime = '9:41 AM ';
  String? enterYourTitle = 'Enter your title';
  String? enterYourNote = 'Enter Note';
  String? hintRemind = '5 minutes';
  String? hintRepeat = ' none';
  String pickImage = 'Pick Image';

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: BlocProvider<AppToDoCubit>(
        create: (_) => _appToDoCubit,
        child: BlocConsumer<AppToDoCubit, AppToDoState>(
          listener: (_, AppToDoState state) {
            _handleListener(state);
          },
          builder: (_, AppToDoState state) {
            return SingleChildScrollView(child: itemBody());
          },
        ),
      ),
    ));
  }

  void initData() {
    nowDate();
    if (widget.taskEntity != null) {
      datePicker = widget.taskEntity?.date ?? '';
      hintStartTime = widget.taskEntity?.startTime ?? '';
      hintEndTime = widget.taskEntity?.endTime ?? '';
      enterYourTitle = widget.taskEntity?.title ?? '';
      enterYourNote = widget.taskEntity?.note ?? '';
      hintRemind = widget.taskEntity?.remind ?? '';
      hintRepeat = widget.taskEntity?.repeat ?? '';
      selectedColor = widget.taskEntity?.color;
      _appToDoCubit.updateImage(widget.taskEntity?.image ?? '');
    }
    selectedColor = _colorList[0].color;
  }

  void handleEditTask(TaskEntity? taskEntity) {
    if (_textEditingControllerTitle.text.isNotEmpty) {
      taskEntity?.title = _textEditingControllerTitle.text;
    }
    if (_textEditingControllerNote.text.isNotEmpty) {
      taskEntity?.note = _textEditingControllerNote.text;
    }
    if (_textEditingControllerRepeat.text.isNotEmpty) {
      taskEntity?.repeat = _textEditingControllerRepeat.text;
    }
    if (_textEditingControllerRemind.text.isNotEmpty) {
      taskEntity?.remind = _textEditingControllerRemind.text;
    }

    taskEntity?.date = timeDate ?? taskEntity.date;
    taskEntity?.startTime = startTime ?? taskEntity.startTime;
    taskEntity?.endTime = endTime ?? taskEntity.endTime;
    taskEntity?.color = selectedColor;
    taskEntity?.image = image;

    _appToDoCubit.saveEditDataTask(taskEntity: taskEntity);
  }

  void nowDate() {
    final DateTime time = DateTime.now();
    final String timeFormatter = DateFormat('dd/MM/yyyy').format(time);
    datePicker = timeFormatter;
  }

  Future<void> chooseDate() async {
    final DateTime? time = await showDatePicker(
        context: context,
        // ngay hien tai
        initialDate: DateTime.now(),
        // ngay dau tien
        firstDate: DateTime(2000, 1, 1),
        //ngay cuoi cung
        lastDate: DateTime(2025, 12, 31));

    final String dateFormat = DateFormat('dd/MM/yyyy').format(time!);
    _appToDoCubit.updateDate(dateFormat);
  }

  Future<void> chooseStartTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    final DateFormat customFormat = DateFormat('HH:mm');
    final String? formattedTime = timeOfDay != null
        ? customFormat
            .format(DateTime(0, 0, 0, timeOfDay.hour, timeOfDay.minute))
        : null;
    _appToDoCubit.updateStartTime(formattedTime ?? '');
  }

  Future<void> chooseEndTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    final DateFormat customFormat = DateFormat('HH:mm');
    final String? formattedTime = timeOfDay != null
        ? customFormat
            .format(DateTime(0, 0, 0, timeOfDay.hour, timeOfDay.minute))
        : null;
    _appToDoCubit.updateEndTime(formattedTime ?? '');
  }

  Widget itemBody() {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          itemAvatar(),
          itemAddTask(),
        ],
      ),
    );
  }

  Widget itemAvatar() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(360),
            child: Image.asset(
              google,
              fit: BoxFit.fill,
            ),
          ),
          Image.asset(
            dots,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget itemAddTask() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.taskEntity != null ? editTask : addTask,
            style: const TextStyle(
                color: Colors.white, fontSize: 23, fontWeight: FontWeight.w500),
          ),
          Utils.instance.sizeBoxHeight(24),
          itemTextField(
              title, _textEditingControllerTitle, enterYourTitle ?? ''),
          Utils.instance.sizeBoxHeight(16),
          itemTextField(note, _textEditingControllerNote, enterYourNote ?? ''),
          Utils.instance.sizeBoxHeight(16),
          BlocBuilder<AppToDoCubit, AppToDoState>(
              buildWhen: (_, AppToDoState state) {
            return state is UpdateTextDate;
          }, builder: (_, AppToDoState state) {
            if (state is UpdateTextDate) {
              timeDate = state.text;
              return itemTextDatePicker(
                  text: dateName,
                  textSelected: datePicker,
                  time: timeDate,
                  image: calendar,
                  onTap: () {
                    chooseDate();
                  },
                  state: state);
            }
            return itemTextDatePicker(
                text: dateName,
                textSelected: datePicker,
                time: timeDate,
                image: calendar,
                onTap: () {
                  chooseDate();
                });
          }),
          Utils.instance.sizeBoxHeight(16),
          itemTime(),
          Utils.instance.sizeBoxHeight(16),
          itemTextFieldIcon(
              text: remind,
              hint: hintRemind,
              textEditingController: _textEditingControllerRemind,
              image: down,
              onTap: () {}),
          Utils.instance.sizeBoxHeight(16),
          itemTextFieldIcon(
              text: repeat,
              hint: hintRepeat,
              textEditingController: _textEditingControllerRepeat,
              image: down,
              onTap: () {}),
          Utils.instance.sizeBoxHeight(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              itemColor(color),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.deepPurpleAccent,
                ),
                child: GestureDetector(
                  onTap: () {
                    widget.taskEntity != null
                        ? handleEditTask(widget.taskEntity)
                        : _appToDoCubit.saveDataTask(
                            title: _textEditingControllerTitle.text,
                            note: _textEditingControllerNote.text,
                            date: timeDate ?? '',
                            startTime: startTime ?? '',
                            endTime: endTime ?? '',
                            remind: _textEditingControllerRemind.text,
                            repeat: _textEditingControllerRepeat.text,
                            color: selectedColor,
                            image: image ?? '');
                  },
                  child: Text(
                    widget.taskEntity != null ? editTask : createTask,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          Column(
            children: [
              BlocBuilder<AppToDoCubit, AppToDoState>(
                  builder: (_, AppToDoState state) {
                if (state is PickImagesState) {
                  image = state.imagePicker;
                  return widget.taskEntity != null
                      ? Image.file(
                          File(image ?? ''),
                          height: 200,
                        )
                      : const Text(
                          'No Image Selected',
                          style: TextStyle(color: Colors.white),
                        );
                }
                return const Text(
                  'No Image Selected',
                  style: TextStyle(color: Colors.white),
                );
              }),
              GestureDetector(
                onTap: () {
                  showBottomSheet(context);
                },
                child: Text(
                  widget.taskEntity != null ? pickImage : pickImage,
                  style:
                      const TextStyle(color: Colors.tealAccent, fontSize: 20),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isDismissible: true,
      context: context,
      builder: (BuildContext buildContext) {
        return FractionallySizedBox(
            heightFactor: 0.4,
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      _appToDoCubit.photoCamera();
                      Navigator.pop(context);
                    },
                    child: const Padding(
                        padding: EdgeInsets.all(8), child: Text('Camera'))),
                Utils.instance.sizeBoxWidth(16),
                GestureDetector(
                    onTap: () {
                      _appToDoCubit.pickImage();
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Album'),
                    )),
              ],
            ));
      },
    );
  }

  void handleItemClickHome() {
    GoRouter.of(context).pushNamed(
      routerNameAppToDoHome
    );
  }

  Widget itemColor(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 17),
        ),
        Utils.instance.sizeBoxHeight(4),
        Row(
          children: [
            itemDetailColor(_colorList[0]),
            Utils.instance.sizeBoxWidth(8),
            itemDetailColor(_colorList[1]),
            Utils.instance.sizeBoxWidth(8),
            itemDetailColor(_colorList[2]),
            Utils.instance.sizeBoxWidth(8),
            itemDetailColor(_colorList[3]),
          ],
        ),
      ],
    );
  }

  Widget itemDetailColor(ColorModel colorModel) {
    return GestureDetector(
      onTap: () {
        // update lai color cua model click truoc do
        removeSelectedColor();

        selectedColor = colorModel.color;
        colorModel.selected = true;
        //goi cubit updateColor
        _appToDoCubit.updateSelectedColor();
      },
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            border: colorModel.selected
                ? Border.all(color: Colors.white, width: 2)
                : null,
            borderRadius: BorderRadius.circular(360),
            color: Color(colorModel.color)),
      ),
    );
  }

  Widget itemTime() {
    return Row(
      children: [
        BlocBuilder<AppToDoCubit, AppToDoState>(
            buildWhen: (_, AppToDoState state) {
          return state is UpdateTextStartTime;
        }, builder: (_, AppToDoState state) {
          if (state is UpdateTextStartTime) {
            startTime = state.text;
            return Flexible(
                child: itemTextDatePicker(
                    text: startTimeString,
                    textSelected: hintStartTime,
                    time: startTime,
                    image: clock,
                    onTap: () async {
                      await chooseStartTime(context);
                    },
                    state: state));
          }
          return Flexible(
            child: itemTextDatePicker(
                text: startTimeString,
                textSelected: hintStartTime,
                time: startTime,
                image: clock,
                onTap: () async {
                  await chooseStartTime(context);
                }),
          );
        }),
        Utils.instance.sizeBoxWidth(24),
        BlocBuilder<AppToDoCubit, AppToDoState>(
            buildWhen: (_, AppToDoState state) {
          return state is UpdateTextEndTime;
        }, builder: (_, AppToDoState state) {
          if (state is UpdateTextEndTime) {
            endTime = state.text;
            return Flexible(
                child: itemTextDatePicker(
                    text: endTimeString,
                    textSelected: hintEndTime,
                    time: endTime,
                    image: clock,
                    onTap: () async {
                      await chooseEndTime(context);
                    },
                    state: state));
          }
          return Flexible(
            child: itemTextDatePicker(
                text: endTimeString,
                textSelected: hintEndTime,
                time: endTime,
                image: clock,
                onTap: () async {
                  await chooseEndTime(context);
                }),
          );
        }),
      ],
    );
  }

  Widget itemTextField(
      String text, TextEditingController textEditingController, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 17),
        ),
        Utils.instance.sizeBoxHeight(4),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white38),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle: const TextStyle(color: Colors.white)),
            style: const TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget itemTextDatePicker(
      {String? text,
      String? textSelected,
      String? time,
      String? image,
      VoidCallback? onTap,
      AppToDoState? state}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text ?? '',
          style: const TextStyle(color: Colors.white, fontSize: 17),
        ),
        Utils.instance.sizeBoxHeight(4),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white38),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  time ?? textSelected!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: Image.asset(
                  image ?? '',
                  color: Colors.white,
                  height: 30,
                  width: 30,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget itemTextFieldIcon({
    String? text,
    String? hint,
    TextEditingController? textEditingController,
    String? image,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text ?? '',
          style: const TextStyle(color: Colors.white, fontSize: 17),
        ),
        Utils.instance.sizeBoxHeight(4),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white38),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Flexible(
                  child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: const TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
              )),
              GestureDetector(
                onTap: onTap,
                child: Image.asset(
                  image ?? '',
                  color: Colors.white,
                  height: 30,
                  width: 30,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _handleListener(AppToDoState state) {
    if (state is AppToDoCheckIsEmptyTitle) {
      Utils.instance.showToast('title không được để trống');
      return;
    }
    if (state is AppToDoCheckIsEmptyNote) {
      Utils.instance.showToast('note không được để trống');
      return;
    }
    if (state is AppToDoCheckIsEmptyDate) {
      Utils.instance.showToast('date không được để trống');
      return;
    }
    if (state is AppToDoCheckIsEmptyStartTime) {
      Utils.instance.showToast('startTime không được để trống');
      return;
    }
    if (state is AppToDoCheckIsEmptyEndTime) {
      Utils.instance.showToast('endTime không được để trống');
      return;
    }
    if (state is AppToDoCheckIsEmptyRemind) {
      Utils.instance.showToast('remind không được để trống');
      return;
    }
    if (state is AppToDoCheckIsEmptyRepeat) {
      Utils.instance.showToast('repeat không được để trống');
      return;
    }

    if (state is SuccessTask) {
      Utils.instance.showToast('thanh cong');
      handleItemClickHome();
    }
    if (state is EditSuccessTaskState) {
      Utils.instance.showToast('thanh cong');
      handleItemClickHome();
    }
  }

  void removeSelectedColor() {
    final ColorModel colorModel = _colorList.firstWhere(
        (ColorModel colorModel) => colorModel.color == selectedColor);

    colorModel.selected = false;
  }
}
