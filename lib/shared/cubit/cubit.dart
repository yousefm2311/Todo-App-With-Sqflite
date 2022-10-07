// ignore_for_file: avoid_print, non_constant_identifier_names, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp_cubit/shared/cubit/states.dart';

import '../../modules/archive.dart';
import '../../modules/done.dart';
import '../../modules/task.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInistailization());
  List<Map> DoneTask = [];
  List<Map> ArchiveTask = [];
  List<Map> NewTask = [];
  var scaffoldState = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var formKeyslidable = GlobalKey<FormState>();

  var taskscontroller = TextEditingController();
  var datecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var editcontroller = TextEditingController();

  static AppCubit get(context) => BlocProvider.of(context);

  var currentState = 0;
  List<Widget> screen = [
    const Tasks_Screen(),
    const Done_Screen(),
    const Archive_Screen()
  ];

  List<String> title = ['New Tasks', 'Done Tasks', 'Archive Tasks'];

  void changeBottomNavi(int index) {
    currentState = index;
    emit(AppBottomNavigation());
  }

  late Database database;

  void createDatebase() {
    openDatabase('todo.db', version: 1, onCreate: ((database, version) {
      print('Created Database');
      database
          .execute(
              'CREATE TABLE task (id INTEGER PRIMARY KEY, title TEXT,date TEXT,time TEXT,status TEXT)')
          .then((value) {
        print('Created Task Table');
      }).catchError((error) {
        print('error creating ');
      });
    }), onOpen: (database) {
      getDatabase(database);
      print('Opened Database');
    }).then((value) {
      database = value;
      emit(AppCreateDatabase());
    });
  }

  InsertDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO task(title, time,date,status) VALUES("$title","$time" ,"$date","new" )')
          .then((value) {
        print('$value is Insert Success');
        emit(AppInsertDatabase());

        getDatabase(database);
      }).catchError((error) {
        print('Error ${error.toString}');
      });
    });
  }

  void getDatabase(database) {
    NewTask = [];
    ArchiveTask = [];
    DoneTask = [];
    emit(AppLoadingState());
    database.rawQuery('SELECT * FROM task').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          NewTask.add(element);
        } else if (element['status'] == 'archive') {
          ArchiveTask.add(element);
        } else {
          DoneTask.add(element);
        }
      });
      emit(AppGetDatabase());
    });
  }

  bool isbottomSheet = false;
  IconData Ico = Icons.edit;

  void changeBottomSheet({required bool isShow, required IconData icon}) {
    isbottomSheet = isShow;
    Ico = icon;
    emit(AppBottomSheet());
  }

  void UpdateDatabase({required String status, required int id}) {
    database.rawUpdate(
        'UPDATE task SET status=?  WHERE id=?', ['$status', id]).then((value) {
      getDatabase(database);
      emit(AppUpdateDatabase());
    });
  }

  void UpdateDatabaseData(
      {required String title,
      required String time,
      required String date,
      required int id}) {
    database.rawUpdate('UPDATE task SET title=?,time=?,date=?  WHERE id=?',
        ['$title', '$time', '$date', id]).then((value) {
      getDatabase(database);
      emit(AppUpdateDatabaseData());
    });
  }

  void deleteDatabase({required int id}) {
    database.rawDelete('DELETE FROM task WHERE id = ?', [id]).then((value) {
      getDatabase(database);
      emit(AppDeleteDatabase());
    });
  }
}
