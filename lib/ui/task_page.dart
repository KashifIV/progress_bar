import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/ui/task_log.dart';
import 'package:redux/redux.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/ui/task_tags.dart';
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:progress_bar/data/Task.dart';

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
    String ans = (model.projects[widget.projIndex].tasks[widget.taskIndex].deadline == null)? 
      'Add a Deadline.': model.projects[widget.projIndex].tasks[widget.taskIndex].deadline.difference(DateTime.now()).inDays.toString() + ' Day(s) Remaining \n'+
        model.projects[widget.projIndex].tasks[widget.taskIndex].deadline.toString().substring(0,10);
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: FlatButton(
            child: Text(
              ans,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: model.projects[widget.projIndex].toColor(),
              
                fontSize: 23, 
              ),
              ),
            onPressed: () => showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2019),
                    lastDate: DateTime(2030),
                    builder: (BuildContext context, Widget child) {
                      return Theme(
                        data: ThemeData.light(),
                        child: child,
                      );
                    }).then((onValue) {
                  model.projects[widget.projIndex].tasks[widget.taskIndex]
                      .deadline = onValue;
                  model.onUpdateTask(model.projects[widget.projIndex],
                      model.projects[widget.projIndex].tasks[widget.taskIndex]);
                }),
          ),
        ),
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
