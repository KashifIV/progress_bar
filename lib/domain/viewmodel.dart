import 'package:progress_bar/domain/actions.dart';
import 'package:redux/redux.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/data/auth.dart';
import 'package:progress_bar/data/Project.dart';
import 'package:progress_bar/data/Task.dart';
class ViewModel {
  final List<Project> projects;
  final PageType pageType;
  final TaskViewType taskView;
  final WhiteList whiteList;
  final Function(Project, Auth) onCreateProject;
  final Function(Auth) onGetProject;
  final Function(Project) onRemoveProject;
  final Function(Project) onUpdateProject;

  final Function(Project, Task) onAddTask;
  final Function(Project, Task) onUpdateTask;
  final Function(Project, Task) onDeleteTask;
  final Function(Project) onGetProjectTask;

  final Function(WhiteList) onUpdateWhiteList;
  ViewModel({
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
    this.onUpdateWhiteList
  });
  factory ViewModel.create(Store<AppState> store){
    _onCreateProject(Project proj, Auth auth){
      store.dispatch(CreateProjectAction(proj, auth));
    }
    _onGetProject(Auth auth){
      store.dispatch(GetProjectsAction(auth));
    }
    _onRemoveProject(Project proj){
      store.dispatch(DeleteProjectAction(proj));
    }
    _onUpdateProject(Project proj){
      store.dispatch(UpdateProjectAction(proj));
    }

    _onAddTask(Project proj, Task task){
      store.dispatch(CreateTaskAction(task, proj));
    }
    _onUpdateTask(Project proj, Task task){
      store.dispatch(UpdateTaskAction(task, proj));
    }
    _onDeleteTask(Project proj, Task task){
      store.dispatch(DeleteTaskAction(task, proj,));
    }
    _onGetProjectTask(Project proj){
      store.dispatch(GetTasksAction(proj));
    }

    _onUpdateWhiteList(WhiteList whiteList){
      store.dispatch(UpdateWhiteList(whiteList));
    }
    return ViewModel(
      projects: store.state.projects,
      pageType: store.state.page,
      taskView: store.state.taskView,
      whiteList: store.state.whiteList,
      onCreateProject: _onCreateProject,
      onGetProject: _onGetProject,
    onRemoveProject: _onRemoveProject,
      onUpdateProject: _onUpdateProject,
      onAddTask: _onAddTask,
      onUpdateTask: _onUpdateTask,
      onDeleteTask: _onDeleteTask,
      onGetProjectTask: _onGetProjectTask,
      onUpdateWhiteList: _onUpdateWhiteList,
    );
  }
}