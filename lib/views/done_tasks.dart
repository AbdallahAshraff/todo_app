import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cubit/screens_cubit.dart';
import '../widgets/tasks_builder.dart';

class DoneTask extends StatelessWidget {
  const DoneTask({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppstateCubit, AppStates>(
      listener: (context, state) {

      },
      builder: (context, state) {
        var tasks = AppstateCubit.get(context).doneTasks;
        return TasksBuilder(tasks: tasks , condition: AppstateCubit.get(context).doneTasks.isNotEmpty,);
      },
    );
  }
  }

