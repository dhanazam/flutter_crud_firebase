import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_crud_firebase/app/core/core.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;

part 'new_post_event.dart';
part 'new_post_state.dart';

class NewPostBloc extends Bloc<NewPostEvent, NewPostState> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final AuthRepository _authRepository = AuthRepository();
  final PostRepository _postRepository = PostRepository();
  NewPostBloc() : super(const NewPostState()) {
    on<NewPostInitialEvent>(_onNewPostInitialEvent);

    on<OnPostImagePickerEvent>(_onPostImagePickerEvent);

    on<PostTitleChanged>(_onTitleChanged);

    on<PostTitleUnfocused>(_onTitleUnfocused);

    on<PostDescriptionChanged>(_onDescriptionChanged);

    on<PostDescriptionUnfocused>(_onDescriptionUnfocused);

    on<PostFormSubmitted>(_onPostFormSubmitted);
  }

  Future<void> _onNewPostInitialEvent(
      NewPostInitialEvent event, Emitter<NewPostState> emit) async {
    if (event.action == 'update') {
      emit(
        state.copyWith(
          title: PostTitleField.pure(event.postModel.title!),
          description: PostDescriptionField.pure(event.postModel.description!),
          cover: PostCover.pure(event.postModel.cover!),
          isValid: Formz.validate([
            state.title,
            state.description,
            state.cover,
          ]),
        ),
      );
    }
  }

  Future<void> _onPostImagePickerEvent(
      OnPostImagePickerEvent event, Emitter<NewPostState> emit) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
          source: event.kind == 'gallery'
              ? ImageSource.gallery
              : ImageSource.camera,
          imageQuality: 25);

      if (pickedFile != null) {
        UploadTask uploadTask;
        Reference ref = _storage.ref().child('images/').child(pickedFile.name);

        uploadTask = ref.putFile(io.File(pickedFile.path));
        await uploadTask.whenComplete(() async {
          await ref.getDownloadURL().then((value) {
            final cover = PostCover.dirty(value);
            emit(
              state.copyWith(
                cover: cover.isValid ? cover : PostCover.pure(value),
                isValid:
                    Formz.validate([cover, state.title, state.description]),
              ),
            );
          });
        });
      }
    } catch (e) {
      emit(state.copyWith(
          status: AddPostStatus.failure, toastMessage: e.toString()));
    }
  }

  Future<void> _onTitleChanged(
      PostTitleChanged event, Emitter<NewPostState> emit) async {
    final title = PostTitleField.dirty(event.title);
    emit(
      state.copyWith(
        title: title.isValid ? title : PostTitleField.pure(event.title),
        status: AddPostStatus.initial,
        isValid: Formz.validate([title, state.cover, state.description]),
      ),
    );
  }

  Future<void> _onTitleUnfocused(
      PostTitleUnfocused event, Emitter<NewPostState> emit) async {
    final title = PostTitleField.dirty(state.title.value);
    emit(
      state.copyWith(
        title: title,
        status: AddPostStatus.initial,
        isValid: Formz.validate([title, state.cover, state.description]),
      ),
    );
  }

  Future<void> _onDescriptionChanged(
      PostDescriptionChanged event, Emitter<NewPostState> emit) async {
    final description = PostDescriptionField.dirty(event.description);
    emit(
      state.copyWith(
        description: description.isValid
            ? description
            : PostDescriptionField.pure(event.description),
        status: AddPostStatus.initial,
        isValid: Formz.validate([description, state.cover, state.title]),
      ),
    );
  }

  Future<void> _onDescriptionUnfocused(
      PostDescriptionUnfocused event, Emitter<NewPostState> emit) async {
    final description = PostDescriptionField.dirty(state.description.value);
    emit(
      state.copyWith(
        description: description,
        status: AddPostStatus.initial,
        isValid: Formz.validate([description, state.cover, state.title]),
      ),
    );
  }

  Future<void> _onPostFormSubmitted(
      PostFormSubmitted event, Emitter<NewPostState> emit) async {
    final title = PostTitleField.dirty(state.title.value);
    final description = PostDescriptionField.dirty(state.description.value);
    final cover = PostCover.dirty(state.cover.value);
    emit(
      state.copyWith(
        title: title,
        description: description,
        cover: cover,
        status: AddPostStatus.initial,
        isValid: Formz.validate([
          title,
          description,
          cover,
        ]),
      ),
    );
    if (state.isValid) {
      UserModel user = await _authRepository.retrieveCurrentUser().first;
      if (user.uid != "uid") {
        if (event.action == 'create') {
          var param = {
            "cover": state.cover.value.toString(),
            "title": state.title.value.toString(),
            "description": state.description.value.toString(),
            "userId": user.uid,
            "timestamp": DateTime.timestamp(),
            "status": 1
          };
          await _postRepository.addPost(param);
          emit(state.copyWith(
            status: AddPostStatus.success,
            toastMessage: 'Post Saved',
          ));
        } else {
          emit(state.copyWith(status: AddPostStatus.submitting));
          var param = {
            "cover": state.cover.value.toString(),
            "title": state.title.value.toString(),
            "description": state.description.value.toString(),
            "userId": user.uid,
          };
          await _postRepository.updatePost(event.postModel.id!, param);
          emit(state.copyWith(
            status: AddPostStatus.success,
            toastMessage: 'Post Updated',
          ));
        }
      } else {
        emit(state.copyWith(status: AddPostStatus.failure));
      }
    }
  }
}
