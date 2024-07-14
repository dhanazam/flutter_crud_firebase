import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crud_firebase/app/presentation/styles/styles.dart';
import 'package:flutter_crud_firebase/app/router/app_route_config.dart';
import 'package:flutter_crud_firebase/env.dart';
import 'package:flutter_crud_firebase/firebase_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppLocalizationBloc(),
      child: Builder(
        builder: (context) {
          final currentLanguage =
              context.watch<AppLocalizationBloc>().state.appLanguage;
          return MaterialApp(
            title: Environments.appName,
            initialRoute: AppRouter.initialRoute,
            onGenerateRoute: AppRouter.onGenerateRouted,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
            ],
            supportedLocales: Environments.supportedLanguages,
            locale: Locale(currentLanguage),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
