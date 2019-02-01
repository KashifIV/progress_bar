import 'dart:async';
import 'dart:io' show Platform;
import 'auth.dart';
import 'Project.dart';
import 'Task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> CreateProject(Project proj, Auth auth) async{
    DocumentReference ref; 
     auth.getCurrentUser().then((userid){
      Firestore.instance.runTransaction((transaction) async{
        ref = Firestore.instance.collection('Projects').document();
        proj.id = ref.documentID;  
        await transaction.set(ref, proj.mapTo(userid));       
      });
    }); 
    
}
Future<void> CreateTask(Project proj, Task t) async{
    await Firestore.instance.runTransaction((transaction) async {
      CollectionReference a = Firestore.instance.collection('Projects/' + proj.id +'/tasks');
      DocumentReference ref = a.document(); 
      t.id = ref.documentID; 
      await transaction.set(ref, t.mapTo()); 
    }
  );
}
Future<void> UpdateProject(Project proj) async{
    await UpdateTasks(proj);
    Firestore.instance.runTransaction((transaction)async{
      await transaction.update(Firestore.instance.collection('Projects').document(), proj.mapWithoutID());
    });
  }
  Future<void> UpdateTasks(Project proj)async{
    CollectionReference ref = Firestore.instance.collection('Projects/' + proj.id +'/tasks'); 
    await ref.getDocuments().then((values){
      values.documents.forEach((doc){
        if (doc.exists){
          Task t = proj.tasks.firstWhere((test) => test.id == doc.documentID);
          Firestore.instance.document('Projects/' + proj.id +'/tasks' + doc.documentID)
            .updateData(t.mapTo()).catchError((e) => print('UPDATE FAILED'));
        }
      });
    });
  }
  Future<void> UpdateTask(Project proj, Task task) async{
    if (task.name != null){
    print(task.id);
    await Firestore.instance.document('Projects/' + proj.id +'/tasks/'+ task.id).updateData(task.mapTo()).catchError((e) => print('Error Updating Task'));
    }
  }
  Future<List<Task>>getProjectTasks(String id) async {
    CollectionReference ref = Firestore.instance.collection('Projects/' + id +'/tasks');
    QuerySnapshot s = await ref.getDocuments(); 
    List<Task> t = []; 
    s.documents.forEach((task){
      if (task['name'] != null){
          t.add(new Task(id: task.documentID, name: task['name'], complete: task['complete'], phase: task['phase'],stage: task['stage'], notes:task['notes'], order: task['order'], urls: task['urls']));
      }
    }); 
    return t; 
  }
  Future<List<Project>> getProjects(Auth auth) async {
    List<Project> a = [];
    await auth.getCurrentUser().then((userid) async {
      QuerySnapshot snapshot =  await Firestore.instance.collection('Projects')
          .where('user', isEqualTo: userid)
          .getDocuments();
      int count = 0;
      snapshot.documents.forEach((document)  {
          Project proj = new Project(document['name'], document['description'], document['color'], 'Project', id: document.documentID, index: count);  
          count++;   
          a.add(proj);
      });
    });
    return a;
  }
  Future<bool> DeleteProject(Project proj) async{
    print(proj.id);
    await Firestore.instance.collection('Projects').document(proj.id).delete();
    return true;
  }
  Future<bool> DeleteTask(Project proj, Task t)async{
    CollectionReference ref = Firestore.instance.collection('Projects/' + proj.id +'/tasks'); 
    await ref.document(t.id).delete();
    return true;
  }
class CRUD{
   final Firestore db = Firestore.instance;
  CollectionReference projectCollection;
  final AuthImpl auth;
  CRUD({this.auth}){
    projectCollection = db.collection('Projects');
  }
}