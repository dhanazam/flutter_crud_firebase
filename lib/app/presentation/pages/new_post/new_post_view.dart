import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crud_firebase/app/presentation/pages/new_post/bloc/new_post_bloc.dart';
import 'package:flutter_crud_firebase/app/presentation/pages/new_post/new_post.dart';
import 'package:flutter_crud_firebase/app/presentation/styles/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:post_repository/post_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewPostScreen extends StatefulWidget {
  final String action;
  final Post postModel;

  const NewPostScreen(
      {super.key, required this.action, required this.postModel});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewPostBloc(),
      child: NewPostView(
        action: widget.action,
        postModel: widget.postModel,
      ),
    );
  }
}

class NewPostView extends StatefulWidget {
  final String action;
  final Post postModel;
  const NewPostView({super.key, required this.action, required this.postModel});

  @override
  State<NewPostView> createState() => _NewPostViewState();
}

class _NewPostViewState extends State<NewPostView> {
  final TextEditingController _postTitleController = TextEditingController();
  final TextEditingController _postDescriptionController =
      TextEditingController();

  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  @override
  void initState() {
    context.read<NewPostBloc>().add(
          NewPostInitialEvent(
              action: widget.action, postModel: widget.postModel),
        );

    _titleFocusNode.addListener(() {
      if (!_titleFocusNode.hasFocus) {
        context.read<NewPostBloc>().add(PostTitleUnfocused());
      }
    });

    _descriptionFocusNode.addListener(() {
      if (!_descriptionFocusNode.hasFocus) {
        context.read<NewPostBloc>().add(PostDescriptionUnfocused());
      }
    });

    if (widget.action == 'create') {
      _postTitleController.text = '';
      _postDescriptionController.text = '';
    } else if (widget.action == 'update') {
      _postTitleController.text = widget.postModel.title!;
      _postDescriptionController.text = widget.postModel.description!;
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _showImagePickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  context
                      .read<NewPostBloc>()
                      .add(OnPostImagePickerEvent(kind: 'gallery'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  context
                      .read<NewPostBloc>()
                      .add(OnPostImagePickerEvent(kind: 'camera'));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewPostBloc, NewPostState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          kSnackBarError(context, state.toastMessage);
        } else if (state.status.isSuccess) {
          kSnackBarSuccess(context, state.toastMessage);
          context.pop(true);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Post')),
          body: AbsorbPointer(
            absorbing: state.status.isSubmitting,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              child: GestureDetector(
                                onTap: () {
                                  _showImagePickerModal(context);
                                },
                                child: CircleAvatar(
                                  radius: 50,
                                  child: state.cover.isNotValid
                                      ? Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: state.cover
                                                              .displayError !=
                                                          null
                                                      ? kRed
                                                      : kTransparent,
                                                  width: state.cover
                                                              .displayError !=
                                                          null
                                                      ? 1
                                                      : 0),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.asset(
                                              "assets/images/placeholder.jpeg",
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : ClipOval(
                                          child: FadeInImage(
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              state.cover.value.toString(),
                                            ),
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
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      focusNode: _titleFocusNode,
                      controller: _postTitleController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.postTitle,
                        errorText: state.title.displayError != null
                            ? AppLocalizations.of(context)!.postValidation
                            : null,
                        labelStyle: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelMedium?.fontSize,
                          fontFamily: 'medium',
                        ),
                        errorStyle: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelMedium?.fontSize,
                          fontFamily: 'medium',
                        ),
                      ),
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelLarge?.fontSize,
                        fontFamily: 'medium',
                      ),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        context
                            .read<NewPostBloc>()
                            .add(PostTitleChanged(title: value));
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      focusNode: _descriptionFocusNode,
                      controller: _postDescriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context)!.postDescription,
                        errorText: state.title.displayError != null
                            ? AppLocalizations.of(context)!
                                .postDescriptionValidation
                            : null,
                        labelStyle: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelMedium?.fontSize,
                          fontFamily: 'medium',
                        ),
                        errorStyle: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelMedium?.fontSize,
                          fontFamily: 'medium',
                        ),
                      ),
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelLarge?.fontSize,
                        fontFamily: 'medium',
                      ),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        context
                            .read<NewPostBloc>()
                            .add(PostDescriptionChanged(description: value));
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SwitchListTile(
                        title: const Text('Complete'),
                        value: state.isCompleted,
                        onChanged: (value) {
                          context
                              .read<NewPostBloc>()
                              .add(PostCompletionToggle(isCompleted: value));
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () =>
                          context.read<NewPostBloc>().add(PostFormSubmitted(
                                action: widget.action,
                                postModel: widget.postModel,
                              )),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        textStyle: TextStyle(
                            fontFamily: 'semibold',
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.fontSize),
                      ),
                      label: Text(AppLocalizations.of(context)!.submit),
                      icon: state.status.isSubmitting
                          ? Container(
                              width: 24,
                              height: 24,
                              padding: const EdgeInsets.all(2.0),
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Icon(Icons.login_outlined),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
