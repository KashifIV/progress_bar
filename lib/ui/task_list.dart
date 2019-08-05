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
    if (emergency && (model.projects[index].tasks == null || model.projects[index].tasks.length == 0)){
      return [
        Center(child:Text('Click Below to Open the Project!', style: TextStyle(color: model.account.darkTheme ? Colors.white: Colors.black
        ),))
      ];
    }
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
        cards.add(TaskCard(tasks[i], model.projects.indexWhere((test) => tasks[i].parentID == test.id) , color: model.projects.firstWhere((test) => tasks[i].parentID == test.id).toColor(),)); 
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
    if (a.isNotEmpty ) a.add(SizedBox(height: 30)); 
    if (a.isEmpty && emergency) a.add(
      Center(
        child: Text(
          'Congratulations!\nAll your tasks are complete!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: (model.account.darkTheme) ? Colors.white : Colors.black, 
            fontSize: 20,

          ),
        ),
      )
    );
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
  bool _showRoutineDaily(Task task){
    if (task.routine == 0 && !task.complete) return true; 
    return false;  
  }
  bool _showRoutineWeekly(Task task){
    if (task.routine == 1 && !task.complete) return true; 
    return false;
  }
  bool _showRoutineMonthly(Task task){
    if (task.routine == 2 && !task.complete) return true; 
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
      case WhiteList.routine_daily:
        return _showRoutineDaily; 
      case WhiteList.routine_monthly:
        return _showRoutineMonthly; 
      case WhiteList.routine_weekly: 
        return _showRoutineWeekly;
      default: return _showIncompleteTask;
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