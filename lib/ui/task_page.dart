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
      super.initState();
      if (widget.task.notes != null){
        notes.text = widget.task.notes;
      }
    }
  Future<bool> onPop(ViewModel model){
    widget.task.notes = notes.text;
    model.onUpdateTask(model.projects[widget.projIndex], widget.task);
    return Future.value(true);
  }
  Widget Notes(ViewModel model, BuildContext context){
    return new Container(
      padding: EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width*0.9,
      decoration: BoxDecoration(
        color: model.projects[widget.projIndex].toColor(),
        borderRadius: BorderRadius.circular(12),
        boxShadow:  <BoxShadow>[
          BoxShadow(
            offset: Offset(1.0, 1.0),
            blurRadius: 3.0,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          BoxShadow(
            offset: Offset(2.0, 2.0),
            blurRadius: 8.0,
            color: Color.fromARGB(125, 0, 0, 255),
          ),
        ]
      ),
      child: new Column(
        children: <Widget>[
          Center(
            child: Text(
              'Notes',
              style: TextStyle(
                color: Colors.white, 
                fontSize: 24,
              ),
            )
          ),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow:  <BoxShadow>[
                BoxShadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 3.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                BoxShadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 8.0,
                  color: Color.fromARGB(125, 0, 0, 255),
                ),
              ]
            ),
            child: TextField(
              autocorrect: true,
              decoration: InputDecoration(
                hasFloatingPlaceholder: false,                
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 15,
              controller: notes,
              onEditingComplete: (){
                widget.task.notes = notes.text;
                model.onUpdateTask(model.projects[widget.projIndex], widget.task);
              },
            ),
          )
        ],
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
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 100,
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(model.projects[widget.projIndex].tasks[widget.taskIndex].name,            
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 30,
                  ),
                  ),
                  centerTitle: true,
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[]..add(Notes(model, context))
                ),
              )
            ],
          )
        )
      ));
    }
}