import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahal/controllers/cubit/cubit.dart';
import 'package:mahal/controllers/cubit/state.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoState>(
      listener: (BuildContext context, state) {

      },
       builder: (BuildContext context, Object? state) {
         var cubit = ToDoCubit.get(context);
         return Column(

           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 MaterialButton(
                   color: Colors.deepOrange,
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                   onPressed: (){
                     cubit.changeLanguageToEnglish(context);
                   },
                   child: Text("English".tr()),
                 ),
                 MaterialButton(
                   color: Colors.deepOrange,
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                   onPressed: (){
                     cubit.changeLanguageToArabic(context);
                   },
                   child: Text("Pashto".tr()),
                 ),
               ],
             )

           ],
         );

      },
    );
  }
}
