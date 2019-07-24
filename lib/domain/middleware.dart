import 'package:progress_bar/data/Account.dart';
import 'package:progress_bar/data/CRUD.dart';
import 'package:progress_bar/data/Project.dart';
import 'package:progress_bar/domain/actions.dart';
import 'package:redux/redux.dart';
import 'package:progress_bar/data/server_functions.dart';
import 'package:progress_bar/domain/redux.dart';


void appStateMiddleware(Store<AppState> store, action, NextDispatcher next) async{
  next(action);
  if (action is GetProjectsAction){
    store.dispatch(UpdatePageAction(PageType.UND));
    List<Project> state = await getProjects(action.auth);
    print('Getting Project' + state.length.toString()); 
    store.dispatch(LoadedProjectsAction(state));
    store.dispatch(UpdateTaskViewAction(TaskViewType.list));
    store.dispatch(UpdatePageAction(PageType.VAL));
  }
  if (action is GetTasksAction){
    await getProjectTasks(action.proj.id).then((state) => store.dispatch(LoadedTasksAction(action.proj, state)));
    store.dispatch(UpdateTaskViewAction(TaskViewType.list));
  }
  if (action is CreateProjectAction){
    await CreateProject(action.proj, action.auth);
  }
  if (action is UpdateProjectAction){
    await UpdateProject(action.proj); 
  }
  if (action is DeleteProjectAction){
    if (!action.isJoined){
      await DeleteProject(action.proj);
    }
  }
  if (action is UpdateTaskAction){
    store.dispatch(SortingAction(action.proj,action.account.sortingType)); 
    await UpdateTask(action.proj,action.task);
  }
  if (action is CreateTaskAction){
     store.dispatch(SortingAction(action.proj,action.account.sortingType)); 
    try{
      await CreateTask(action.proj, action.task);
    }catch(e){
      
    }
  }
  if (action is DeleteTaskAction){
    await DeleteTask(action.proj, action.task);
  }
  if (action is UpdateProjectSettingsAction){
    String id = action.proj.id; 
    action.doAction(store.state.projects); 
    await (UpdateProject(store.state.projects.firstWhere((test) => test.id == id))); 
  }

  //-----------------------------------------------

  if (action is CreateAccountAction){
    await CreateUser(action.auth, action.account).then((state) => store.dispatch(OnUpdatedAccount(action.account))); 
    
  }
  if (action is UpdateAccountAction){
    await UpdateUser(action.auth, action.account).then((state) => store.dispatch(OnUpdatedAccount(action.account))); 
  }
  if (action is FetchAccountAction){
    Account account = await FetchAccount(action.auth.getUID()); 
    if (account == null) store.dispatch(CreateAccountAction(action.auth, new Account.NewAccount(action.auth.getUID(), action.auth.email))); 
    else store.dispatch(OnUpdatedAccount(account));
  }
  
  if (action is CreateLogAction){
    await createLog(action.project, action.task, action.log); 
  }

}