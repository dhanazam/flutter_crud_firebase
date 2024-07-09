import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/app/router/app_route_config.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      onGenerateRoute: AppRouter.onGenerateRouted,
    );
  }
}
