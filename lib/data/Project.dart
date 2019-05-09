import 'Task.dart';
import 'package:flutter/material.dart';
import 'package:progress_bar/domain/redux.dart';
class Project{
  String name;
  String id;
  String description;
  String color, projType;
  int index;
  List<Task> tasks = [];
  List<String> tags; 
  PageType state = PageType.UND;
  Project(this.name, this.description,this.color, this.projType, {this.id, this.tasks, this.index}){
    if (this.tasks == null){
      tasks =[]; 
      tags = ["Important"]; 
    }else if (tags == null || tags.length <= 0){
      tasks.forEach((task){
        if (task.tags != null){
          task.tags.forEach((tag){
            if (!tags.contains(tag)) tags.add(tag); 
          }); 
        }
      });
    }
  }
  Map<String, dynamic> mapTo(String id){
    var dataMap = new Map<String, dynamic>();
    dataMap['name'] =  this.name;
    dataMap['description'] = this.description;
    dataMap['color'] = this.color;
    dataMap['user'] = id;
    return dataMap;
  }
  Map<String, dynamic> mapWithoutID(){
    var dataMap = new Map<String, dynamic>();
    dataMap['name'] =  this.name;
    dataMap['description'] = this.description;
    dataMap['color'] = this.color;
    return dataMap;
  }
  Project.fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.name = map['name'];
    this.description = map['description'];
    this.color = map['color'];
  }
  double getPercentComplete(){
    if (tasks == null || tasks.isEmpty){
      return 0.1;
    }
    int count = 0; 
    tasks.forEach((task){
      if (task.complete){
        count++;
      }
    });
    print(count.toDouble()/tasks.length.toDouble());
    return count.toDouble()/tasks.length.toDouble();
  }
  Color toColor(){
    if (color == null){
      return Colors.pink;
    }
    String c = color; 
    c = c.replaceRange(0, c.length-12, ''); 
    c = c.replaceRange(c.length-2, c.length, ''); 
    return new Color(int.parse(c)); 
  }
  bool AddTask(Task t){
    if (t.order == null) t.order = tasks.length;
    tasks.add(t); 
  }
  void Update(Project proj){
    tasks = proj.tasks;
    description = proj.description;
    projType = proj.projType;
    color = proj.color;
    name = proj.name;
  }
}