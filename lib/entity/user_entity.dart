import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class UserEntity extends HiveObject {
  @HiveField(0)
  String? email;

  @HiveField(1)
   String? password;

  @HiveField(2)
   String? phone;

  @HiveField(3)
   String? age;

  @HiveField(4)
   String? fullName;
}
