import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crud_firebase/app/core/observer.dart';
import 'package:flutter_crud_firebase/app/presentation/styles/styles.dart';
import 'package:flutter_crud_firebase/app/router/app_route_config.dart';
import 'package:flutter_crud_firebase/env.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  Bloc.observer = const AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()..add(ThemeInitialEvent())),
        BlocProvider(
            create: (_) =>
                AppLocalizationBloc()..add(AppLocalizationInitialEvent()))
      ],
      child: Builder(
        builder: (context) {
          final isDarkTheme = context.watch<ThemeBloc>().state.isDarkTheme;
          final currentLanguage =
              context.watch<AppLocalizationBloc>().state.appLanguage;
          return MaterialApp(
            title: Environments.appName,
            initialRoute: AppRouter.initialRoute,
            onGenerateRoute: AppRouter.onGenerateRouted,
            localizationsDelegates: const [
              AppLocalizations.delegate, // Add this line
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: Environments.supportedLanguages,
            locale: Locale(currentLanguage),
            debugShowCheckedModeBanner: false,
            theme: isDarkTheme
                ? appThemeData[AppTheme.dark]
                : appThemeData[AppTheme.light],
          );
        },
      ),
    );
  }
}
