import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/app/presentation/pages/pages.dart';
import 'package:authentication_repository/authentication_repository.dart';

class AppRouter {
  static const String initialRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String addNewPostRoute = '/add_new_post';
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
      case addNewPostRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        return MaterialPageRoute(builder: (context) {
          return NewPostScreen(
            action: args[0].toString(),
            postModel: Post(),
          );
        });
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
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${routeSettings.name}'),
            ),
          ),
        );
    }
  }
}
