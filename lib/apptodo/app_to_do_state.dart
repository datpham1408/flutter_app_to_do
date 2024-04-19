class AppToDoState {}

class SuccessTask extends AppToDoState {
  final String title;
  final String note;
  final String date;
  final String startTime;
  final String endTime;
  final String remind;
  final String repeat;
  final int color;
  final String image;

  SuccessTask(
      {required this.title,
      required this.repeat,
      required this.remind,
      required this.endTime,
      required this.startTime,
      required this.date,
      required this.note,
      required this.color,
      required this.image});
}

class AppToDoCheckIsEmptyTitle extends AppToDoState {}

class AppToDoCheckIsEmptyNote extends AppToDoState {}

class AppToDoCheckIsEmptyDate extends AppToDoState {}

class AppToDoCheckIsEmptyStartTime extends AppToDoState {}

class AppToDoCheckIsEmptyEndTime extends AppToDoState {}

class AppToDoCheckIsEmptyRemind extends AppToDoState {}

class AppToDoCheckIsEmptyRepeat extends AppToDoState {}

class AppToDoCheckIsEmptyColor extends AppToDoState {}

class EditSuccessTaskState extends AppToDoState {}

class UpdateColor extends AppToDoState {
  final bool selected;

  UpdateColor({required this.selected});
}

class UpdateTextDate extends AppToDoState {
  final String text;

  UpdateTextDate({required this.text});
}

class UpdateTextStartTime extends AppToDoState {
  final String text;

  UpdateTextStartTime({required this.text});
}

class UpdateTextEndTime extends AppToDoState {
  final String text;

  UpdateTextEndTime({required this.text});
}

class PickImagesState extends AppToDoState {
  final String imagePicker;

  PickImagesState({required this.imagePicker});
}

class PhotoCameraState extends AppToDoState {
  final String imagePicker;

  PhotoCameraState({required this.imagePicker});
}
