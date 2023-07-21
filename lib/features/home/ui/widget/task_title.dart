import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/features/home/bloc/home_page_bloc.dart';
import 'package:todo_app/models/task.dart';

class TaskTile extends StatefulWidget {
  TaskTile({super.key, required this.task});
  final Task task;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageBloc, HomePageState>(
      bloc: BlocProvider.of<HomePageBloc>(context),
      builder: (context, state) {
        return Slidable(
          startActionPane: ActionPane(motion: const ScrollMotion(), children: [
            SlidableAction(
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              onPressed: (BuildContext context) {
                BlocProvider.of<HomePageBloc>(context)
                    .add(DeleteTaskEvent(widget.task));
              },
            ),
          ]),
          child: Container(
            width: double.infinity,
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 208, 166, 164),
                borderRadius: BorderRadius.circular(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.task.title),
                          const Text("Des"),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text("2h50'"), Text("duc")],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 80,
                  width: 80,
                  child: ElevatedButton(
                    onPressed: () {
                      print("Done task");
                      BlocProvider.of<HomePageBloc>(context)
                          .add(CompleteTaskEvent(widget.task));
                    },
                    child: const Icon(Icons.done),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            120), // Thiết lập bo góc cho nút
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
