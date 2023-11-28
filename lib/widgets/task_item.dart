// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:todo_app/cubits/cubit/screens_cubit.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({
    Key? key,
    required this.model,
  }) : super(key: key);
  final Map model;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(model['id'].toString()),
      onDismissed: (direction) {
        AppstateCubit.get(context).deleteDB(id: model['id']);
      },
      background: Container(color: Colors.red, child: const Icon(Icons.cancel),),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                "${model['time']}",
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, children: [
                Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  "${model['title']}",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    "${model['date']}",
                    style: const TextStyle(
                      color: Colors.grey,
                    ))
              ]),
            ),
            const SizedBox(
              width: 30,
            ),
            IconButton(
                onPressed: () {
                  AppstateCubit.get(context)
                      .updateDB(status: 'done', id: model['id']);
                },
                icon: const Icon(Icons.check_box_outlined)),
            IconButton(
                onPressed: () {
                  AppstateCubit.get(context)
                      .updateDB(status: 'archive', id: model['id']);
                },
                icon: const Icon(Icons.archive)),
        
          ],
        ),
      ),
      
    );
  }
}
