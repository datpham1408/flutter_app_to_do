class RegisterState {}

class RegisterCheckIsEmptyYourName extends RegisterState {}

class RegisterCheckIsEmptyEmail extends RegisterState {}

class RegisterCheckIsEmptyPhone extends RegisterState {}

class RegisterCheckIsEmptyAge extends RegisterState {}

class RegisterCheckIsEmptyPassword extends RegisterState {}

class RegisterCheckIsEmptyConfirmPassword extends RegisterState {}

class ValidateEmailState extends RegisterState {}

class ValidateYourNameState extends RegisterState {}

class ValidatePhoneState extends RegisterState {}

class ValidateConfirmPasswordState extends RegisterState {}

class CheckValidateConfirmPasswordStateIsTheSamePassword extends RegisterState {}

class ValidatePasswordState extends RegisterState {}

class ValidateSuccessState extends RegisterState {
  final String email;
  final String yourName;
  final String phone;
  final String confirmPassword;
  final String pass;
  final String age;

  ValidateSuccessState(
      {required this.email,
      required this.pass,
      required this.confirmPassword,
      required this.yourName,
      required this.phone,
      required this.age});
}
