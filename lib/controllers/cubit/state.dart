abstract class ToDoState {}
class InitialToDoState extends ToDoState{}

//    the create database state
class CreateToDoDatabaseState extends ToDoState{}

//    insert  data to database
class InsertDataToDoDatabaseState extends ToDoState{}
class LoadingGettingDataFromTheToDoDatabaseState extends ToDoState{}

class GettingDataFromDatabaseState extends ToDoState{}
class UpdateDataOnDatabaseState extends ToDoState{}

class DeleteDataFromDatabaseState extends ToDoState{}



class ChangeLanguageToArabicState extends ToDoState{}
class ChangeLanguageToEnglishState extends ToDoState{}


class ChangeThemeModeState extends ToDoState{}