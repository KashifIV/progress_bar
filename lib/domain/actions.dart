import 'package:progress_bar/data/Account.dart';
import 'package:progress_bar/data/Log.dart';
import 'package:progress_bar/data/Project.dart';
import 'package:progress_bar/data/Task.dart';
import 'package:progress_bar/data/auth.dart';
import 'package:progress_bar/domain/redux.dart';
// Actions for Project Manipulation
abstract class ProjectsCrud{
  final Project proj;
  ProjectsCrud(this.proj);
  List<Project> doAction(List<Project> state);
}
class CreateProjectAction extends ProjectsCrud{
  Auth auth;
  CreateProjectAction(Project proj, this.auth) : super(proj);
  @override
    List<Project> doAction(List<Project> state) {
      return []..addAll(state)..add(super.proj);
    }
}
class DeleteProjectAction extends ProjectsCrud{
  DeleteProjectAction(Project proj): super(proj);
  @override
    List<Project> doAction(List<Project> state) {
      return []..addAll(state)..remove(super.proj);
    }
}
class UpdateProjectAction extends ProjectsCrud{
  UpdateProjectAction(Project proj): super(proj);
  @override
    List<Project> doAction(List<Project> state) {
      List<Project> value = []..addAll(state);
      value.firstWhere((test) => test.id == super.proj.id).Update(super.proj);
      return value;
    }
}
class LoadedProjectsAction{
  List<Project> projects;
  LoadedProjectsAction(this.projects);
}
class GetProjectsAction{
  Auth auth;
  GetProjectsAction(this.auth);
}
abstract class ProjectTaskCrud{
  final Task task;
  final Project proj;
  ProjectTaskCrud(this.task, this.proj);
  List<Project> doAction(List<Project> state);
}
//Actions For Task Manipulation
class CreateTaskAction extends ProjectTaskCrud{
  CreateTaskAction(Task task, Project proj): super(task, proj);
  @override
    List<Project> doAction(List<Project> state) {
      List<Project> value = []..addAll(state);
      value.firstWhere((test) => test.id == super.proj.id).AddTask(super.task);
      return value;
    }
}
class DeleteTaskAction extends ProjectTaskCrud{
  DeleteTaskAction(Task task, Project proj): super(task, proj);
  @override
  List<Project> doAction(List<Project> state) {
    List<Project> value = []..addAll(state);
    value.firstWhere((test) => test.id == super.proj.id).tasks.remove(super.task);
    return value;
  }
}
class CompleteTaskAction{
  final Task task;
  final Project proj;
  CompleteTaskAction(this.task, this.proj);
}
class UpdateTaskAction extends ProjectTaskCrud{
  UpdateTaskAction(Task task, Project proj): super(task, proj);
  @override
    List<Project> doAction(List<Project> state) {
       List<Project> value = []..addAll(state);
      value.firstWhere((test) => test == super.proj).tasks
        .firstWhere((test) => test.id == super.task.id).Update(super.task);
      return value;
    }
}
class GetTasksAction{
  Project proj;
  GetTasksAction(this.proj);
}
class LoadedTasksAction{
  Project proj;
  List<Task> tasks;
  LoadedTasksAction(this.proj, this.tasks);

}
class GetAllTasks{
  Project proj;
  GetAllTasks(this.proj);
}

// Update Main Page State
class UpdatePageAction{
  final PageType pg;
  UpdatePageAction(this.pg);
}

// Update Task View State
class UpdateTaskViewAction{
  final TaskViewType taskView;
  UpdateTaskViewAction(this.taskView);
}

class OpenProjectAction{
  final Project proj;
  OpenProjectAction(this.proj);
}
class UpdateCurrentTask{
  final Task task;
  UpdateCurrentTask(this.task);
}
class CreateCurrentTask{
  final Task task;
  CreateCurrentTask(this.task);
}

class LoadedCurrentTask{
  final List<Task> tasks;
  LoadedCurrentTask(this.tasks);
}

class UpdateWhiteList{
  final WhiteList val;
UpdateWhiteList(this.val);
}
//-----------------------------------------------------------
class CreateAccountAction{
  final Account account; 
  final Auth auth; 
  CreateAccountAction(this.auth, this.account); 
}
class UpdateAccountAction{
  final Account account;
  final Auth auth;  
  UpdateAccountAction(this.auth,this.account); 
}
class DeleteAccountAction{
  final Account account; 
  final Auth auth; 
  DeleteAccountAction(this.auth, this.account); 
}
class FetchAccountAction{
  final String id; 
  FetchAccountAction(this.id); 
}
class OnUpdatedAccount{
  final Account account; 
  OnUpdatedAccount(this.account); 
}

//--------------------------------------------------------

class CreateLogAction{
  final Project project; 
  final Task task; 
  final Log log; 
  CreateLogAction(this.project, this.task, this.log); 
}
class CloneProjectAction{
  final String projectID; 
CloneProjectAction(this.projectID); 
}