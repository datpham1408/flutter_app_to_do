import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

class Utils {
  //design pattern SINGLETON
  static final Utils _instance = Utils._internal();

  static Utils get instance => _instance;

  Utils._internal();

  void showLoading([String? content]) {
    EasyLoading.show(status: content);
  }

  void hideLoading() {
    EasyLoading.dismiss();
  }

  Widget sizeBoxHeight(double? height) {
    return SizedBox(
      height: height,
    );
  }

  Widget sizeBoxWidth(double? width) {
    return SizedBox(
      width: width,
    );
  }

  void showToast(String? content) {
    EasyLoading.showToast(content ?? '');
  }

  Future<void> pushName(BuildContext context, String name) async {
    await GoRouter.of(context).pushNamed(name);
  }

  void goName(BuildContext context, String name) {
    GoRouter.of(context).goNamed(name);
  }

  void popBackStack(BuildContext context){
    Navigator.pop(context);
  }
}
