import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart'; 
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:progress_bar/data/Task.dart';
import 'package:progress_bar/domain/redux.dart';

class TaskTags extends StatelessWidget{
  final int projIndex, taskIndex; 
  TaskTags(this.projIndex, this.taskIndex); 
  Widget _createChip(String tag, ViewModel model){
    return ActionChip(
      label: Text(
          tag, 
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        onPressed: (){
          Task task = model.projects[projIndex].tasks[taskIndex]; 
          if (task.tags == null){
            task.tags = [tag]; 
          }
          else if (task.tags.contains(tag)){
            task.tags.remove(tag);
          }
          else {
            task.tags.add(tag); 
          }
          model.onUpdateTask(model.projects[projIndex], task); 
        },
        backgroundColor: Colors.yellow,      
    );
  }
  Widget _taskTags(List<String> tags, ViewModel model){
    if  (tags == null)return SizedBox(height: 20,);
    List<Widget> tagChips = []; 
    tags.forEach((tag)=> tagChips.add(_createChip(tag, model)));
    return Container(
      child: Wrap(
        children: tagChips,
        spacing: 20.0, 
      ),
    );
  }
  Widget _projectTags(List<String> tags, List<String> used, ViewModel model){
    List<String> options = (used != null) ? tags.where((tag) => !used.contains(tag)).toList(): tags;
    List<Widget> tagChips = []; 
    options.forEach((tag) => tagChips.add(_createChip(tag, model))); 
    return Container(
      color: Colors.grey,
      child: Wrap(
        children: tagChips,
        spacing: 20.0,
      )
    ); 
  }
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      converter: (Store<AppState> store) => ViewModel.create(store),
      builder: (BuildContext context, ViewModel model)=> Container(
        child: Column(
          children: <Widget>[
            _taskTags(model.projects[projIndex].tasks[taskIndex].tags, model),
            SizedBox(height: 30,),
            _projectTags(model.projects[projIndex].tags, 
            model.projects[projIndex].tasks[taskIndex].tags,
            model)
          ],
        )
      ),
    );
  }
}