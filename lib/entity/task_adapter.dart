import 'package:app_to_do/entity/task_entity.dart';
import 'package:hive/hive.dart';


class TaskAdapter extends TypeAdapter<TaskEntity> {
  @override
  final int typeId = 1;

  @override
  TaskEntity read(BinaryReader reader) {
    //note: theo thu tu
    return TaskEntity()
      ..title = reader.readString()
      ..note = reader.readString()
      ..date = reader.readString()
      ..startTime = reader.readString()
      ..endTime = reader.readString()
      ..remind = reader.readString()
      ..repeat = reader.readString()
      ..color = reader.readInt()
      ..email = reader.readString()
      ..status = reader.readBool()
      ..image = reader.readString();
  }

  @override
  void write(BinaryWriter writer, TaskEntity task) {
    //note: theo thu tu
    writer.writeString(task.title ?? '');
    writer.writeString(task.note ?? '');
    writer.writeString(task.date ?? '');
    writer.writeString(task.startTime ?? '');
    writer.writeString(task.endTime ?? '');
    writer.writeString(task.remind ?? '');
    writer.writeString(task.repeat ?? '');
    writer.writeInt(task.color ?? 0);
    writer.writeString(task.email ?? '');
    writer.writeBool(task.status);
    writer.writeString(task.image ?? '');
  }
}
