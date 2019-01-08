import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:progress_bar/data/Task.dart';
class TaskPage extends StatefulWidget{
  final int projIndex;
  final int taskIndex;
  final Task task;
  TaskPage(this.projIndex, this.taskIndex, {this.task});
  _TaskPage createState() => _TaskPage();
}
class _TaskPage extends State<TaskPage>{
  final notes = TextEditingController();
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      if (widget.task.notes == null){
        notes.text = widget.task.notes;
      }
    }
  @override
    Widget build(BuildContext context) {
      return StoreConnector<AppState, ViewModel>(
        converter: (Store<AppState> store) => ViewModel.create(store),
        builder: (BuildContext context, ViewModel model) => Scaffold(
          body: Column(
            children: <Widget>[
              new Text(model.projects[widget.projIndex].tasks[widget.taskIndex].name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
              new TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 15,
                controller: notes,
                onEditingComplete: (){
                  widget.task.notes = notes.text;
                  model.onUpdateTask(model.projects[widget.projIndex], widget.task);
                },
              )
            ],
          ),
        )
      );
    }
}