import 'package:app_steps/src/home/presentation/cubit/step_cubit.dart';
import 'package:app_steps/src/home/presentation/screen/step_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: MaterialApp(
        title: 'Step Counter',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const TodayPage(),
      ),
    );
  }
}