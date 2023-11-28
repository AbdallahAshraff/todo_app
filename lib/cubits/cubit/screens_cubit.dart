
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../views/archived_tasks.dart';
import '../../views/done_tasks.dart';
import '../../views/new_tasks.dart';

part 'screens_state.dart';

class AppstateCubit extends Cubit<AppStates> {
  AppstateCubit() : super(AppInitialState());
  static AppstateCubit get(context) => BlocProvider.of(context);

  int index = 0;
  Database? database;
  bool isbottomsheetshown = false;
  IconData fabicon = Icons.edit;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  List<Widget> screens = [
    const NewTask(),
    const DoneTask(),
    const ArchivedTask()
  ];
  List<String> tasks = ['New Task', 'Done Tasks', 'Archived Tasks'];
  void changeindex(int currentindex) {
    index = currentindex;
    emit(BottomNavBarchange());
  }

  changebuttomsheet({required bool isshown, required IconData iconfab}) {
    isbottomsheetshown = isshown;
    fabicon = iconfab;
    emit(BottomSheetchange());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT , date TEXT , time TEXT , status TEXT)')
            .then((value) {
          log('Database created');
        }).catchError((error) {
          log(error.toString());
        });
      },
      onOpen: (database) {
        getTasksfromDB(database);

        emit(DatabaseGetState());
        log('Database Opened');
      },
    ).then((value) {
      database = value;
    });
    emit(DatabaseCreatedState());
  }

  Future<void> insertIntoDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database!.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks(title, date , time , status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        log('$value database inserted successfully');
        emit(DatabaseInsertedState());

        getTasksfromDB(database);
        emit(DatabaseGetState());
      }).catchError((error) {
        log('There was an error ${error.toString()}');
      });
      return null;
    });
  }

  void getTasksfromDB(Database? database) async {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(DatabaseGetLoadingState());
    return await database!.rawQuery('SELECT * FROM tasks').then((value) {
      // print(taskscreated);
      for (var element in value) {
          if (element['status'] == 'new') {
            newTasks.add(element);
          } else if (element['status'] == 'done') {
            doneTasks.add(element);
          } else {
            archiveTasks.add(element);
          }
        }
      emit(DatabaseGetState());
    });
  }

  void updateDB({required String status, required int id}) async {
    database!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', [
      status,
      id,
    ]).then((value) {
      getTasksfromDB(database);
      emit(DatabaseUpdateState());
    });
  }
   void deleteDB({required int id}) async {
   database!
    .rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getTasksfromDB(database);
      emit(DatabaseDeleteState());
    });
  }

}

 
