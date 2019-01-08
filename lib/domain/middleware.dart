import 'package:progress_bar/data/CRUD.dart';
import 'package:progress_bar/domain/actions.dart';
import 'package:redux/redux.dart';
import 'package:progress_bar/domain/redux.dart';

void appStateMiddleware(Store<AppState> store, action, NextDispatcher next) async{
  next(action);
  if (action is GetProjectsAction){
    await getProjects(action.auth).then((state) => store.dispatch(LoadedProjectsAction(state)));
    store.dispatch(UpdatePageAction(PageType.VAL));

  }
  if (action is GetTasksAction){
    await getProjectTasks(action.proj.id).then((state) => store.dispatch(LoadedTasksAction(action.proj, state)));
    store.dispatch(UpdateTaskViewAction(TaskViewType.list));
  }
  if (action is CreateProjectAction){
    await CreateProject(action.proj, action.auth);
  }
  if (action is DeleteProjectAction){
    await DeleteProject(action.proj);
  }
  if (action is UpdateTaskAction){
    await UpdateTask(action.proj,action.task);
  }
  if (action is CreateTaskAction){
    await CreateTask(action.proj, action.task);
  }
}