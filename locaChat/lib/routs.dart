import 'package:locachat/common/widgets/bottom_bar.dart';
import 'package:locachat/features/auth/screens/sign_in_screen.dart';
import 'package:locachat/features/auth/screens/sign_up_screen.dart';
import 'package:locachat/features/chat/screen/chat_screen.dart';
import 'package:locachat/features/home/screens/home_page.dart';
import 'package:locachat/features/splash/splash_screen.dart';
import 'package:locachat/routs_name.dart';

import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RoutsName.signUp:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SignUpScreen());
      // case RoutsName.bottombar:
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => const BottomBar());
      case RoutsName.splashScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
      // case RoutsName.chatScreen:
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => const ChatScreen());
      case RoutsName.signIn:
        return MaterialPageRoute(
            builder: (BuildContext context) => SignInScreen());
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(child: Text('no routes define')),
          );
        });
    }
  }
}
