import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/app/presentation/pages/pages.dart';

class AppRouter {
  static const String initialRoute = '/';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';

  static Route<dynamic> onGenerateRouted(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case initialRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const LoginScreen();
          },
        );
      case homeRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const HomeScreen();
          },
        );
      default:
        return MaterialPageRoute(
          builder: (context) {
            return const Scaffold(
              body: Center(
                child: Text('Page not found'),
              ),
            );
          },
        );
    }
  }
}
