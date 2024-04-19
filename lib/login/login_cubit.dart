import 'package:app_to_do/entity/user_entity.dart';
import 'package:app_to_do/login/login_state.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  // bool selected = false;

  void checkEmpty({
    String email = '',
    String password = '',
  }) {
    if (email.isEmpty) {
      emit(LoginCheckIsEmptyEmail());
      return;
    }
    if (password.isEmpty) {
      emit(LoginCheckIsEmptyPassword());

      return;
    }
  }

  void checkedAllTextFlied({
    String email = '',
    String password = '',
  }) {
    final bool isEmail = EmailValidator.validate(email);
    final bool isPassword = password.length > 6 && password.length < 12;

    if (!isEmail) {
      emit(ValidateEmailState());
      return;
    }
    if (!isPassword) {
      emit(ValidatePasswordState());
      return;
    }
  }

  Future<void> checkedLogin({
    required String email,
    required String password,
    bool? rememberMe = false,
  }) async {
    final Box<UserEntity> box = await Hive.openBox<UserEntity>('user');
    final UserEntity entity = box.values.firstWhere(
        (UserEntity entity) =>
            entity.email == email && entity.password == password,
        orElse: () => UserEntity());

    if (entity.email?.isNotEmpty == true &&
        entity.password?.isNotEmpty == true) {
      if (rememberMe == true) {
        await saveRememberMe(email);
      }
      emit(LoginSuccessState());
    } else {
      emit(LoginErrorState());
    }
  }

  Future<void> checkRememberMe() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('rememberMe') ?? false;
    String email = prefs.getString('email') ?? '';

    if (rememberMe) {
      emit(Authenticated(email: email));
    }
  }

  Future<void> saveRememberMe(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', true);
    await prefs.setString('email', email);
  }

  void checkBox(bool? value) {
    emit(CheckBoxState(isSelected: value));
  }
}
