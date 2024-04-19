import 'package:app_to_do/apptodo/app_to_do_state.dart';
import 'package:app_to_do/entity/task_entity.dart';
import 'package:app_to_do/resources/hive_key.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppToDoCubit extends Cubit<AppToDoState> {
  AppToDoCubit() : super(AppToDoState());

  bool selected = false;
  ImagePicker _imagePicker = ImagePicker();

  void checkEmpty({
    String title = '',
    String note = '',
    String date = '',
    String startTime = '',
    String endTime = '',
    String remind = '',
    String repeat = '',
  }) {
    if (title.isEmpty) {
      emit(AppToDoCheckIsEmptyTitle());
      return;
    }
    if (note.isEmpty) {
      emit(AppToDoCheckIsEmptyNote());
      return;
    }
    if (date.isEmpty) {
      emit(AppToDoCheckIsEmptyDate());
      return;
    }
    if (startTime.isEmpty) {
      emit(AppToDoCheckIsEmptyStartTime());
      return;
    }
    if (endTime.isEmpty) {
      emit(AppToDoCheckIsEmptyEndTime());
      return;
    }
    if (remind.isEmpty) {
      emit(AppToDoCheckIsEmptyRemind());
      return;
    }
    if (repeat.isEmpty) {
      emit(AppToDoCheckIsEmptyRepeat());
      return;
    }
  }

  Future<void> saveEditDataTask({TaskEntity? taskEntity}) async {
    taskEntity?.save();

    emit(EditSuccessTaskState());
  }

  Future<void> pickImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      emit(PickImagesState(imagePicker: pickedImage.path));
    }
  }

  Future<void> photoCamera() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      emit(PickImagesState(imagePicker: pickedImage.path));
    }
  }

  void updateImage(String imageUrl) {
    emit(PickImagesState(imagePicker: imageUrl));
  }

  Future<void> saveDataTask(
      {String title = '',
      String note = '',
      String date = '',
      String startTime = '',
      String endTime = '',
      String remind = '',
      String repeat = '',
      int? color,
      String image = ''}) async {
    final box = await Hive.openBox<TaskEntity>(HiveKey.task);
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final String? email = sharedPreferences.getString('email');
    final task = TaskEntity()
      ..title = title
      ..note = note
      ..date = date
      ..startTime = startTime
      ..endTime = endTime
      ..remind = remind
      ..repeat = repeat
      ..color = color
      ..email = email
      ..image = image;

    await box.add(task);

    emit(SuccessTask(
        title: title,
        note: note,
        date: date,
        startTime: startTime,
        endTime: endTime,
        remind: remind,
        repeat: repeat,
        color: color ?? 0,
        image: image));
  }

  void updateSelectedColor() {
    selected = !selected;
    emit(UpdateColor(selected: selected));
  }

  void updateDate(String time) {
    emit(UpdateTextDate(text: time));
  }

  void updateStartTime(String time) {
    emit(UpdateTextStartTime(text: time));
  }

  void updateEndTime(String time) {
    emit(UpdateTextEndTime(text: time));
  }
}
