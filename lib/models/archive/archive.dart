import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled3/shared/component/component.dart';
import '../../shared/network/local/layout_cubit.dart';
import '../../shared/network/local/layout_states.dart';

class ArchiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoyoutCubit, LayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = LoyoutCubit.get(context).archivedTasks;
        return taskBuilder(
            icon: Icons.archive_outlined,
            tasks: tasks,
            text: 'No archived tasks Yet , جدع ');
      },
    );
  }
}
