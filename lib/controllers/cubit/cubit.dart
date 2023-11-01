import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahal/controllers/cubit/state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class ToDoCubit extends Cubit<ToDoState> {
  ToDoCubit() : super(InitialToDoState());

  static ToDoCubit get(context) => BlocProvider.of(context);

  // create database

  Database? database;

  void createToDoDatabase() {
    openDatabase(
      'tododb.db',
      version: 1,
      onCreate: (database, version) {
        debugPrint("the database is created");
        database
            .execute(
                "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, description TEXT, status TEXT)")
            .then((value) {
          print("your table is created");
        }).catchError((onError) {
          print("error in creating the table");
        });
      },
      onOpen: (database) {
        print("the database file is opened");
        getDataFormDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(CreateToDoDatabaseState());
    }).catchError((error) {
      print("The database file can not be opened");
    });
  }

  void insertIntoDatabase({
    required title,
    required date,
    required time,
    required description,
    String status = "new",
  }) {
    database!.transaction((txn) async {
      txn.rawInsert(
          'INSERT INTO tasks(title, date, time, description, status) VALUES ("$title", "$date", "$time", "$description", "$status")');
    }).then((value) {
      print("data inserted");
      getDataFormDatabase(database);
      emit(InsertDataToDoDatabaseState());
    }).catchError((error) {
      print('Data Can not be added');
    });
  }

  List tasks = [];
  void getDataFormDatabase(database) {
    emit(LoadingGettingDataFromTheToDoDatabaseState());
    tasks = [];
    database!.rawQuery("SELECT * FROM tasks").then((value) {
      for (var i in value) {
        tasks.add(i);
      }
      emit(GettingDataFromDatabaseState());
      print(tasks);
      
    }).catchError((error) {
      print('can not be read from database');
    });
  }

  void updateDataToDatabase({
    required int id,
    required String title,
    required String date,
    required String time,
    required String description,
    String status = "new",
  }) {
    database!
        .update(
      'tasks',
      {
        "title": title,
        "date": date,
        "time": time,
        "description": description,
        "status": status
      },
      where: 'id = ?',
      whereArgs: [id],
    )
        .then((value) {
      emit(UpdateDataOnDatabaseState());
      getDataFormDatabase(database);
      print("data has been updated");
    }).catchError((error) {
      print("error on update");
    });
  }

  void deleteDataFromDatabase({
    required int id,
  }) {
    database!.rawDelete("DELETE from tasks where id = ?", [id]).then((value) {
      print("data successfully deleted");
      emit(DeleteDataFromDatabaseState());
      getDataFormDatabase(database);
    }).catchError((error) {
      print("error on deleting");
    });
  }

  void changeLanguageToArabic(BuildContext context) {
    if (EasyLocalization.of(context)!.locale == const Locale('en', 'US')) {
      context.locale = const Locale('ar', 'EG');
    }
    emit(ChangeLanguageToArabicState());
  }

  void changeLanguageToEnglish(BuildContext context) {
    if (EasyLocalization.of(context)!.locale == const Locale('ar', 'EG')) {
      context.locale = const Locale('en', 'US');
    }
    emit(ChangeLanguageToEnglishState());
  }

  bool isDark = false;
  void changeThemeMode({bool? darkMode}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (darkMode != null) {
      isDark = darkMode;
    }else{
      isDark = !isDark;
      sharedPreferences.setBool("isDark", isDark);
    }

    emit(ChangeThemeModeState());
  }
}
