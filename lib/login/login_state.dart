class LoginState{}

class LoginCheckIsEmptyEmail extends LoginState {}

class LoginCheckIsEmptyPassword extends LoginState {}

class ValidateEmailState extends LoginState {}

class ValidatePasswordState extends LoginState {}

class LoginSuccessState extends LoginState{
}

class LoginErrorState extends LoginState{
}

class Authenticated extends LoginState{
  final String email;

  Authenticated({required this.email});
}



class CheckBoxState extends LoginState{
  final bool? isSelected;

  CheckBoxState({required this.isSelected});
}