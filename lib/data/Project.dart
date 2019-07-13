import 'Task.dart';
import 'package:flutter/material.dart';
import 'package:progress_bar/domain/redux.dart';

class Project {
  String name;
  String id;
  List<String> users = []; 
  String description;
  DateTime deadline, dateCreated; 
  String color, projType;
  int index;
  List<Task> tasks = [];
  List<String> tags;
  int tasksComplete, tasksToDo; 
  PageType state = PageType.UND;
  Project(this.name, this.description, this.color, this.projType,
      {this.tags, this.id, this.tasks, this.index, this.users, this.deadline, this.dateCreated}) {
    if (this.tasks == null) {
      tasks = [];
      tags = ["Important"];
    } else if (tags == null || tags.length <= 0) {
      tags = [];
      tasks.forEach((task) {
        if (task.tags != null) {
          task.tags.forEach((tag) {
            if (!tags.contains(tag)) tags.add(tag);
          });
        }
      });
    }
  }
  void setTasks(List<Task> tasks) {
    tasksComplete = 0; 
    tasksToDo = 0; 
    this.tasks = tasks;
    this.tasks.forEach((task) => task.parentIndex = index);
    if (tags == null) tags = [];
    tasks.forEach((task) {
      if (task.tags != null) {
        task.tags.forEach((tag) {
          if (!tags.contains(tag)) tags.add(tag);
        });
      }
      if (task.complete) tasksComplete++; 
      else tasksToDo++;
    });
  }

  Map<String, dynamic> mapTo(String id) {
    var dataMap = new Map<String, dynamic>();
    dataMap['name'] = this.name;
    dataMap['description'] = this.description;
    dataMap['color'] = this.color;
    dataMap['user'] = id;
    dataMap['tags'] = tags;
    dataMap['deadline'] = deadline; 
    dataMap['dateCreated'] = dateCreated; 
    return dataMap;
  }

  Map<String, dynamic> mapWithoutID() {
    var dataMap = new Map<String, dynamic>();
    dataMap['name'] = this.name;
    dataMap['description'] = this.description;
    dataMap['color'] = this.color;
    dataMap['tags'] = tags;
    dataMap['deadline'] = deadline; 
    dataMap['dateCreated'] = dateCreated; 
    return dataMap;
  }

  factory Project.fromMap(Map<String, dynamic> map, List<String> tags, String documentID, {int count}) {
    return Project(
      map['name'],
      map['description'], 
      map['color'], 
      'Project', 
      tags: tags,
      id: documentID, 
      deadline: (map.containsKey('deadline')) ? map['deadline'] : null,
      dateCreated: (map.containsKey('dateCreated')) ? map['dateCreated']: DateTime.now(), 
      index: count
    );
  }
  double getPercentComplete(String tag) {
    if (tag == null) {
      if (tasks == null || tasks.isEmpty) {
        return 0.1;
      }
      int count = 0;
      tasks.forEach((task) {
        if (task.complete) {
          count++;
        }
      });
      if (tasks.length == 0)return 0;
      return count.toDouble() / tasks.length.toDouble();
    }
    else {
      List<Task> tasksWithTag = tasks.where((task) => task.tags != null && task.tags.contains(tag)).toList(); 
      if (tasks.length== 0 || tasksWithTag.length == 0)
        return 0; 
      double count = tasksWithTag.fold(0, (value, task)=> value+ ((task.complete)? 1: 0))/tasksWithTag.length;
      if (count == null)
        return 0; 
      return count;
    }
  }
  String getRatio(String tag){
     List<Task> tasksWithTag = tasks.where((task) => task.tags != null && task.tags.contains(tag)).toList(); 
     if (tasksWithTag.length == 0){
       return '0/0';
     }
     int count = tasksWithTag.fold(0, (value, task)=> value+ ((task.complete)? 1: 0));
     return count.toString() + '/' + tasksWithTag.length.toString(); 
  }

  Color toColor() {
    if (color == null) {
      return Colors.pink;
    }
    String c = color;
    c = c.replaceRange(0, c.length - 12, '');
    c = c.replaceRange(c.length - 2, c.length, '');
    return new Color(int.parse(c));
  }

  bool AddTask(Task t) {
    if (t.order == null) t.order = tasks.length;
    if (t.complete) tasksComplete++; 
    else tasksToDo++; 
    tasks.add(t);
  }
  List<double> totalvsFinishedTime(){
    double complete = 0; 
    double total = 0; 
    int defaultValue = 30; 
    tasks.forEach((task){
      if (task.duration != null){
        total += task.duration.inMinutes; 
        if (task.complete) complete += task.duration.inMinutes; 
      }
      else {
        total+=defaultValue; 
        if (task.complete) complete+= defaultValue;
      }
    });
    return [total, complete]; 
  }
  void Update(Project proj) {
    tasks = proj.tasks;
    description = proj.description;
    projType = proj.projType;
    color = proj.color;
    name = proj.name;
  }
  void updateSettings(Project proj){
    description = proj.description; 
    projType = proj.projType; 
    deadline = proj.deadline; 
    color = proj.color; 
    name = proj.name; 
  }
}
