import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubits/cubit/screens_cubit.dart';

import '../widgets/tasks_builder.dart';

class NewTask extends StatelessWidget {
  const NewTask({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppstateCubit, AppStates>(
      listener: (context, state) {

      },
      builder: (context, state) {
        var tasks = AppstateCubit.get(context).newTasks;
        return TasksBuilder(tasks: tasks , condition: AppstateCubit.get(context).newTasks.isNotEmpty,);
      },
    );
  }
}
