import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todoapp_cubit/shared/bloc_observer.dart';

import 'layout/bottomnavi.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      debugShowCheckedModeBanner: false,
      home: BottomNavigation(),
    );
  }
}
