import 'package:progress_bar/data/Project.dart';
import 'package:progress_bar/data/auth.dart';
import 'package:progress_bar/data/Task.dart';
import 'package:progress_bar/domain/actions.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/data/Account.dart';

AppState appStateReducer(AppState state, action){
  return AppState(
    accountReducer(state.account, action),
    projectsReducer(state.projects, action),
    taskViewReducer(state.taskView, action),
    authReducer(state.auth, action),
    pageReducer(state.page, action),
    whiteListReduer(state.whiteList, action)
  );
}
Account accountReducer(Account state, action){
  if (action is OnUpdatedAccount){
    return action.account; 
  }
  return state; 
}
WhiteList whiteListReduer(WhiteList state, action){
  if (action is UpdateWhiteList){
    return action.val;
  }
  return state;
}
Project currentProjectReducer(Project state, action){
  if (action is OpenProjectAction){
    return action.proj;
  }
  if (action is CreateCurrentTask){
    state.tasks = []..addAll(state.tasks)..add(action.task);
  }
  if (action is UpdateCurrentTask){
    List<Task> value = []..addAll(state.tasks);
    value.firstWhere((test) => test.id == action.task.id).Update(action.task);
    state.tasks = value;
    return state;
  }
  if (action is LoadedCurrentTask){
    state.tasks = action.tasks;
    return state;
  }
  return state;
}
PageType pageReducer(PageType state, action){
  if (action is UpdatePageAction)
  {
    return action.pg;
  }
  return state;
}
Auth authReducer(Auth state, action){
  return state;
}
TaskViewType taskViewReducer(TaskViewType state, action){
  if (action is UpdateTaskViewAction){
    return action.taskView;
  }
  return state;
}
List<Project> projectsReducer(List<Project> state, action){
  if (action is ProjectsCrud){
    return action.doAction(state);
  }
  if (action is UpdateSortingAction){
    List<Project> projects = []; 
    state.forEach((project){
      List<Task> tasks = project.tasks;
      if (action.sort == Account.SortingTypes[0]){
        tasks.sort((previous, next) => previous.dateCreated.compareTo(next.dateCreated)); 
      }
      else if (action.sort == Account.SortingTypes[1]){
        List<Task> upper = tasks.where((test) => test.deadline != null).toList();
        upper.sort((previous, next) => previous.deadline.compareTo(next.deadline));
        tasks = upper..addAll(tasks.where((test) => test.deadline == null)); 
      }
      else if (action.sort == Account.SortingTypes[2]){
        List<Task> upper = tasks.where((test) => test.duration != null).toList();
        upper.sort((previous, next) => previous.duration.compareTo(next.duration));
        tasks = upper..addAll(tasks.where((test) => test.duration == null)); 
      }
      for (int i = 0; i < tasks.length; i++){
        tasks[i].order = i; 
      }
      project.setTasks(tasks); 
      projects.add(project); 
    });
    return projects; 
  }
  if (action is SortingAction){
    List<Project> projects = []..addAll(state); 
    List<Task> tasks= action.project.tasks; 
    if (action.sort == Account.SortingTypes[0]){
        tasks.sort((previous, next) => previous.dateCreated.compareTo(next.dateCreated)); 
      }
      else if (action.sort == Account.SortingTypes[1]){
        List<Task> upper = tasks.where((test) => test.deadline != null).toList();
        upper.sort((previous, next) => previous.deadline.compareTo(next.deadline));
        tasks = upper..addAll(tasks.where((test) => test.deadline == null)); 
      }
      else if (action.sort == Account.SortingTypes[2]){
        List<Task> upper = tasks.where((test) => test.duration != null).toList();
        upper.sort((previous, next) => previous.duration.compareTo(next.duration));
        tasks = upper..addAll(tasks.where((test) => test.duration == null)); 
      }
      for (int i = 0; i < tasks.length; i++){
        tasks[i].order = i; 
      }
    projects.firstWhere((test) => test.id == action.project.id).setTasks(tasks); 
    return projects;
  }
  if (action is LoadedProjectsAction){
    return action.projects;
  }
  if (action is CloneProjectAction){
    Project project = action.project; 
    project.index = state.length; 
    return []..addAll(state)..add(project); 
  }
  if (action is ProjectTaskCrud){
    List<Project> projects = action.doAction(state);
    projects.firstWhere((test) => test.id == action.proj.id);
    
  }
  if (action is LoadedTasksAction){
    List<Project> value = []..addAll(state);
    value.firstWhere((test) => test.id == action.proj.id).tasks = action.tasks;
    value.firstWhere((test) => test.id == action.proj.id).state = PageType.VAL;
    return value;
  }
  return state;
}