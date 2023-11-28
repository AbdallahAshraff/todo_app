import 'dart:developer';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/cubits/cubit/screens_cubit.dart';
import 'package:todo_app/widgets/default_form_field.dart';


class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppstateCubit()..createDatabase(),
      child: BlocConsumer<AppstateCubit, AppStates>(
        listener: (context, state) {
          if (state is DatabaseInsertedState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppstateCubit cubit = BlocProvider.of(context);
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              title: Text(cubit.tasks[cubit.index]),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isbottomsheetshown) {
                  if (formkey.currentState!.validate()) {
                    cubit.insertIntoDatabase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text,
                    );
                    /*.then((value) {
                      Navigator.pop(context);
                      isbottomsheetshown = false;
                       setState(() {
                        fabicon = Icons.edit;
                      });
                    });*/
                  }
                } else {
                  scaffoldkey.currentState
                      ?.showBottomSheet(
                        (context) => Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formkey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DefaultFormField(
                                    controller: titleController,
                                    labelText: 'Task Title',
                                    prefix: Icons.title,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Field cannot be empty';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.text,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  DefaultFormField(
                                    controller: timeController,
                                    labelText: 'Task Time',
                                    prefix: Icons.watch_later_outlined,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Field cannot be empty';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.datetime,
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeController.text =
                                            value!.format(context);
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  DefaultFormField(
                                    controller: dateController,
                                    labelText: 'Task Date',
                                    prefix: Icons.calendar_today_outlined,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Field cannot be empty';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.datetime,
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2050-12-31'),
                                      ).then((value) {
                                        log(
                                            DateFormat.yMMMd().format(value!));
                                        dateController.text =
                                            DateFormat.yMMMd().format(value);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        elevation: 15,
                      )
                      .closed
                      .then((value) {
                    cubit.changebuttomsheet(
                        isshown: false, iconfab: Icons.edit);
                  });
                  cubit.changebuttomsheet(isshown: true, iconfab: Icons.add);
                }
              },
              child: Icon(cubit.fabicon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.index,
              onTap: (value) {
                cubit.changeindex(value);
              },
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: 'Archived'),
              ],
            ),
            body: ConditionalBuilder(
              condition: state is! DatabaseGetLoadingState, //cubit.taskscreated.isNotEmpty,
              builder: (context) => cubit.screens[cubit.index],
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
    );
  }
}
