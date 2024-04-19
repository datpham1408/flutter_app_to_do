import 'package:app_to_do/register/register_cubit.dart';
import 'package:app_to_do/register/register_state.dart';
import 'package:app_to_do/router/route_constant.dart';
import 'package:app_to_do/utils/string.dart';
import 'package:app_to_do/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _textEditingControllerEmail =
      TextEditingController();
  final TextEditingController _textEditingControllerName =
      TextEditingController();
  final TextEditingController _textEditingControllerAge =
      TextEditingController();
  final TextEditingController _textEditingControllerPass =
      TextEditingController();
  final TextEditingController _textEditingControllerConfirmPass =
      TextEditingController();
  final TextEditingController _textEditingControllerPhone =
      TextEditingController();
  final RegisterCubit _registerCubit = getIt.get<RegisterCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: BlocProvider<RegisterCubit>(
        create: (_) => _registerCubit,
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (_, RegisterState state) {
            _handleListener(state);
          },
          builder: (_, RegisterState state) {
            return SingleChildScrollView(child: itemBody());
          },
        ),
      ),
    ));
  }

  Widget itemBody() {
    return Column(
      children: [
        const Text(
          dangKi,
          style: TextStyle(fontSize: 30),
        ),
        itemTextFlied(text: email,textEditingController: _textEditingControllerEmail),
        itemTextFlied(text:fullName,textEditingController: _textEditingControllerName),
        itemTextFlied(text: age,textEditingController: _textEditingControllerAge),
        itemTextFlied(text: phone,textEditingController: _textEditingControllerPhone),
        itemTextFlied(text: pass,textEditingController: _textEditingControllerPass,obscureText: true),
        itemTextFlied(text: confirmPass,textEditingController: _textEditingControllerConfirmPass,obscureText: true),
         GestureDetector(
           onTap: (){
             handleItemClickLogin();
           },
             child:  const Padding(
               padding: EdgeInsets.all(8.0),
               child: Text(alreadyAccount),
             )),
        itemButton(),
      ],
    );
  }
  void handleItemClickLogin() {
    GoRouter.of(context).pushNamed(
      routerNameLogin,
    );
  }

  Widget itemButton() {
    return ElevatedButton(
      onPressed: () {
        _registerCubit.checkEmpty(
            email: _textEditingControllerEmail.text,
            yourName: _textEditingControllerName.text,
            password: _textEditingControllerPass.text,
            confirmPassword: _textEditingControllerConfirmPass.text,
            phone: _textEditingControllerPhone.text,
            age: _textEditingControllerAge.text);
        _registerCubit.checkedAllTextFlied(
            email: _textEditingControllerEmail.text,
            yourName: _textEditingControllerName.text,
            password: _textEditingControllerPass.text,
            confirmPassword: _textEditingControllerConfirmPass.text,
            phone: _textEditingControllerPhone.text,
            age: _textEditingControllerAge.text);
      },
      child: const Text(registerAccount),
    );
  }

  Widget itemTextFlied(
  { String text ='', TextEditingController? textEditingController,bool? obscureText}) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Utils.instance.sizeBoxHeight(4),
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: TextField(
              obscureText: obscureText ?? false,
              controller: textEditingController,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          )
        ],
      ),
    );
  }

  void _handleListener(RegisterState state) {
    if (state is RegisterCheckIsEmptyEmail) {
      Utils.instance.showToast(emailEmpty);
      return;
    }
    if (state is RegisterCheckIsEmptyYourName) {
      Utils.instance.showToast(fullNameEmpty);
      return;
    }
    if (state is RegisterCheckIsEmptyPassword) {
      Utils.instance.showToast(passwordEmpty);
      return;
    }
    if (state is RegisterCheckIsEmptyConfirmPassword) {
      Utils.instance.showToast(confirmEmpty);
      return;
    }
    if (state is RegisterCheckIsEmptyPhone) {
      Utils.instance.showToast(phoneEmpty);
      return;
    }
    if (state is RegisterCheckIsEmptyAge) {
      Utils.instance.showToast(ageEmpty);
      return;
    }
    if (state is ValidateEmailState) {
      Utils.instance.showToast(emailValidate);
      return;
    }
    if (state is ValidatePasswordState) {
      Utils.instance.showToast(passValidate);
      return;
    }
    if (state is ValidateConfirmPasswordState) {
      Utils.instance.showToast(confirmValidate);
      return;
    }
    if (state is ValidatePhoneState) {
      Utils.instance.showToast(phoneValidate);
      return;
    }
    if (state is ValidateYourNameState) {
      Utils.instance.showToast(fullNameValidate);
      return;
    }
    if (state is CheckValidateConfirmPasswordStateIsTheSamePassword) {
      Utils.instance.showToast(passSameConfirm);
      return;
    }
    if (state is ValidateSuccessState) {
      final String email = state.email;
      final String pass = state.pass;
      final String phone = state.phone;
      final String age = state.age;
      final String fullName = state.yourName;
      Utils.instance.showLoading();
      _registerCubit.saveLoginInfo(email:email,password: pass,phone: phone,age: age,fullName: fullName );
      Utils.instance.showToast('Dang ki thanh cong');
      Utils.instance.hideLoading();
      handleItemClickLogin();
    }
  }

}
