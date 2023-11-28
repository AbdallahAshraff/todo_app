import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/widgets/task_item.dart';

class TasksBuilder extends StatelessWidget {
  const TasksBuilder({
    Key? key,
    required this.tasks,
    required this.condition,
  }) : super(key: key);

  final List<Map> tasks;
  final bool condition;
  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      condition: condition,
      builder: (context) {
        return ListView.separated(
            itemBuilder: (context, index) => TaskItem(
                  model: tasks[index],
                ),
            separatorBuilder: (context, index) {
              return Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey[300],
              );
            },
            itemCount: tasks.length);
      },
      fallback: (context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.menu,
                color: Colors.grey,
                size: 70,
              ),
              Text('There are no tasks',
                  style: TextStyle(
                    fontSize: 18,
                  ))
            ],
          ),
        );
      },
    );
  }
}
