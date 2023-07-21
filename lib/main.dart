import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/home/bloc/home_page_bloc.dart';
import 'package:todo_app/features/home/ui/home_page.dart';
import 'package:todo_app/features/login/ui/login.dart';
import 'package:todo_app/features/signup/ui/signup.dart';
import 'package:todo_app/helper/taskhelper.dart';
import 'package:todo_app/helper/userhelper.dart';
import 'package:todo_app/models/user.dart';
import 'package:todo_app/sf/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserHelper.instance.init();
  await TaskHelper.instance.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: Preferences.instance.isLoggedIn(),
        builder: (context, snapshot) {
          bool isLoggedIn = snapshot.data ?? false;
          print("has data? $isLoggedIn");
          return MultiBlocProvider(
            providers: [
              BlocProvider<HomePageBloc>(
                create: (context) => HomePageBloc(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
                useMaterial3: true,
              ),
              home: isLoggedIn ? HomePage() : const Login(),
            ),
          );
        });
  }
}
