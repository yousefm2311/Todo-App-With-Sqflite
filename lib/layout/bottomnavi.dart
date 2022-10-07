// ignore_for_file: unused_label, avoid_print, non_constant_identifier_names, must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:todoapp_cubit/shared/cubit/cubit.dart';

import '../component.dart';
import '../shared/cubit/states.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AppCubit()..createDatebase(),
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (
            BuildContext context,
            AppStates state,
          ) {
            if (state is AppInsertDatabase) {
              Navigator.pop(context);
            }
          },
          builder: ((BuildContext context, AppStates state) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              backgroundColor: Colors.grey[400],
              key: cubit.scaffoldState,
              appBar: AppBar(
                elevation: 0,
                title: Text(cubit.title[cubit.currentState]),
                centerTitle: true,
              ),
              body: ConditionalBuilder(
                condition: state is! AppLoadingState,
                builder: (context) => cubit.screen[cubit.currentState],
                fallback: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.grey[400],
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.task), label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle), label: ''),
                  BottomNavigationBarItem(icon: Icon(Icons.archive), label: ''),
                ],
                currentIndex: cubit.currentState,
                onTap: (index) {
                  cubit.changeBottomNavi(index);
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isbottomSheet) {
                    if (cubit.formKey.currentState!.validate()) {
                      cubit.InsertDatabase(
                        title: cubit.taskscontroller.text,
                        date: cubit.datecontroller.text,
                        time: cubit.timecontroller.text,
                      );
                      cubit.changeBottomSheet(isShow: false, icon: Icons.edit);
                    }
                  } else {
                    cubit.scaffoldState.currentState
                        ?.showBottomSheet((context) => Container(
                              padding: const EdgeInsets.all(15),
                              color: Colors.grey[400],
                              child: Form(
                                  key: cubit.formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      defaultFormField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Title is Empty';
                                          }
                                          return null;
                                        },
                                        controller: cubit.taskscontroller,
                                        perfix: Icons.title,
                                        text: 'Title Name',
                                        type: TextInputType.text,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      defaultFormField(
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Time is Empty';
                                            }
                                            return null;
                                          },
                                          controller: cubit.timecontroller,
                                          perfix: Icons.timer,
                                          text: 'Time',
                                          type: TextInputType.text,
                                          ontap: () {
                                            showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now())
                                                .then((value) {
                                              cubit.timecontroller.text = value!
                                                  .format(context)
                                                  .toString();
                                            });
                                          }),
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      Container(),
                                      defaultFormField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Date is Empty';
                                          }
                                          return null;
                                        },
                                        controller: cubit.datecontroller,
                                        perfix: Icons.date_range,
                                        text: 'Date',
                                        type: TextInputType.text,
                                        ontap: () => {
                                          showDatePicker(
                                            context: context,
                                            firstDate:
                                                DateTime.parse('1999-11-23'),
                                            initialDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2023-11-23'),
                                          ).then((value) {
                                            cubit.datecontroller.text =
                                                DateFormat.yMMMEd()
                                                    .format(value!);
                                          }),
                                        },
                                      ),
                                    ],
                                  )),
                            ))
                        .closed
                        .then((value) => cubit.changeBottomSheet(
                            isShow: false, icon: Icons.edit));
                    cubit.changeBottomSheet(isShow: true, icon: Icons.add);
                  }
                },
                child: Icon(cubit.Ico),
              ),
            );
          }),
        ));
  }
}
