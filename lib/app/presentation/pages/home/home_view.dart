import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crud_firebase/app/bloc/app_bloc.dart';
import 'package:flutter_crud_firebase/app/presentation/pages/pages.dart';
import 'package:flutter_crud_firebase/app/presentation/styles/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:post_repository/post_repository.dart';
import 'package:skeletonizer/skeletonizer.dart';

typedef ContextCallback = void Function(BuildContext context);
typedef ContextStateIndexCallback = void Function(
    BuildContext context, Post post);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(HomeInitialEvent()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  void goBackNavigation(BuildContext context) {
    Navigator.pop(context);
  }

  void confirmDeleteOnPressed(BuildContext context, Post post) {
    Navigator.pop(context);
    context.read<HomeBloc>().add(
          HomeDeletePostEvent(
            postModel: post,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.homeTitle),
        automaticallyImplyLeading: false,
        actions: [
          const HomeFilterButton(),
          // IconButton(
          //   onPressed: () {
          //     context.read<AppBloc>().add(const AppLogoutRequested());
          //   },
          //   icon: Icon(
          //     Icons.logout_outlined,
          //     color: Theme.of(context).iconTheme.color,
          //   ),
          // )
        ],
        leading: IconButton(
          onPressed: () {
            context.read<ThemeBloc>().add(ChangeThemeEvent());
          },
          icon: Icon(
            Icons.light_mode,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/home/add-new-post', extra: {
            'action': 'create',
            'postModel': Post(),
          }).then((res) {
            if (res == true) {
              context.read<HomeBloc>().add(
                    HomeInitialEvent(),
                  );
            }
          });
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state.status.isSuccess) {
                // kSnackBarSuccess(context, state.toastMessage);
              } else if (state.status.isFailure) {
                kSnackBarError(context, state.toastMessage);
              } else if (state.status.isLogout) {
                context.go('/login');
              }
            },
          ),
          BlocListener<HomeBloc, HomeState>(
            listenWhen: (previous, current) {
              return previous.lastDeletedPost != current.lastDeletedPost &&
                  current.lastDeletedPost != null;
            },
            listener: (context, state) {
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: const Text("Deletedddd"),
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () {
                      context.read<HomeBloc>().add(
                            HomePostUndoDeleteEvent(),
                          );
                    },
                  ),
                ));
            },
          )
        ],
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.status.isLoading) {
              return Skeletonizer(
                child: Text(AppLocalizations.of(context)!.noPostMessage),
              );
            }
            if (state.status.isSuccess) {
              debugPrint("filteredPosts: ${state.filteredPosts}");
              debugPrint("filteredPosts length: ${state.filteredPosts.length}");
              return state.list.isEmpty
                  ? Center(
                      child: Text(AppLocalizations.of(context)!.noPostMessage),
                    )
                  : CupertinoScrollbar(
                      child: ListView(
                        padding:
                            const EdgeInsets.all(ThemeProvider.scaffoldPadding),
                        children: [
                          for (final post in state.filteredPosts)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                titleTextStyle: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.fontSize,
                                  fontFamily: 'medium',
                                  color: Theme.of(context).canvasColor,
                                  decoration: post.isCompleted!
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                                title: Text(post.title ?? ''),
                                leading: ClipRRect(
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(15),
                                    child: FadeInImage(
                                      height: 20,
                                      width: 20,
                                      fit: BoxFit.cover,
                                      image: NetworkImage(post.cover ?? ''),
                                      placeholder: const AssetImage(
                                          "assets/images/placeholder.jpeg"),
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/placeholder.jpeg',
                                          fit: BoxFit.cover,
                                          height: 100,
                                          width: 100,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                trailing: Wrap(
                                  spacing: -10,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        context.push(
                                          '/home/add-new-post',
                                          extra: {
                                            'action': 'update',
                                            'postModel': post,
                                          },
                                        ).then((res) {
                                          if (res == true) {
                                            context
                                                .read<HomeBloc>()
                                                .add(HomeInitialEvent());
                                          }
                                        });
                                      },
                                      icon: Icon(
                                        Icons.mode_edit_outline_outlined,
                                        color: Theme.of(context).canvasColor,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        context.read<HomeBloc>().add(
                                              HomeUpdateStatusPostEvent(
                                                postModel: post,
                                              ),
                                            );
                                      },
                                      icon: FaIcon(
                                        post.status == 1
                                            ? FontAwesomeIcons.eye
                                            : FontAwesomeIcons.eyeSlash,
                                        size: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.fontSize,
                                        color: Theme.of(context).canvasColor,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => BlocProvider.value(
                                            value: context.read<HomeBloc>(),
                                            child: AlertDialog(
                                              contentPadding:
                                                  const EdgeInsets.all(20),
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    const _DeleteImage(),
                                                    const SizedBox(height: 20),
                                                    _ConfirmText(
                                                        context: context),
                                                    const SizedBox(height: 10),
                                                    _DeleteTextInfo(
                                                        context: context,
                                                        post: post),
                                                    const SizedBox(height: 20),
                                                    Row(
                                                      children: [
                                                        _CancelButton(
                                                          context: context,
                                                          onPressed:
                                                              goBackNavigation,
                                                        ),
                                                        const SizedBox(
                                                            width: 20),
                                                        _ConfirmDeleteButton(
                                                            onPressed:
                                                                confirmDeleteOnPressed,
                                                            context: context,
                                                            post: post),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.delete_outline_outlined,
                                        color: Theme.of(context).canvasColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _DeleteImage extends StatelessWidget {
  const _DeleteImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/delete.png',
      fit: BoxFit.cover,
      height: 80,
      width: 80,
    );
  }
}

class _ConfirmText extends StatelessWidget {
  const _ConfirmText({required this.context});
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.confirm,
      style: TextStyle(
        fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
        fontFamily: 'semibold',
      ),
    );
  }
}

class _DeleteTextInfo extends StatelessWidget {
  const _DeleteTextInfo({required this.context, required this.post});
  final BuildContext context;
  final Post post;

  @override
  Widget build(BuildContext context) {
    final String textInfo =
        '${AppLocalizations.of(context)!.toDelete} ${post.title} ${AppLocalizations.of(context)!.confirmPost}';
    return Text(
      textInfo,
      style: TextStyle(
          fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
          fontFamily: 'medium'),
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.context, required this.onPressed});

  final BuildContext context;
  final ContextCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => onPressed(context),
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).scaffoldBackgroundColor,
          backgroundColor: Theme.of(context).canvasColor,
          minimumSize: const Size.fromHeight(35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Text(
          AppLocalizations.of(context)!.cancel,
          style: TextStyle(
              color: Theme.of(context).scaffoldBackgroundColor,
              fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
              fontFamily: 'medium'),
        ),
      ),
    );
  }
}

class _ConfirmDeleteButton extends StatelessWidget {
  const _ConfirmDeleteButton(
      {required this.onPressed, required this.context, required this.post});

  final BuildContext context;
  final Post post;
  final ContextStateIndexCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => onPressed(context, post),
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).scaffoldBackgroundColor,
          backgroundColor: Theme.of(context).primaryColor,
          minimumSize: const Size.fromHeight(35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Text(
          AppLocalizations.of(context)!.delete,
          style: TextStyle(
              color: Theme.of(context).scaffoldBackgroundColor,
              fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
              fontFamily: 'medium'),
        ),
      ),
    );
  }
}
