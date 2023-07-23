import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/features/home/bloc/home_page_bloc.dart';
import 'package:todo_app/models/task.dart';

class TaskTile extends StatefulWidget {
  TaskTile({super.key, required this.task, required this.color});
  final Task task;
  Color color;
  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageBloc, HomePageState>(
      bloc: BlocProvider.of<HomePageBloc>(context),
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            print("Check click");
            BlocProvider.of<HomePageBloc>(context)
                .add(UpdateButtonClickEvent(widget.task));
          },
          child: Slidable(
            startActionPane:
                ActionPane(motion: const ScrollMotion(), children: [
              SlidableAction(
                backgroundColor: Colors.red,
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
                  color: widget.color, borderRadius: BorderRadius.circular(30)),
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
                            Text(
                              widget.task.title,
                              style: TextStyle(fontSize: 23),
                            ),
                            Text(widget.task.description),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "${widget.task.dueDate.hour.toString()} : ${widget.task.dueDate.minute.toString()} "),
                            ],
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
          ),
        );
      },
    );
  }
}
