
import 'package:progress_bar/data/CRUD.dart';
import 'package:progress_bar/data/Account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progress_bar/data/Project.dart';
Future<Project> cloneProject(String link, String id)async{
  String projectID = link.split('projectID=').last; 
  Project project = await getProject(projectID); 
  await Firestore.instance.runTransaction((transaction) async{
    DocumentReference ref = Firestore.instance.collection('Projects').document(); 
    project.id = ref.documentID; 
    await transaction.set(ref, project.mapTo(id)); 
  });
  for (int i= 0; i < project.tasks.length; i++){
    await CreateTask(project, project.tasks[i]); 
  }
  return project; 
}
Future<Project> collabProject(String link, String id)async{
  String projectID = link.split('projectID=').last; 
  Project proj;
  try{ 
    proj = await getProject(projectID); 
    print(proj.name);
  }catch(e){
    print(e);
    return null;
  }
  return proj; 
}



