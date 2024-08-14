import 'package:post_repository/post_repository.dart';

enum PostsFilter { completed, incompleted, all }

extension PostsFilterExtension on PostsFilter {
  bool apply(Post post) {
    switch (this) {
      case PostsFilter.completed:
        return post.isCompleted;
      case PostsFilter.incompleted:
        return !post.isCompleted;
      case PostsFilter.all:
        return true;
    }
  }

  Iterable<Post> applyAll(Iterable<Post> posts) {
    return posts.where(apply);
  }
}
