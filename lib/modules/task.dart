// ignore_for_file: camel_case_types
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp_cubit/shared/cubit/cubit.dart';
import '../component.dart';
import '../shared/cubit/states.dart';

class Tasks_Screen extends StatefulWidget {
  const Tasks_Screen({super.key});

  @override
  State<Tasks_Screen> createState() => _Tasks_ScreenState();
}

class _Tasks_ScreenState extends State<Tasks_Screen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          var task = AppCubit.get(context).NewTask;
          return ConditionalBuilder(
            condition: task.isNotEmpty,
            builder: (context) => ListView.separated(
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: defaultDesign(task[index], context),
                    ),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 0,
                    ),
                itemCount: task.length),
            fallback: (context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add_task, size: 50.0),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text("No Tasks Yet",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                ],
              ),
            ),
          );
        },
        listener: (context, state) {});
  }
}
