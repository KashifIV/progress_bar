import 'package:progress_bar/data/Log.dart';

class Task{
  String id;
  int parentIndex; 
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
    DateTime created; 
    if (map.containsKey('dateCreated')) created = map['dateCreated']; 
    else created = DateTime.now(); 
    bool completion = map['complete']; 
    DateTime dead = (map.containsKey('deadline')? map['deadline']:null);
    if (map.containsKey('routine') && map['routine'] != null && map.containsKey('dateCompleted')){
     DateTime dateComp = map['dateCompleted']; 
     int routine = map['routine']; 
     if (dateComp != null){
       if (routine == 0 && dateComp.day != DateTime.now().day){
         completion = false; 
       }
       else if (routine == 1 ){
         if (dead.difference(dateComp).inDays > 0 ){
           completion = false; 
           dead.add(Duration(days: 7)); 
         }
       }
       else if (routine == 2){
         if (dead.difference(dateComp).inDays > 0){
           completion = false; 
           dead = new DateTime(dead.year, dead.month+1, dead.day); 
         }
       }
     }
    }

    Duration duration; 
    String value; 
    if (map.containsKey('duration') && (value = map['duration']) != 'null'){
      duration = Duration(hours: int.parse(value.split(':')[0]), minutes: int.parse(value.split(':')[1])); 
      print(duration.toString()); 
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