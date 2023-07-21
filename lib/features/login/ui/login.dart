import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/home/ui/home_page.dart';
import 'package:todo_app/features/login/bloc/login_bloc.dart';
import 'package:todo_app/features/login/bloc/login_event.dart';
import 'package:todo_app/features/signup/ui/signup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final LoginBloc _loginBloc = LoginBloc();

  @override
  void initState() {
    _loginBloc.add(LoginInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSubmitFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Couldn't find your account")));
          }
          if (state is LoginSubmitSuccessState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        },
        bloc: _loginBloc,
        buildWhen: (previous, current) =>
            current is! LoginSubmitFailed &&
            current is! LoginSubmitSuccessState,
        builder: (context, state) {
          if (state is LoginInitialState) {
            return Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _header(),
                    _userNameField(),
                    _passwordField(),
                    _functionField(context),
                  ],
                ),
              ),
            );
          } else {
            return const Text("Error");
          }
        },
      ),
    );
  }

  Widget _header() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 50),
      child: const Column(
        children: [
          Text(
            "Welcome to Todo App",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
          Text(
            "Stay organized, accomplish more with our Todo App!",
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _userNameField() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: TextFormField(
        controller: _username,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'Username',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: TextFormField(
        controller: _password,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        obscureText: true,
      ),
    );
  }

  Widget _functionField(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
            ),
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final username = _username.text;
                final password = _password.text;
                _loginBloc.add(LoginSubmitClickedEvent(username, password));
              }
            },
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        TextButton(
          onPressed: () {
            print("Check btn create");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignUp(),
              ),
            );
          },
          child: const Text(
            "Create new account",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
