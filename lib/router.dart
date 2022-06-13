import 'package:ai_score/constants/route_constants.dart';
import 'package:ai_score/view/home_page.dart';
import 'package:ai_score/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesConstants.login:
        return MaterialPageRoute(
            builder: (_) => const LoginPage(), settings: settings);

      case RoutesConstants.home:
        return MaterialPageRoute(
            builder: (_) => const HomePage(), settings: settings);

      default:
        //return MaterialPageRoute(builder: (_) =>  Testing());
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
