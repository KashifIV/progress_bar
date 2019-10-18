import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progress_bar/data/Log.dart';
import 'dart:io';
class Task{
  String id;
  String parentID; 
  String name = 'Untitled'; 
  List<String> tags; 
  String notes;
  List<String> urls;
  List<Log> logs; 
  DateTime dateCreated, deadline, dateCompleted; 
  Duration duration; 
  int routine;  
  int order; 
  bool complete = false;
  Task({this.id, this.name, this.complete,this.order, this.notes, this.urls,
        this.dateCreated, this.deadline, this.tags, this.logs, this.routine, this.dateCompleted, this.duration});
  Map<String, dynamic> mapTo(){
     var dataMap = new Map<String, dynamic>();
     if (order != null) {
       dataMap['order'] = order;
       
     }
     else dataMap['order'] = -1;
     if (deadline != null){
       dataMap['deadline'] = deadline; 
     }
     if (routine != null){
       dataMap['routine'] = routine; 
     }
     dataMap['tags'] = tags; 
     dataMap['dateCompleted'] = dateCompleted; 
     dataMap['dateCreated'] = dateCreated; 
     dataMap['notes'] = notes;
     dataMap['urls'] = urls;
     dataMap['duration'] = duration.toString(); 
     dataMap['name'] = name; 
     dataMap['complete'] = complete; 
     return dataMap; 
  }
  factory Task.fromMap(String documentID, Map<String, dynamic> map){
    DateTime parseTime(dynamic date) {
      if (date == null) return null; 
      return Platform.isIOS ? (date as Timestamp).toDate() : (date as DateTime);
    }
    DateTime created; 
    if (map.containsKey('dateCreated')) created = parseTime(map['dateCreated']); 
    else created = DateTime.now(); 
    bool completion = map['complete']; 
    DateTime dead = (map.containsKey('deadline')? parseTime( map['deadline']):null);
    if (map.containsKey('routine') && map['routine'] != null && map.containsKey('dateCompleted')){
     DateTime dateComp = parseTime(map['dateCompleted']); 
     int routine = map['routine']; 
     DateTime now = DateTime.now(); 
     DateTime today = DateTime(now.year, now.month, now.day); 
     if (dateComp != null){
       int difference = dateComp.difference(today).inDays; 
       if (routine == 0 && difference != 0){
         completion = false; 
       }
       else if (routine == 1 ){
         if (created.add(Duration(days: 7)).difference(today).inDays > 0 ){
           completion = false; 
           created = today; 
         }
       }
       else if (routine == 2){
         if (created.add(Duration(days: 30)).difference(today).inDays > 0){
           completion = false; 
           dead = new DateTime(dead.year, dead.month+1, dead.day); 
           created = today;
         }
       }
     }
    }

    Duration duration; 
    String value; 
    if (map.containsKey('duration') && (value = map['duration']) != 'null'){
      duration = Duration(hours: int.parse(value.split(':')[0]), minutes: int.parse(value.split(':')[1])); 
    }
    return new Task(
      id: documentID,
      name: map['name'], 
      complete:  completion,  
      tags: (map.containsKey('tags') &&map['tags'] != null) ? new List<String>.from(map['tags']):null, 
      notes:map['notes'], 
      order: map['order'], 
      deadline: dead, 
      urls: map['urls'], 
      duration: duration,
      routine: (map.containsKey('routine')? map['routine']: null),
      dateCreated: created
    );
  }
  void setLogs(List<Log> logs) {
      this.logs = logs;
      if (logs == null) logs = [];
  }
  void Update(Task task){
    name = task.name;
    tags = task.tags; 
    complete = task.complete;
    order = task.order;
    urls = task.urls;
    notes = task.notes;
  }
}