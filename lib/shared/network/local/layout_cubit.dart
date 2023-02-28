// import 'package:bloc/bloc.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/archive/archive.dart';
import '../../../models/done/done_taskes.dart';
import '../../../models/tasks/tasks_screen.dart';
import 'layout_states.dart';

class LoyoutCubit extends Cubit<LayoutStates> {
  LoyoutCubit() : super(IntialStates());

  static LoyoutCubit get(BuildContext context) => BlocProvider.of(context);

  List<String> title = [
    'Taskes',
    'Done',
    'Archive',
  ];

  List<Widget> screens = [
    TaskesScreen(),
    DoneScreen(),
    ArchiveScreen(),
  ];

  List<BottomNavigationBarItem> navBarItem = [
    const BottomNavigationBarItem(
      label: 'Taskes',
      icon: Icon(
        Icons.menu,
      ),
    ),
    const BottomNavigationBarItem(
      label: 'Done',
      icon: Icon(
        Icons.check_circle_outline,
      ),
    ),
    const BottomNavigationBarItem(
      label: 'Archive',
      icon: Icon(
        Icons.archive,
      ),
    ),
  ];

  int currentIndex = 0;
  void changeNavBarIndex({
    required int index,
  }) {
    currentIndex = index;
    emit(ChangeNavBarIndex());
  }

  bool isBottomSheetShown = false;
  IconData iconFloatingBottom = Icons.edit;

  void bottomSheetClose() {
    iconFloatingBottom = Icons.edit;
    isBottomSheetShown = false;

    print("from bottom Sheet Open State function ");
    emit(BottomSheetOpenState());
  }

  void bottomSheetOpen() {
    iconFloatingBottom = Icons.add;
    isBottomSheetShown = true;
    print("from bottom Sheet Close State function ");
    emit(BottomSheetCloseState());
  }

  List newTasks = [];
  List doneTasks = [];
  List archivedTasks = [];

  Database? database;

  void creatDB() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print("database is created successful ");
        db.execute('''CREATE TABLE tasks (
          id INTEGER NOT NULL PRIMARY KEY,
          title TEXT NOT NULL,
          date TEXT NOT NULL,
          time TEXT NOT NULL,
          status TEXT NOT NULL
          )''').then((value) {});
        print("table is created successful ");
      },
      onOpen: (db) {
        getData(db);
        print("database is opened successful ");
      },
    ).then((value) {
      database = value;
      emit(OpenDatabaseState());
    });
  }

  insertDB({
    required String title,
    required String date,
    required String time,
  }) async {
    return await database?.transaction((txn) async {
      await txn
          .rawInsert('''INSERT INTO tasks(title,date,time,status)
                   VALUES("$title","$date","$time","new")''')
          .then((value) {})
          .catchError((error) {});
    }).then((value) {
      emit(InsartIntoDatabaseState());
      getData(database!);
    }).catchError((error) {});
  }

  void getData(Database database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(GetdataFromDatabaseLoadingState());
    database.rawQuery("SELECT * FROM tasks").then(
      (value) {
        value.forEach((element) {
          if (element['status'] == 'new') {
            newTasks.add(element);
          } else if (element['status'] == 'done') {
            doneTasks.add(element);
          } else {
            archivedTasks.add(element);
          }
        });
        emit(GetdataFromDatabaseState());
      },
    );
  }

  void updateDB({
    required String status,
    required int id,
  }) {
    database!.rawUpdate('UPDATE Test SET status = ? WHERE id = ?', [
      '&status',
      '$id',
    ]).then((value) {
      getData(database!);
      emit(UpdateDatabaseState());
    });
  }

  void deleteRecord({required int id}) {
    database?.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getData(database!);
      emit(DeleteDatabaseState());
    });
  }
}
