import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/features/home/bloc/home_page_bloc.dart';
import 'package:todo_app/features/home/ui/add_update_ask.dart';
import 'package:todo_app/features/home/ui/widget/header.dart';
import 'package:todo_app/features/home/ui/widget/task_title.dart';
import 'package:todo_app/helper/taskhelper.dart';
import 'package:todo_app/sf/notification.dart';
import 'package:todo_app/sf/preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int sliding = 0;

  String? userId;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    TaskHelper.instance.init();
    BlocProvider.of<HomePageBloc>(context).add(HomePageLoadData(sliding));
    _getUserId();
  }

  void _getUserId() async {
    userId = await Preferences.instance.getUser();
  }

  Color getColor(int index) {
    Color color;
    if (index % 3 == 0) {
      color = Colors.blueAccent;
    } else if (index % 2 == 1) {
      color = Colors.yellowAccent;
    } else {
      color = Colors.blueGrey;
    }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('This is a notification')),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<HomePageBloc, HomePageState>(
        bloc: BlocProvider.of<HomePageBloc>(context),
        buildWhen: (previous, current) =>
            current is! HomePageNavigate && current is! HomePageMessage,
        listener: (context, state) {
          if (state is HomePageAddButtonClickedState) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddOrUpdateTask(userId: userId!);
            }));
          } else if (state is HomePageUpdateButtonClickedState) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddOrUpdateTask(
                userId: userId!,
                task: state.task,
              );
            }));
          } else if (state is AddedTaskSuccessState) {
            BlocProvider.of<HomePageBloc>(context)
                .add(HomePageLoadData(sliding));
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Added a new task")));
          } else if (state is DeletedTaskSuccessState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Deleted")));
            BlocProvider.of<HomePageBloc>(context)
                .add(HomePageLoadData(sliding));
          } else if (state is CompletedTaskSuccessState) {
            BlocProvider.of<HomePageBloc>(context)
                .add(HomePageLoadData(sliding));
          } else if (state is UpdatedTaskSuccessState) {
            BlocProvider.of<HomePageBloc>(context)
                .add(HomePageLoadData(sliding));
          }
        },
        builder: (context, state) {
          if (state is HomePageLoadSuccess) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Header(),
                SizedBox(
                  height: 50,
                  child: CupertinoSlidingSegmentedControl<int>(
                    groupValue: sliding,
                    onValueChanged: (value) {
                      setState(() {
                        sliding = value!;
                        print("Sliding $sliding");
                        BlocProvider.of<HomePageBloc>(context)
                            .add(HomePageLoadData(sliding));
                      });
                    },
                    children: const <int, Widget>{
                      0: Text('Mon'),
                      1: Text('Tue'),
                      2: Text('Wed'),
                      3: Text('Thu'),
                      4: Text('Fri'),
                      5: Text('Sat'),
                      6: Text('Sun'),
                    },
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: <Widget>[
                      ListView.builder(
                        itemCount: state.listTask.length,
                        itemBuilder: ((context, index) {
                          return TaskTile(
                            task: state.listTask[index],
                            color: getColor(index),
                          );
                        }),
                      )
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Text("Homepage Error");
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BlocProvider.of<HomePageBloc>(context).add(AddButtonClickedEvent());
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
