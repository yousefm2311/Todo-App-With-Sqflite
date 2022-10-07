// ignore_for_file: unnecessary_this, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todoapp_cubit/shared/cubit/cubit.dart';
import 'package:todoapp_cubit/shared/cubit/states.dart';

var formk = GlobalKey<FormState>();
Widget defaultFormField({
  required String text,
  required TextInputType type,
  IconData? perfix,
  required TextEditingController controller,
  IconData? suffix,
  VoidCallback? suffixButton,
  bool isPassword = false,
  String? Function(String?)? validator,
  VoidCallback? ontap,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: isPassword,
        keyboardType: type,
        onTap: ontap,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          labelText: text,
          hintText: text,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14.0,
          ),
          floatingLabelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
            borderRadius: BorderRadius.circular(20.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.black.withOpacity(0.5), width: 1.5),
            borderRadius: BorderRadius.circular(20.0),
          ),
          prefixIcon: Icon(perfix),
          suffixIcon: suffix != null
              ? IconButton(
                  onPressed: suffixButton,
                  icon: Icon(suffix),
                )
              : null,
        ),
      ),
    );
Widget defaultDesign(Map model, context) =>
    BlocConsumer<AppCubit, AppStates>(builder: (context, state) {
      AppCubit cubit = AppCubit.get(context);
      // titleeditcontroller = 'fdfd';
      return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10),
        child: Slidable(
          endActionPane: ActionPane(
            motion: DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: ((context) => cubit.deleteDatabase(id: model["id"])),
                icon: Icons.delete,
                backgroundColor: Colors.red,
                borderRadius: BorderRadius.circular(15.0),
              ),
              SlidableAction(
                onPressed: ((context) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Form(
                          key: cubit.formKeyslidable,
                          child: AlertDialog(
                            title: const Center(
                                child: Text(
                              "Edit Task",
                              style: TextStyle(fontSize: 15),
                            )),
                            actions: [
                              MaterialButton(
                                color: Colors.blueGrey,
                                onPressed: () {
                                  if (cubit.formKeyslidable.currentState!
                                      .validate()) {
                                    cubit.UpdateDatabaseData(
                                        title: cubit.taskscontroller.text,
                                        time: cubit.timecontroller.text,
                                        date: cubit.datecontroller.text,
                                        id: model["id"]);
                                  }
                                },
                                child: Text("Save",
                                    style: TextStyle(color: Colors.white)),
                              ),
                              MaterialButton(
                                elevation: 0,
                                color: Color.fromARGB(255, 110, 114, 117),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel",
                                    style: TextStyle(color: Colors.white)),
                              )
                            ],
                            content: Column(
                              children: [
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Title is Empty';
                                    }
                                    return null;
                                  },
                                  decoration:
                                      InputDecoration(hintText: "Edit Task"),
                                  controller: cubit.taskscontroller,
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Time is Empty';
                                    }
                                    return null;
                                  },
                                  decoration:
                                      InputDecoration(hintText: "Edit time"),
                                  controller: cubit.timecontroller,
                                  onTap: (() {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      cubit.timecontroller.text =
                                          value!.format(context).toString();
                                    });
                                  }),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Date is Empty';
                                    }
                                    return null;
                                  },
                                  decoration:
                                      InputDecoration(hintText: "Edit date"),
                                  controller: cubit.datecontroller,
                                  onTap: (() {
                                    showDatePicker(
                                      context: context,
                                      firstDate: DateTime.parse('1999-11-23'),
                                      initialDate: DateTime.now(),
                                      lastDate: DateTime.parse('2023-11-23'),
                                    ).then((value) {
                                      cubit.datecontroller.text =
                                          DateFormat.yMMMEd().format(value!);
                                    });
                                  }),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }),
                icon: Icons.edit,
                backgroundColor: Color.fromARGB(255, 110, 114, 117),
                borderRadius: BorderRadius.circular(15.0),
              ),
            ],
          ),
          child: Container(
            height: 70,
            width: 2000,
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blueGrey[400],
                    radius: 25,
                    child: Text('${model['time']}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${model["title"]}',
                            style: const TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text('${model["date"]}',
                              style: const TextStyle(
                                fontSize: 13.0,
                                color: Colors.white60,
                              )),
                        ]),
                  ),
                  IconButton(
                    onPressed: () {
                      AppCubit.get(context)
                          .UpdateDatabase(status: 'done', id: model["id"]);
                    },
                    icon: const Icon(
                      Icons.check_circle,
                      size: 19,
                      color: Color.fromARGB(255, 1, 87, 127),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      AppCubit.get(context)
                          .UpdateDatabase(status: 'archive', id: model["id"]);
                    },
                    icon: const Icon(
                      Icons.archive_sharp,
                      size: 19,
                      color: Color.fromARGB(255, 0, 125, 123),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }, listener: ((context, state) {
      if (state is AppUpdateDatabaseData) {
        Navigator.pop(context);
      }
    }));

extension MyExternsion on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
