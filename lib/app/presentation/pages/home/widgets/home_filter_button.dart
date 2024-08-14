import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crud_firebase/app/presentation/pages/home/models/PostsFilter.dart';

import '../bloc/home_bloc.dart';

class HomeFilterButton extends StatelessWidget {
  const HomeFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final activeFilter = context.select((HomeBloc bloc) => bloc.state.filter);

    return PopupMenuButton<PostsFilter>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      initialValue: activeFilter,
      tooltip: 'Filter posts',
      onSelected: (filter) {
        context.read<HomeBloc>().add(HomePostsFilterEvent(filter: filter));
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: PostsFilter.all,
            child: Text('All posts'),
          ),
          const PopupMenuItem(
            value: PostsFilter.completed,
            child: Text('Completed posts'),
          ),
          const PopupMenuItem(
            value: PostsFilter.incompleted,
            child: Text('Incompleted posts'),
          ),
        ];
      },
      icon: const Icon(Icons.filter_list_rounded),
    );
  }
}
