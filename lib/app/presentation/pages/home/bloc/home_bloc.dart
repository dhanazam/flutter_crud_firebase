import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:post_repository/post_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PostRepository _postRepository = PostRepository();
  List<Post> list = <Post>[];

  HomeBloc() : super(const HomeState()) {
    on<HomeInitialEvent>(_onHomeInitialEvent);
    on<HomeUpdateStatusPostEvent>(_onHomeUpdateStatusPostEvent);
    on<HomeDeletePostEvent>(_onHomeDeletePostEvent);
  }

  FutureOr<void> _onHomeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      await _postRepository.getUserId().then((userId) async {
        if (userId != null) {
          list = await _postRepository.retrieveMyPost(userId);
          list.sort((a, b) {
            return b.timestamp!.compareTo(a.timestamp!);
          });
          emit(
            state.copyWith(
              status: HomeStatus.success,
              list: [...list],
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: HomeStatus.unAuthorized,
              toastMessage: 'Unauthorized',
            ),
          );
        }
      }).catchError((onError) {
        emit(
          state.copyWith(
            status: HomeStatus.failure,
            toastMessage: onError.toString(),
          ),
        );
      });
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          toastMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onHomeUpdateStatusPostEvent(
      HomeUpdateStatusPostEvent event, Emitter<HomeState> emit) async {
    try {
      event.postModel.status = event.postModel.status == 1 ? 0 : 1;

      await _postRepository
          .updatePost(event.postModel.id!, {"status": event.postModel.status});

      emit(
        state.copyWith(
          status: HomeStatus.success,
          list: [...list],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          toastMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onHomeDeletePostEvent(
      HomeDeletePostEvent event, Emitter<HomeState> emit) async {
    try {
      await _postRepository.deletePost(event.postModel.id!);
      list.removeWhere((element) => element.id == event.postModel.id);

      emit(
        state.copyWith(
          status: HomeStatus.success,
          list: [...list],
          toastMessage: "Post deleted",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          toastMessage: e.toString(),
        ),
      );
    }
  }
}
