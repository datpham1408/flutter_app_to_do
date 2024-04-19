import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class TaskEntity extends HiveObject {
  @HiveField(0)
  String? title;

  @HiveField(1)
  String? note;

  @HiveField(2)
  String? date;

  @HiveField(3)
  String? startTime;

  @HiveField(4)
  String? endTime;

  @HiveField(5)
  String? remind;

  @HiveField(6)
  String? repeat;

  @HiveField(6)
  int? color;

  @HiveField(7)
  String? email;

  @HiveField(8)
  bool status = false;

  @HiveField(9)
  String? image;
}
