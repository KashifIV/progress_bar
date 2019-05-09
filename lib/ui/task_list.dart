import 'package:flutter/material.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/ui/task_card.dart';
import 'package:progress_bar/data/Task.dart';
class TaskList extends StatelessWidget{
  final int index; 
  TaskList(this.index);
  List<Widget> _getTaskCards(ViewModel model, Function whiteList){
    List<Widget> a = [];

    if (model.projects[index].tasks != null){
    for (int i = 0; i < model.projects[index].tasks.length; i++){
      if (model.projects[index].tasks[i].name != null && whiteList(model.projects[index].tasks[i])){
        a.add(TaskCard(model.projects[index].tasks[i], index));
      }
    }
    }
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
  Function getWhiteList(WhiteList whiteList){
    switch(whiteList){
      case WhiteList.complete:
        return _showCompleteTask;
      case WhiteList.incomplete:
        return _showIncompleteTask;
      case WhiteList.all: 
        return _showAllTask;
    }
  }
  @override
    Widget build(BuildContext context) {
      return StoreConnector<AppState, ViewModel>(
        converter: (Store<AppState> store) => ViewModel.create(store),
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