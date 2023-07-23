import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:todo_app/features/home/bloc/home_page_bloc.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late DateTime dateTime;
  late String dayOfWeek;
  late String date;
  double percentDone = 0;
  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();
    dayOfWeek = DateFormat('EEEE').format(dateTime);
    date = DateFormat('yyyy/MM/dd').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePageBloc, HomePageState>(
      listener: (context, state) {
        if (state is HomePageLoadSuccess) {
          percentDone = state.percentDone;
        }
      },
      builder: (context, state) {
        // if (state is HomePageLoadSuccess) {
        return Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          color: Color.fromARGB(255, 225, 204, 202),
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Have a good day!",
                style: TextStyle(
                  fontSize: 42,
                  color: Colors.blue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Today's $dayOfWeek",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text("$date"),
                    ],
                  ),
                  CircularPercentIndicator(
                    radius: 30,
                    animation: true,
                    animationDuration: 500,
                    lineWidth: 10,
                    percent: percentDone / 100,
                    center: Text(
                      "${percentDone.toStringAsFixed(2)}%",
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    circularStrokeCap: CircularStrokeCap.butt,
                    backgroundColor: Colors.red,
                    progressColor: Colors.green,
                  ),
                ],
              ),
            ],
          ),
        );
        // } else {
        //   return const Text("Header error");
        // }
      },
    );
  }
}
