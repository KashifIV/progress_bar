import 'package:progress_bar/data/auth.dart';
import 'package:progress_bar/data/Project.dart';
import 'package:flutter/foundation.dart';

class AppState{
  final Auth auth;
  final List<Project> projects;
  final PageType page;
  final TaskViewType taskView;
  final WhiteList whiteList;
  AppState(this.projects, this.taskView, this.auth, this.page, this.whiteList);

  factory AppState.initialState() => AppState(List.unmodifiable([]), TaskViewType.empty, new Auth(), PageType.UND, WhiteList.incomplete);
}
enum WhiteList{
  incomplete, complete,all,
}
enum PageType{
  VAL, UND, NEW
}
enum TaskViewType{
  empty, list, timeline, flowchart
}
