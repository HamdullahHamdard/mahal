import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mahal/controllers/cubit/cubit.dart';
import 'package:mahal/controllers/cubit/state.dart';
import 'package:mahal/shared/components.dart';

class UpdateToDoTask extends StatefulWidget {

  final int id;
  final String title;
  final String time;
  final String date;
  final String desc;

  const UpdateToDoTask({super.key, required this.id, required this.title, required this.time, required this.date, required this.desc});


  @override
  State<UpdateToDoTask> createState() => _UpdateToDoTaskState();
}

class _UpdateToDoTaskState extends State<UpdateToDoTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    titleController.text = widget.title;
    timeController.text = widget.time;
    dateController.text = widget.date;
    descController.text = widget.desc;

    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoState>(
      listener: (BuildContext context, state) {
        if(state is UpdateDataOnDatabaseState){
          Navigator.pop(context);
        }
      },
      builder: (BuildContext context, Object? state) {
        var cubit = ToDoCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text("Update your task".tr()),
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
                          cubit.updateDataToDatabase(
                            title: titleController.text,
                            date: dateController.text,
                            time: timeController.text,
                            description: descController.text, id: widget.id,
                          );
                        }
                      },

                      minWidth: double.infinity,
                      color: Colors.red,
                      child: Text("Update task".tr(), style: TextStyle(
                        color: Colors.white
                      ),),
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
