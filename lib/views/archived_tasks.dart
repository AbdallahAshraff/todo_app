// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cubit/screens_cubit.dart';
import '../widgets/tasks_builder.dart';

class ArchivedTask extends StatelessWidget {
  const ArchivedTask({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppstateCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppstateCubit.get(context).archiveTasks;
        return TasksBuilder(tasks: tasks , condition: AppstateCubit.get(context).archiveTasks.isNotEmpty,);
      },
    );
  }
}

