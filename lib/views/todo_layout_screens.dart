import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahal/views/add_task_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:mahal/views/drawer_screen.dart';
import 'package:mahal/views/update_screen.dart';
import '../controllers/cubit/cubit.dart';
import '../controllers/cubit/state.dart';

class ToDOScreens extends StatefulWidget {
  const ToDOScreens({super.key});
  @override
  State<ToDOScreens> createState() => _ToDOScreensState();
}

class _ToDOScreensState extends State<ToDOScreens> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoState>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          var cubit = ToDoCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title:  Text("My Tasks".tr()),
              elevation: 0,
              backgroundColor: Colors.deepOrange.shade200,
              toolbarHeight: MediaQuery.of(context).size.width/6,
              actions:[
                BlocBuilder<ToDoCubit, ToDoState>(
                  builder: (BuildContext context, state) {
                    return IconButton(
                        onPressed: (){
                          BlocProvider.of<ToDoCubit>(context).changeThemeMode();
                        },
                        icon: Icon(
                            BlocProvider.of<ToDoCubit>(context).isDark? Icons.dark_mode_outlined : Icons.light_mode
                        )
                    );
                  },
                )
              ]

            ),
            drawer: const Drawer(
              child:  DrawerScreen(),
            ),
            body: ConditionalBuilder(

              condition: state is ! LoadingGettingDataFromTheToDoDatabaseState,
              fallback: (BuildContext context)=> const Center(child: CircularProgressIndicator()),
              builder: (BuildContext context) {
                return (cubit.tasks.isNotEmpty) ?  ListView.builder(
                  itemCount: cubit.tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                          return UpdateToDoTask(id: cubit.tasks[index]['id'], title: cubit.tasks[index]['title'], time: cubit.tasks[index]['time'], date: cubit.tasks[index]['date'], desc: cubit.tasks[index]['description'],);
                        }));
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(cubit.tasks[index]['title'], style: Theme.of(context).textTheme.bodyText1,),
                                  Text(cubit.tasks[index]['time'], style: Theme.of(context).textTheme.caption,),
                                  IconButton(onPressed: (){
                                    cubit.deleteDataFromDatabase(id: cubit.tasks[index]['id']);
                                  }, icon:
                                  const Icon(Icons.delete_forever_outlined)
                                  )

                                ],
                              ),

                              Text(cubit.tasks[index]['description'], style: Theme.of(context).textTheme.titleSmall),


                            ],
                          ),
                        ),

                      ),
                    );
                  },




                ): Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.hourglass_empty),
                      Text("There is no tasks here".tr(), style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.deepOrange),),
                    ],
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                // cubit.insertIntoDatabase(title: "title", date: "date", time: "time", description: "description");
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                  return AddToDoTask();
                }));
              },
              child: const Icon(
                Icons.add,
              ),
            ),
          );
        },
      ),
    );
  }
}
