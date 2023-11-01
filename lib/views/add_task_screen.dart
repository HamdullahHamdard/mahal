import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mahal/controllers/cubit/cubit.dart';
import 'package:mahal/controllers/cubit/state.dart';
import 'package:mahal/shared/components.dart';
import 'package:mahal/views/todo_layout_screens.dart';

class AddToDoTask extends StatelessWidget {
  AddToDoTask({Key? key}) : super(key: key);
  
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoState>(
      listener: (BuildContext context, state) {
        if(state is InsertDataToDoDatabaseState){
          Navigator.pop(context);
        }
      },
      builder: (BuildContext context, Object? state) {
        var cubit = ToDoCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text("Add your task".tr()),
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    textFormField(
                      textEditingController: titleController,
                      type: TextInputType.text,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "please add your title".tr();
                        }
                      },
                      label: 'Title'.tr(),
                      hintText: 'Add your title'.tr(),
                      prefixIcon: Icons.title,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    textFormField(
                        textEditingController: timeController,
                        type: TextInputType.datetime,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "please add your time".tr();
                          }
                        },
                        label: 'Time'.tr(),
                        hintText: 'Add your time'.tr(),
                        prefixIcon: Icons.watch_later_outlined,
                        onTap: () {
                          showTimePicker(context: context, initialTime: TimeOfDay.now())
                              .then((value) {
                            timeController.text = value!.format(context);
                          }).catchError((error) {
                            timeController.clear();
                          });
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    textFormField(
                        textEditingController: dateController,
                        type: TextInputType.datetime,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "please add your date".tr();
                          }
                        },
                        label: 'Date'.tr(),
                        hintText: 'Add your date'.tr(),
                        prefixIcon: Icons.date_range_outlined,
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.parse("2040-12-30"),
                          ).then((value){
                            dateController.text = DateFormat.yMMMd().format(value!);
                          }).catchError((error){
                            dateController.clear();
                          });
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    textFormField(
                      lines: 5,
                      textEditingController: descController,
                      type: TextInputType.text,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "please add your description".tr();
                        }
                      },
                      label: 'Description'.tr(),
                      hintText: 'Add your description'.tr(),
                      prefixIcon: Icons.title,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      height: 40.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                      onPressed: () {
                        if(_formKey.currentState!.validate()){
                          cubit.insertIntoDatabase(
                            title: titleController.text,
                            date: dateController.text,
                            time: timeController.text,
                            description: descController.text,
                          );
                        }
                      },

                      minWidth: double.infinity,
                      color: Colors.deepOrange,
                      child: Text("Add task".tr()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
