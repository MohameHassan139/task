import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled3/shared/component/component.dart';
import '../../shared/network/local/layout_cubit.dart';
import '../../shared/network/local/layout_states.dart';

class DoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoyoutCubit, LayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = LoyoutCubit.get(context).doneTasks;
        return taskBuilder(
            icon: Icons.downloading_outlined,
            tasks: tasks,
            text: 'No done tasks Yet ');
      },
    );
  }
}
