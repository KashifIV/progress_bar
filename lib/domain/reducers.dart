import 'package:progress_bar/data/Project.dart';
import 'package:progress_bar/data/auth.dart';
import 'package:progress_bar/data/Task.dart';
import 'package:progress_bar/domain/actions.dart';
import 'package:progress_bar/domain/redux.dart';

AppState appStateReducer(AppState state, action){
  return AppState(
    projectsReducer(state.projects, action),
    taskViewReducer(state.taskView, action),
    authReducer(state.auth, action),
    pageReducer(state.page, action),
    whiteListReduer(state.whiteList, action)
  );
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
    print('REACHED PROJECTSCRUD');
    return action.doAction(state);
  }
  if (action is LoadedProjectsAction){
    return action.projects;
  }
  if (action is ProjectTaskCrud){
    return action.doAction(state);
  }
  if (action is LoadedTasksAction){
    List<Project> value = []..addAll(state);
    value.firstWhere((test) => test == action.proj).tasks = action.tasks;
    return value;
  }
  return state;
}