import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/ui/task_log.dart';
import 'package:redux/redux.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/ui/task_tags.dart';
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:progress_bar/data/Task.dart';

import 'date_options.dart';

class TaskPage extends StatefulWidget {
  final int projIndex;
  final int taskIndex;
  final Task task;
  TaskPage(this.projIndex, this.taskIndex, {this.task});
  _TaskPage createState() => _TaskPage();
}

class _TaskPage extends State<TaskPage> {
  final notes = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.task.notes != null) {
      notes.text = widget.task.notes;
    }
  }

  Future<bool> onPop(ViewModel model) {
    widget.task.notes = notes.text;
    model.onUpdateTask(model.projects[widget.projIndex], widget.task);
    return Future.value(true);
  }

  Widget Notes(ViewModel model, BuildContext context) {
    return new Column(children: <Widget>[
      Container(
        padding: EdgeInsets.all(10),
        child: Text(
          'Notes',
          style: TextStyle(
            fontSize: 18,
          ),
          textAlign: TextAlign.left,
        ),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        decoration: BoxDecoration(color: Colors.white),
        child: TextField(
          autocorrect: true,
          decoration: InputDecoration(
            hasFloatingPlaceholder: false,
          ),
          keyboardType: TextInputType.multiline,
          maxLines: 15,
          controller: notes,
          onEditingComplete: () {
            widget.task.notes = notes.text;
            model.onUpdateTask(model.projects[widget.projIndex], widget.task);
          },
        ),
      )
    ]);
  }

  Widget _title(String title) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Text(
        title,
        softWrap: true,
        style: TextStyle(fontSize: 40),
      ),
    );
  }

  Widget _datePicker(BuildContext context, ViewModel model) {
    String ans = (model
                .projects[widget.projIndex].tasks[widget.taskIndex].deadline ==
            null)
        ? 'Add a Deadline.'
        : model.projects[widget.projIndex].tasks[widget.taskIndex].deadline
                .difference(DateTime.now())
                .inDays
                .toString() +
            ' Day(s) Remaining \n' +
            model.projects[widget.projIndex].tasks[widget.taskIndex].deadline
                .toString()
                .substring(0, 10);
    return DateOptions(
      deadline:
          model.projects[widget.projIndex].tasks[widget.taskIndex].deadline,
      onDeadlineChange: (value) {
        if (model.projects[widget.projIndex].tasks[widget.taskIndex].routine == null || model.projects[widget.projIndex].tasks[widget.taskIndex].routine <
            1 ) {
          model.projects[widget.projIndex].tasks[widget.taskIndex].deadline =
              value;
        } else {
          Task t = model.projects[widget.projIndex].tasks[widget.taskIndex];
          t.deadline = value; 
          if (t.routine == 1 && t.deadline.difference(DateTime.now()).inDays > 7) {
            t.deadline = DateTime.now().add(Duration(days: 7));
          } else if (t.routine== 2 &&
              t.deadline
                      .difference(DateTime.now().add(Duration(days: 31)))
                      .inDays <
                  31) {
            t.deadline = DateTime(DateTime.now().year,
                (DateTime.now().month + 1) % 12, DateTime.now().day);
          }
          model.projects[widget.projIndex].tasks[widget.taskIndex].deadline = t.deadline; 
        }
        model.onUpdateTask(model.projects[widget.projIndex],
            model.projects[widget.projIndex].tasks[widget.taskIndex]);
      },
      routine: model.projects[widget.projIndex].tasks[widget.taskIndex].routine,
      onRoutineChange: (value) {
        Task t = model.projects[widget.projIndex].tasks[widget.taskIndex];
        t.routine = value;
        if (value == 1 && t.deadline.difference(DateTime.now()).inDays > 7) {
          t.deadline = DateTime.now().add(Duration(days: 7));
        } else if (value == 2 &&
            t.deadline
                    .difference(DateTime.now())
                    .inDays >
                31) {
          t.deadline = DateTime(DateTime.now().year,
              (DateTime.now().month + 1) % 12, DateTime.now().day);
        }
        model.onUpdateTask(model.projects[widget.projIndex], t);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
        rebuildOnChange: true,
        converter: (Store<AppState> store) => ViewModel.create(store),
        builder: (BuildContext context, ViewModel model) => WillPopScope(
            onWillPop: () => onPop(model),
            child: Scaffold(
                body: SafeArea(
                    child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(<Widget>[]
                    ..add(_title(model.projects[widget.projIndex]
                        .tasks[widget.taskIndex].name))
                    ..add(TaskTags(widget.projIndex, widget.taskIndex))
                    ..add(_datePicker(context, model))
                    ..add(TaskLog(widget.projIndex, widget.taskIndex))
                    ..add(Notes(model, context))),
                )
              ],
            )))));
  }
}
