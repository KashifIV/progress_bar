import 'Task.dart';
import 'package:flutter/material.dart';
import 'package:progress_bar/domain/redux.dart';

class Project {
  String name;
  String id;
  String description;
  String color, projType;
  int index;
  List<Task> tasks = [];
  List<String> tags;
  PageType state = PageType.UND;
  Project(this.name, this.description, this.color, this.projType,
      {this.tags, this.id, this.tasks, this.index}) {
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
    this.tasks = tasks;
    if (tags == null) tags = [];
    tasks.forEach((task) {
      if (task.tags != null) {
        task.tags.forEach((tag) {
          if (!tags.contains(tag)) tags.add(tag);
        });
      }
    });
  }

  Map<String, dynamic> mapTo(String id) {
    var dataMap = new Map<String, dynamic>();
    dataMap['name'] = this.name;
    dataMap['description'] = this.description;
    dataMap['color'] = this.color;
    dataMap['user'] = id;
    dataMap['tags'] = tags;
    return dataMap;
  }

  Map<String, dynamic> mapWithoutID() {
    var dataMap = new Map<String, dynamic>();
    dataMap['name'] = this.name;
    dataMap['description'] = this.description;
    dataMap['color'] = this.color;
    dataMap['tags'] = tags;
    return dataMap;
  }

  Project.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.description = map['description'];
    this.color = map['color'];
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
    tasks.add(t);
  }

  void Update(Project proj) {
    tasks = proj.tasks;
    description = proj.description;
    projType = proj.projType;
    color = proj.color;
    name = proj.name;
  }
}
