import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/app/presentation/pages/pages.dart';

class AppRouter {
  static const String initialRoute = '/';
  static const String loginRoute = '/login';

  static Route<dynamic> onGenerateRouted(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case initialRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const LoginScreen();
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
