class Task{
  String id;
  String name = 'Untitled', stage = 'none', phase = 'none';
  String notes;
  List<String> urls;
  int order; 
  bool complete = false;
  Task({this.id, this.name, this.complete, this.stage, this.phase,this.order, this.notes, this.urls});
  Map<String, dynamic> mapTo(){
     var dataMap = new Map<String, dynamic>();
     if (order != null) {
       dataMap['order'] = order;
     }
     else dataMap['order'] = -1;
     dataMap['notes'] = notes;
     dataMap['urls'] = urls;
     dataMap['name'] = name; 
     dataMap['stage'] = stage; 
     dataMap['phase'] = phase; 
     dataMap['complete'] = complete; 
     return dataMap; 
  }
  void Update(Task task){
    name = task.name;
    stage = task.stage;
    phase = task.stage;
    complete = task.complete;
    order = task.order;
    urls = task.urls;
    notes = task.notes;
  }
}