import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crud_firebase/app/bloc/app_bloc.dart';
import 'package:flutter_crud_firebase/app/presentation/pages/pages.dart';
import 'package:go_router/go_router.dart';
import 'package:post_repository/post_repository.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeTabNavigatorKey = GlobalKey<NavigatorState>();
final _profileTabNavigatorKey = GlobalKey<NavigatorState>();

// on boarding;
const splashPath = '/';
const loginPath = '/login';
const registerPath = '/register';

// tab navigation;
const profilePath = '/profile';
const homePath = '/home';

// homePath;
const addNewPostPath = 'add-new-post';

Page getPage({
  required Widget child,
  required GoRouterState state,
}) {
  return MaterialPage(
    key: state.pageKey,
    child: child,
  );
}

abstract class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: loginPath,
    navigatorKey: _rootNavigatorKey,
    routes: [
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeTabNavigatorKey,
            routes: [
              GoRoute(
                path: homePath,
                pageBuilder: (context, GoRouterState state) {
                  return getPage(
                    child: const HomeScreen(),
                    state: state,
                  );
                },
                routes: [
                  GoRoute(
                    path: addNewPostPath,
                    pageBuilder: (context, state) {
                      final extras = state.extra as Map<String, dynamic>;
                      final String action = extras['action'] as String;
                      final Posts postModel = extras['postModel'] as Posts;
                      return getPage(
                        child:
                            NewPostScreen(action: action, postModel: postModel),
                        state: state,
                      );
                    },
                  )
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _profileTabNavigatorKey,
            routes: [
              GoRoute(
                path: profilePath,
                pageBuilder: (context, state) {
                  return getPage(
                    child: const ProfileScreen(),
                    state: state,
                  );
                },
              )
            ],
          )
        ],
        pageBuilder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          return getPage(
            child: _BottomNavigationPage(
              child: navigationShell,
            ),
            state: state,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: splashPath,
        pageBuilder: (context, state) {
          return getPage(
            child: const SplashScreen(),
            state: state,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: loginPath,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: LoginScreen()),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: registerPath,
        builder: (context, state) => const RegisterScreen(),
      )
    ],
    redirect: (context, state) async {
      final status = context.read<AppBloc>().state.status;
      if (status == AppStatus.authenticated) {
        return null;
      } else if (status == AppStatus.unauthenticated) {
        return loginPath;
      }
    },
  );
}

class _BottomNavigationPage extends StatefulWidget {
  const _BottomNavigationPage({
    required this.child,
  });

  final StatefulNavigationShell child;

  @override
  State<_BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<_BottomNavigationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: widget.child,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.child.currentIndex,
        onTap: (index) {
          widget.child.goBranch(
            index,
            initialLocation: index == widget.child.currentIndex,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
