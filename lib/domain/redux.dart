import 'package:progress_bar/data/auth.dart';
import 'package:progress_bar/data/Project.dart';
import 'package:progress_bar/data/Account.dart';
import 'package:flutter/foundation.dart';

class AppState{
  final Auth auth;
  final Account account; 
  final List<Project> projects;
  final PageType page;
  final TaskViewType taskView;
  final WhiteList whiteList;
  AppState(
    this.account, this.projects, this.taskView, this.auth, this.page, this.whiteList, 
    );

  factory AppState.initialState() => AppState(new Account(),List.unmodifiable([]), TaskViewType.empty, new Auth(), PageType.UND, WhiteList.incomplete);
}
enum WhiteList{
  incomplete, complete,all,tag, emergency
}
enum PageType{
  VAL, UND, NEW
}
enum TaskViewType{
  empty, list, timeline, flowchart
}
