import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crud_firebase/app/bloc/app_bloc.dart';
import 'package:flutter_crud_firebase/app/presentation/styles/styles.dart';
import 'package:flutter_crud_firebase/app/router/app_route_config.dart';
import 'package:flutter_crud_firebase/env.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  const App(
      {super.key, required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeBloc()..add(ThemeInitialEvent())),
          BlocProvider(
              create: (_) =>
                  AppLocalizationBloc()..add(AppLocalizationInitialEvent())),
          BlocProvider(
              create: (_) =>
                  AppBloc(authenticationRepository: _authenticationRepository)),
        ],
        child: BlocListener<AppBloc, AppState>(
          listener: (context, state) {
            AppRouter.router.refresh();
          },
          child: const AppView(),
        ),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final isDarkTheme = context.watch<ThemeBloc>().state.isDarkTheme;
        final currentLanguage =
            context.watch<AppLocalizationBloc>().state.appLanguage;
        return MaterialApp.router(
          title: Environments.appName,
          routerDelegate: AppRouter.router.routerDelegate,
          routeInformationParser: AppRouter.router.routeInformationParser,
          routeInformationProvider: AppRouter.router.routeInformationProvider,
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
    );
  }
}
