import 'package:app_to_do/login/login_cubit.dart';
import 'package:app_to_do/login/login_state.dart';
import 'package:app_to_do/main.dart';
import 'package:app_to_do/router/route_constant.dart';
import 'package:app_to_do/utils/string.dart';
import 'package:app_to_do/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController textEditingControllerEmail =
      TextEditingController();
  final TextEditingController textEditingControllerPassword =
      TextEditingController();
  final LoginCubit _loginCubit = getIt.get<LoginCubit>();
  bool isRememberLogin = false;

  @override
  void initState() {
    super.initState();
    //research them ve addPostFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loginCubit.checkRememberMe();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: BlocProvider<LoginCubit>(
        create: (_) => _loginCubit,
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (_, LoginState state) {
            _handleListener(state);
          },
          builder: (_, LoginState state) {
            return itemBody();
          },
        ),
      ),
    ));
  }

  Widget itemBody() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          itemDetailBody(
              text: email, textEditingController: textEditingControllerEmail),
          itemDetailBody(
              text: pass,
              textEditingController: textEditingControllerPassword,
              obscureText: true),
          GestureDetector(
              onTap: () {
                handleItemClickRegister();
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(registerAccount),
              )),
          Utils.instance.sizeBoxHeight(16),
          BlocBuilder<LoginCubit, LoginState>(buildWhen: (_, LoginState state) {
            return state is CheckBoxState;
          }, builder: (_, LoginState state) {
            if (state is CheckBoxState) {
              return itemCheckBox(state: state);
            }
            return itemCheckBox();
          }),
          // itemCheckBox(),
          Utils.instance.sizeBoxHeight(16),
          itemButton(),
        ],
      ),
    );
  }

  Widget itemCheckBox({CheckBoxState? state}) {
    return Row(
      children: [
        Checkbox(
            tristate: true,
            value: state?.isSelected ?? false,
            onChanged: (bool? value) {
              isRememberLogin = value ?? false;
              _loginCubit.checkBox(value);
            }),
        const Text(ghiNhoDangNhap),
      ],
    );
  }

  void handleItemClickRegister() {
    GoRouter.of(context).pushNamed(
      routerNameRegister,
    );
  }

  Widget itemButton() {
    return ElevatedButton(
      onPressed: () {
        _loginCubit.checkEmpty(
            email: textEditingControllerEmail.text,
            password: textEditingControllerPassword.text);
        _loginCubit.checkedAllTextFlied(
            email: textEditingControllerEmail.text,
            password: textEditingControllerPassword.text);
        _loginCubit.checkedLogin(
          email: textEditingControllerEmail.text,
          password: textEditingControllerPassword.text,
          rememberMe: isRememberLogin,
        );
      },
      child: const Text(login),
    );
  }

  Widget itemDetailBody(
      {String text = '',
      TextEditingController? textEditingController,
      bool? obscureText}) {
    return Column(
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
    );

  }

  void _handleListener(LoginState state) {
    if (state is LoginCheckIsEmptyEmail) {
      Utils.instance.showToast(emailEmpty);
      return;
    }
    if (state is LoginCheckIsEmptyPassword) {
      Utils.instance.showToast(passwordEmpty);
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
    if (state is LoginSuccessState) {
      handleItemClickHome(textEditingControllerEmail.text);
      return;
    }
    if (state is LoginErrorState) {
      Utils.instance.showToast(userEmpty);
      return;
    }
    if (state is Authenticated) {
      String email = state.email;
      handleItemClickHome(email);
      return;
    }
  }

  void handleItemClickHome(String? email) {
    if (email != null) {
      GoRouter.of(context).pushNamed(
        routerNameAppToDoHome,
        extra: {'email': email},
      );
    }
  }


}
