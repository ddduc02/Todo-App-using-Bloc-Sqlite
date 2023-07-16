import 'package:flutter/material.dart';
import 'package:todo_app/features/login/ui/login.dart';
import 'package:todo_app/features/signup/ui/signup.dart';
import 'package:todo_app/helper/databasehelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataBaseHelper.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Login(),
    );
  }
}
