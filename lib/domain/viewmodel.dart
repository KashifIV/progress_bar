import 'package:progress_bar/data/Account.dart';
import 'package:progress_bar/data/Log.dart';
import 'package:progress_bar/domain/actions.dart';
import 'package:redux/redux.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/data/auth.dart';
import 'package:progress_bar/data/Project.dart';
import 'package:progress_bar/data/Task.dart';
class ViewModel {
  final Account account; 
  final List<Project> projects;
  final PageType pageType;
  final TaskViewType taskView;
  final WhiteList whiteList;
  final Function(Project, Auth) onCreateProject;
  final Function(Auth) onGetProject;
  final Function(Project, bool) onRemoveProject;
  final Function(Account) onUpdateSorting; 
  final Function(Project) onUpdateProject;
  final Function(Project) onUpdateProjectSettings; 
  final Function(PageType) onUpdatePage; 
  final Function(Account, Project, Task) onAddTask;
  final Function(Account, Project, Task) onUpdateTask;
  final Function(Account, Project, Task) onDeleteTask;
  final Function(Project) onGetProjectTask;
  final Function () onResetAccount;
  final Function(WhiteList) onUpdateWhiteList;

  final Function(Auth,Account) onCreateAccount; 
  final Function(Auth, Account) onUpdateAccount; 
  final Function(Auth) onFetchAccount; 

  final Function(Project) onCloneProject; 

  final Function(Project, Task, Log) onCreateLog; 
  ViewModel({
    this.account, 
    this.projects,
    this.pageType,
    this.taskView,
    this.whiteList,
    this.onCreateProject,
    this.onGetProject,
    this.onRemoveProject,
    this.onUpdateProject,
    this.onAddTask,
    this.onUpdateTask,
    this.onDeleteTask,
    this.onGetProjectTask,
    this.onUpdateWhiteList,
    this.onCreateAccount, 
    this.onUpdateAccount,
    this.onFetchAccount, 
    this.onCreateLog,
    this.onCloneProject, 
    this.onUpdateProjectSettings, 
    this.onUpdateSorting,
    this.onUpdatePage,
    this.onResetAccount, 
  });
  factory ViewModel.create(Store<AppState> store){
    _onCreateProject(Project proj, Auth auth){
      store.dispatch(CreateProjectAction(proj, auth));
    }
    _onGetProject(Auth auth){
      store.dispatch(GetProjectsAction(auth));
    }
    _onRemoveProject(Project proj, bool isJoined){
      store.dispatch(DeleteProjectAction(proj, isJoined));
    }
    _onUpdateProject(Project proj){
      store.dispatch(UpdateProjectAction(proj));
    }   
    _onUpdateProjectSettings(Project proj){
      store.dispatch(UpdateProjectSettingsAction(proj)); 
    }
    _onAddTask(Account account, Project proj, Task task){
      store.dispatch(CreateTaskAction(account, task, proj));
    }
    _onUpdateTask(Account account,Project proj, Task task){
      store.dispatch(UpdateTaskAction(account,task, proj));
    }
    _onDeleteTask(Account account, Project proj, Task task){
      store.dispatch(DeleteTaskAction(account, task, proj));
    }
    _onGetProjectTask(Project proj){
      store.dispatch(GetTasksAction(proj));
    }
    _onUpdateWhiteList(WhiteList whiteList){
      store.dispatch(UpdateWhiteList(whiteList));
    }
    _onCreateAccount(Auth auth, Account account){
      store.dispatch(CreateAccountAction(auth, account)); 
    }
    _onUpdateAccount(Auth auth, Account account){
      store.dispatch(UpdateAccountAction(auth, account)); 
    }
    _onFetchAccount(Auth auth){
      store.dispatch(FetchAccountAction(auth)); 
    }
    _onCloneProject(Project project){
      store.dispatch(CloneProjectAction(project)); 
    }
    _onCreateLog(Project project, Task task, Log log){
      store.dispatch(CreateLogAction(project, task, log)); 
    }
    _onUpdateSorting(Account account){
      store.dispatch(UpdateSortingAction(account)); 
    }
    _onUpdatePage(PageType page){
      store.dispatch(UpdatePageAction(page)); 
    }
    _onResetAccount(){
      store.dispatch(OnResetAccount);
    }
    return ViewModel(
      account: store.state.account,
      projects: store.state.projects,
      pageType: store.state.page,
      taskView: store.state.taskView,
      whiteList: store.state.whiteList,
      onCreateProject: _onCreateProject,
      onGetProject: _onGetProject,
      onRemoveProject: _onRemoveProject,
      onUpdateProjectSettings: _onUpdateProjectSettings,
      onUpdateProject: _onUpdateProject,
      onAddTask: _onAddTask,
      onUpdateTask: _onUpdateTask,
      onDeleteTask: _onDeleteTask,
      onGetProjectTask: _onGetProjectTask,
      onUpdateWhiteList: _onUpdateWhiteList,
      onCreateAccount: _onCreateAccount, 
      onUpdateAccount: _onUpdateAccount,
      onFetchAccount: _onFetchAccount,
      onCloneProject: _onCloneProject,
      onUpdateSorting: _onUpdateSorting,
      onCreateLog: _onCreateLog,
      onUpdatePage: _onUpdatePage,
      onResetAccount: _onResetAccount,
    );
  }
}