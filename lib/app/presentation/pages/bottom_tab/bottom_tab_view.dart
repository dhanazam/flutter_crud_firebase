import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crud_firebase/app/presentation/pages/pages.dart';

class BottomTabView extends StatelessWidget {
  const BottomTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomTabCubit(),
      child: const _BottomTabView(),
    );
  }
}

class _BottomTabView extends StatelessWidget {
  const _BottomTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab =
        context.select((BottomTabCubit cubit) => cubit.state.tab);
    return Scaffold(
      body: IndexedStack(
        index: selectedTab.index,
        children: const [
          HomeScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _BottomTabButton(
                groupValue: selectedTab,
                value: BottomTab.home,
                icon: const Icon(Icons.list_rounded)),
            _BottomTabButton(
                groupValue: selectedTab,
                value: BottomTab.profile,
                icon: const Icon(Icons.show_chart_rounded))
          ],
        ),
      ),
    );
  }
}

class _BottomTabButton extends StatelessWidget {
  const _BottomTabButton({
    required this.groupValue,
    required this.value,
    required this.icon,
  });

  final BottomTab groupValue;
  final BottomTab value;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => context.read<BottomTabCubit>().setTab(value),
        iconSize: 32,
        color: groupValue != value
            ? null
            : Theme.of(context).colorScheme.secondary,
        icon: icon);
  }
}
