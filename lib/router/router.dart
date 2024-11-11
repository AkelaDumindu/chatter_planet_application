import 'package:chatter_planet_application/models/user_model.dart';
import 'package:chatter_planet_application/views/auth_view/login.dart';
import 'package:chatter_planet_application/views/auth_view/register.dart';
import 'package:chatter_planet_application/views/main_screen.dart';
import 'package:chatter_planet_application/views/main_screens/single_user.dart';
import 'package:chatter_planet_application/views/responsive/mobile_layout.dart';
import 'package:chatter_planet_application/views/responsive/responsive_layout.dart';
import 'package:chatter_planet_application/views/responsive/web_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouterClass {
  final router = GoRouter(
      initialLocation: "/",
      errorPageBuilder: (context, state) {
        return const MaterialPage(
            child: Scaffold(
          body: Center(
            child: Text("This Page is not Found!"),
          ),
        ));
      },
      routes: [
        GoRoute(
          path: "/",
          name: "nav_layout",
          builder: (context, state) {
            return ResponsiveScreenLayout(
              mobileScreenLayout: Login(),
              webScreenLayout: const WebScreenLayout(),
            );
          },
        ),
        GoRoute(
          path: "/register",
          name: "register",
          builder: (context, state) {
            return const Register();
          },
        ),
        GoRoute(
          path: "/login",
          name: "login",
          builder: (context, state) {
            return Login();
          },
        ),
        GoRoute(
          path: "/main-screen",
          name: "main-screen",
          builder: (context, state) {
            return MainScreen();
          },
        ),
        GoRoute(
          name: "profile-screen",
          path: "/profile-screen",
          builder: (context, state) {
            final UserModel user = state.extra as UserModel;
            return SingleUser(
              user: user,
            );
          },
        ),
      ]);
}
