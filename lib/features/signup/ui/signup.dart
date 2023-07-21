import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/signup/bloc/bloc/signup_bloc.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController userName = TextEditingController();

  final TextEditingController password = TextEditingController();

  final TextEditingController confirmPassword = TextEditingController();

  final SignUpBloc _signUpBloc = SignUpBloc();

  @override
  void initState() {
    _signUpBloc.add(SignUpInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccessState) {
            Navigator.pop(context);
          }
        },
        buildWhen: (previous, current) => current is! SignUpSuccessState,
        bloc: _signUpBloc,
        builder: (context, state) {
          if (state.runtimeType == SignUpLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.runtimeType == SignUpInitial) {
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
                    _signupBtn(context),
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

  Widget _signupBtn(BuildContext context) {
    return Container(
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
          'Sign Up',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final String enteredUserName = userName.text;
            final String enteredPassword = password.text;
            _signUpBloc.add(
              SignUpBtnClickedEvent(enteredUserName, enteredPassword),
            );
          }
        },
      ),
    );
  }

  Widget _passwordField() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: TextFormField(
            controller: password,
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
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: TextFormField(
            controller: confirmPassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              if (value != password.text) {
                return 'Passwords do not match';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Confirm password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            obscureText: true,
          ),
        )
      ],
    );
  }

  Widget _userNameField() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: TextFormField(
        controller: userName,
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

  Widget _header() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 70),
      child: const Text(
        "Register new account",
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
      ),
    );
  }
}
