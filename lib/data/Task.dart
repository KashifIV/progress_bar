import 'package:progress_bar/data/Log.dart';

class Task{
  String id;
  String name = 'Untitled'; 
  List<String> tags; 
  String notes;
  List<String> urls;
  List<Log> logs; 
  DateTime dateCreated, deadline; 
  int order; 
  bool complete = false;
  Task({this.id, this.name, this.complete,this.order, this.notes, this.urls,
        this.dateCreated, this.deadline, this.tags, this.logs});
  Map<String, dynamic> mapTo(){
     var dataMap = new Map<String, dynamic>();
     if (order != null) {
       dataMap['order'] = order;
       
     }
     else dataMap['order'] = -1;
     if (deadline != null){
       dataMap['deadline'] = deadline; 
     }
     dataMap['tags'] = tags; 
     dataMap['dateCreated'] = dateCreated; 
     dataMap['notes'] = notes;
     dataMap['urls'] = urls;
     dataMap['name'] = name; 
     dataMap['complete'] = complete; 
     return dataMap; 
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