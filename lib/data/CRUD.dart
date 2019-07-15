import 'dart:async';
import 'dart:io' show Platform;
import 'package:progress_bar/data/Account.dart';
import 'package:progress_bar/data/Log.dart';

import 'auth.dart';
import 'Project.dart';
import 'Task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<Account> UpdateUser(Auth auth, Account account) async{
  
  DocumentReference ref = Firestore.instance.document('Accounts/' +auth.getUID()); 
  ref.get().then((snapshot){
    if (snapshot.exists){
      ref.updateData(account.mapTo()); 
    }
    else{
      CreateUser(auth, account); 
    }
  }); 
  return account; 
}
Future<void> createAuthenticationDoc(Account account, Project project, List<String> users)async {
  Map<String, dynamic> dataMap = new Map<String, dynamic>(); 
  dataMap = {
    'Owner' : account.id, 
    'users' : users, 

  }; 
  await Firestore.instance.runTransaction((transaction) async{
    DocumentReference ref = Firestore.instance.document('Projects/' + project.id + '/Authentication/permissions');
     await transaction.set(ref, dataMap); 
  });
}
Future<Account> CreateUser(Auth auth, Account account)async{
  await Firestore.instance.runTransaction((transaction) async{
    CollectionReference a = Firestore.instance.collection('Accounts'); 
    DocumentReference ref = a.document(auth.getUID()); 
    await transaction.set(ref, account.mapTo()); 
  });
  return account; 
}
Future<String> FindEmailID(String email)async{
  String id; 
  try{
    await Firestore.instance.runTransaction((transaction) async{
      CollectionReference ref = Firestore.instance.collection('Accounts');
      QuerySnapshot doc = await ref.where('email', isEqualTo: email).getDocuments();
      id = doc.documents[0].documentID;
    }); 
    return id; 
  }
catch(e){
  print(e); 
}
}
Future<Account> FetchAccount(String id) async{
  DocumentReference ref = Firestore.instance.collection('Accounts').document(id); 
  DocumentSnapshot snapshot = await ref.get(); 
  if (!snapshot.exists) return null; 
  else return  Account.fromMap(id, snapshot.data); 
}
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
Future<void> createLog(Project proj, Task task, Log log) async{
  await Firestore.instance.runTransaction((transaction) async{
    CollectionReference a = Firestore.instance.collection('Projects/' + proj.id + '/tasks/' + task.id + '/Logs');
    DocumentReference ref = a.document(); 
    log.id = ref.documentID; 
    await transaction.set(ref, log.mapTo()); 

  });
}
Future<void> UpdateProject(Project proj) async{
    await UpdateTasks(proj);
    await Firestore.instance.document('Projects/' + proj.id).updateData(proj.mapWithoutID()); 
    print('Updated Project'); 
  }
  Future<void> UpdateTasks(Project proj)async{
    CollectionReference ref = Firestore.instance.collection('Projects/' + proj.id +'/tasks'); 
    await ref.getDocuments().then((values){
      values.documents.forEach((doc){
        if (doc.exists){
          Task t = proj.tasks.firstWhere((test) => test.id == doc.documentID);
          try{
          Firestore.instance.document('Projects/' + proj.id +'/tasks/' + doc.documentID)
            .updateData(t.mapTo()).catchError((e) => print('UPDATE FAILED'));
          }catch(e){print(e);}
        }
      });
    });
  }
  Future<void> UpdateTask(Project proj, Task task) async{
    if (task.name != null){
      await Firestore.instance.document('Projects/' + proj.id +'/tasks/'+ task.id).updateData(task.mapTo()).catchError((e) => print('Error Updating Task'));
    }
  }
  Future<List<Task>>getProjectTasks(String id) async {
    CollectionReference ref = Firestore.instance.collection('Projects/' + id +'/tasks');
    QuerySnapshot s = await ref.getDocuments(); 
    List<Task> t = []; 
    s.documents.forEach((task){
      if (task['name'] != null){
        t.add(Task.fromMap(task.documentID, task.data)); 
      }
    }); 
    t.forEach((task) async => task.setLogs(await getTaskLogs(id, task.id))); 
    return t; 
  }
  Future<List<Log>>getTaskLogs(String projectID, String taskID)async {
    CollectionReference ref = Firestore.instance.collection('Projects/' + projectID + '/tasks/' + taskID + '/Logs'); 
    QuerySnapshot s = await ref.getDocuments(); 
    List<Log> logs = []; 
    s.documents.forEach((log)async {
      Account account = await FetchAccount(log['accountID']); 
      logs.add(Log.fromMap(log.documentID, log.data, account)); 
    });
    return logs; 
  }
  Future<Project> getProject(String id)async{
    Project project; 
    DocumentReference ref = Firestore.instance.document('Projects/' + id); 
    DocumentSnapshot snapshot = await ref.get(); 
    List<String> tags = []; 
    project = Project.fromMap(snapshot.data, tags, snapshot.documentID); 
    project.setTasks(await getProjectTasks(project.id)); 
    return project; 
  }
  Future<List<Project>> getProjects(Auth auth) async {
    List<Project> a = [];
    await auth.getCurrentUser().then((userid) async {
      QuerySnapshot snapshot =  await Firestore.instance.collection('Projects')
          .where('user', isEqualTo: userid)
          .getDocuments();
      int count = 0;
      snapshot.documents.forEach((document) {
          List<String> tags = []; 
          if (document.data.containsKey('tags') && document.data['tags'] != null){
            List<String> tags = new List<String>.from(document.data['tags']); 
          }
          Project proj = Project.fromMap(document.data, tags, document.documentID, count: count);  
          count++;   
          a.add(proj);
      });
    });
    for (int i = 0; i < a.length; i++){
      await a[i].setTasks(await getProjectTasks(a[i].id));
    }

    DocumentSnapshot ref = await Firestore.instance.document('Accounts/' + auth.getUID()).get(); 
    if (ref.data['joinedProjects'] != null){
      List<String> additional= new List<String>.from(ref.data['joinedProjects']); 
      for (int i = 0; i < additional.length; i++){
        print(additional[i]); 
        await a.add(await getProject(additional[i])); 
      }
    }
  
    //a.forEach((proj) async => proj.setTasks(await getProjectTasks(proj.id))); 
    return a;
  }
  Future<bool> DeleteProject(Project proj) async{
    await Firestore.instance.collection('Projects').document(proj.id).delete();
    return true;
  }
  Future<bool> DeleteTask(Project proj, Task t)async{
    print('Attempting to Delete Task');
    await Firestore.instance.collection('Projects/' + proj.id +'/tasks').document(t.id).delete(); 
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