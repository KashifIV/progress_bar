import 'package:flutter/material.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/ui/task_card.dart';
import 'package:progress_bar/data/Task.dart';
import 'package:progress_bar/ui/project_tags.dart';
class TaskList extends StatelessWidget{
  final int index; 
  final String tag; 
  final bool emergency; 
  final DateTime dayOf; 
  TaskList(this.index, {this.tag, this.emergency = false, this.dayOf});
  List<Widget> _getTaskCards(ViewModel model, Function whiteList){
    if (index == -1){
      List<Task> tasks = []; 
      model.projects.forEach((project){
        tasks..addAll(project.tasks); 
      });
      tasks.removeWhere((task) => task.deadline == null); 
      if (dayOf != null){
        tasks.removeWhere((task)  => !(task.deadline.year == dayOf.year && task.deadline.month == dayOf.month && task.deadline.day == dayOf.day)); 
      }
      tasks.sort((a, b){
        if (a.deadline == null || b.deadline == null) 
          return a.dateCreated.compareTo(b.dateCreated); 
        else
          return a.deadline.compareTo(b.deadline);
        }
      ); 
      List<Widget> cards = []; 

      for (int i = 0; i < tasks.length; i++){
        cards.add(TaskCard(tasks[i], tasks[i].parentIndex, color: model.projects[tasks[i].parentIndex].toColor(),)); 
      }
      return cards; 
    }
    List<Widget> a = [];
    if (model.projects[index].tasks != null){
    for (int i = 0; i < model.projects[index].tasks.length; i++){
      if (model.projects[index].tasks[i].name != null && whiteList(model.projects[index].tasks[i])){
        a.add(TaskCard(model.projects[index].tasks[i], index,));
      }
    }
    }
    if (!a.isEmpty) a.add(SizedBox(height: 20)); 
    return a;
  }
  bool _showIncompleteTask(Task task) {
    if (task.complete == true) 
      return false;
    return true;
  }
  bool _showCompleteTask(Task task){
    if (task.complete == true) return true;
    return false;
  }
  bool _showAllTask(Task task){
    return true;
  }
  bool _showTasksWithTag(Task task){
    if (task.tags == null || tag == null) return false; 
    if (task.tags.contains(tag)) return true; 
    return false; 
  }
  bool _showLaterTasks(Task task){
    if (task.deadline == null && !task.complete) return true;
    else if (!task.complete&&task.deadline.isAfter(DateTime.now().add(Duration(days: 7)))) return true;
    return false; 
  }
  Function getWhiteList(WhiteList whiteList){
    if (emergency){
      return _showLaterTasks; 
    }
    switch(whiteList){
      case WhiteList.complete:
        return _showCompleteTask;
      case WhiteList.incomplete:
        return _showIncompleteTask;
      case WhiteList.all: 
        return _showAllTask;
      case WhiteList.tag: 
        return _showTasksWithTag;
      case WhiteList.emergency: 
        return _showLaterTasks;
    }
  }
  @override
    Widget build(BuildContext context) {
      return StoreConnector<AppState, ViewModel>(
        converter: (Store<AppState> store) => ViewModel.create(store),
        rebuildOnChange: true,
        builder: (BuildContext context, ViewModel model){
          return new SliverList(
            delegate: SliverChildListDelegate(
              _getTaskCards(model, getWhiteList(model.whiteList))
            ),
          );
        },
      );
    }
} 