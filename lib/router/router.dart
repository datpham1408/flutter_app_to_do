import 'package:app_to_do/apptodo/add_task_v2_screen.dart';
import 'package:app_to_do/apptodo/app_to_to_home_screen.dart';
import 'package:app_to_do/login/login_screen.dart';
import 'package:app_to_do/register/register_screen.dart';
import 'package:app_to_do/router/route_constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter routerMyApp = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),

    GoRoute(
      path: routerPathRegister,
      name: routerNameRegister,
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterScreen();
      },
    ),
    GoRoute(
      path: routerPathLogin,
      name: routerNameLogin,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: routerPathAddTask,
      name: routerNameAddTask,
      builder: (BuildContext context, GoRouterState state) {
        return AddTaskV2Screen();
      },
    ),
    GoRoute(
      path: routerPathEditTask,
      name: routerNameEditTask,
      builder: (BuildContext context, GoRouterState state) {
        final taskEntity =
            (state.extra as Map<String, dynamic>?)?['taskEntity'];
        return AddTaskV2Screen(
          taskEntity: taskEntity,
        );
      },
    ),
    GoRoute(
      path: routerPathAppToDoHome,
      name: routerNameAppToDoHome,
      builder: (BuildContext context, GoRouterState state) {
        final email = (state.extra as Map<String, String>?)?['email'];
        return AppToDoHomeScreen(
          email: email,
        );
      },
    ),
  ],
);
