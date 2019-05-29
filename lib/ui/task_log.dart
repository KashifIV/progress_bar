import 'package:flutter/material.dart';
import 'package:progress_bar/data/Log.dart';
import 'package:progress_bar/data/Task.dart';
import 'package:redux/redux.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/ui/task_tags.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/domain/viewmodel.dart';
class TaskLog extends StatelessWidget{
  final int projid, taskid; 
  TaskLog(this.projid, this.taskid); 
  Widget createLogView(Log log){
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color:  Colors.blueAccent,
        )
      ),
      child: Column(children: <Widget>[
        ListTile(
          leading: CircleAvatar(child: Text((log.account.name[0])),),
          title: Text(log.account.name + ', on ' +  ['January', 'February', 'March', 'April', 'May', 'June', 'July'
          'August', 'September', 'October', 'November', 'December'][log.dateWritten.month] + ' ' + log.dateWritten.day.toString(),
          style: TextStyle(
            fontSize: 20
          ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            log.message,
            textAlign: TextAlign.left,
            softWrap: true,
            style: TextStyle(
              fontSize: 15, 
              
            ),
          ),
        ))
      ],),
    );
  }
  Widget timeBetween(int deltaDays){
    return Container(
      height: 40,
      child: Center( child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
Container(
          height: 20, 
          width: 2,
          decoration: BoxDecoration(
            color: Colors.blueAccent, 
          )
        ), 
        SizedBox(width: 20,),
        Text(
          deltaDays.toString() + ' Days',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
          )
        )
      ],
    )));
  }
  Widget newLogView(ViewModel model){
    final controller = TextEditingController(); 
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color:  Colors.blueAccent,
        )
      ),
      child: Column(children: <Widget>[
        ListTile(
          leading: CircleAvatar(child: Text((model.account.name[0])),),
          title: Text('Create a New Log:',
          style: TextStyle(
            fontSize: 20
          ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: controller,
            onSubmitted: (value){
              Task task = model.projects[projid].tasks[taskid]; 
              if (task.logs == null) task.logs = []; 
              task.logs.add(new Log(account: model.account, dateWritten: DateTime.now(), message: value)); 
              model.onUpdateTask(model.projects[projid], task); 
              model.onUpdateProject(model.projects[projid]); 
              controller.text = ''; 
            },
          )
        ))
      ],),
    );
  }
  List<Widget> _getLogs(Task task){
    List<Widget> logs = [];
    logs.add(SizedBox(height: 10,)); 
    print(task.logs); 
    if (task.logs == null) return logs; 
    int days; 
    DateTime temp; 
    task.logs.forEach((log){
      if (temp != null){
        days = log.dateWritten.difference(temp).inDays; 
      }
      else temp = log.dateWritten;
       if (days == null) logs.add(SizedBox(height: 10,)); 
      else logs.add(Center(child:timeBetween(days))); 
      logs.add(createLogView(log)); 
    });
    if (temp != null){
      logs.add(timeBetween(DateTime.now().difference(temp).inDays)); 
    }
    return logs; 
  }
  @override
  Widget build(BuildContext context) {
    return  StoreConnector<AppState, ViewModel>(
        rebuildOnChange: true,
        converter: (Store<AppState> store) => ViewModel.create(store),
        builder: (BuildContext context, ViewModel model) => Column(
      children: _getLogs(model.projects[projid].tasks[taskid])..add(newLogView(model)),
    )); 
  }
}