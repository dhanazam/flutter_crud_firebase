import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/app/presentation/pages/pages.dart';

class AppRouter {
  static const String initialRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String errorRoute = '/error';

  static Route<dynamic> onGenerateRouted(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case initialRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const SplashScreen();
          },
        );
      case loginRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const LoginScreen();
          },
        );
      case registerRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const RegisterScreen();
          },
        );
      case homeRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const HomeScreen();
          },
        );
      case errorRoute:
        final List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return ErrorScreen(
                errorType: args[0] as String, errorMessage: args[1] as String);
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
