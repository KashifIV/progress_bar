import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:progress_bar/data/Project.dart';
import 'package:progress_bar/ui/project_page.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/ui/progress_bar.dart'; 
import 'package:progress_bar/data/app_color.dart' as appcolor; 
import 'package:redux/redux.dart';
import 'package:progress_bar/domain/viewmodel.dart';

class ProjectTags extends StatelessWidget{
  final String tag; 
  final Project project;
  ProjectTags(this.tag, this.project); 

  SlideToDismissDelegate delegate(ViewModel model){
    return SlideToDismissDrawerDelegate(
      onDismissed: (action){
        if (action == SlideActionType.secondary){
          project.tags.remove(tag); 
          project.tasks.forEach((task){
            if (task.tags != null && task.tags.contains(tag)){
              task.tags.remove(tag); 
              model.onUpdateTask(model.account, project, task); 
            }
          });
          model.onUpdateProject(project); 
        }
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>( 
      converter:(Store<AppState> store) => ViewModel.create(store),
      builder: (BuildContext context, ViewModel model) =>Theme(
        data: model.account.darkTheme ? ThemeData.dark() : ThemeData.light(),
        child: Slidable(
      key: new Key(tag), 
      delegate: SlidableBehindDelegate(),  
      slideToDismissDelegate: delegate(model),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete Tag',
          icon: Icons.delete_forever,
          color: Colors.red
        )
      ],
      child: GestureDetector(
      onTap:() => Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProjectPage(project.index, tag: tag,))),
      child: Card( elevation: 2, child: Container(
      
      height: 90,
      //margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        //color: Colors.white,
        borderRadius: BorderRadius.circular(10), 
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 10,
            left: 18,
            child: ProgressBar(project.index, tag: tag, color: appcolor.tagColors[project.tags.indexOf(tag)],),
          ), 
          Positioned(
            right: 10,
            bottom: 13,
            child: Text(
              project.getRatio(tag)
            ),
          ),
          /*
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 5,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.orange.withOpacity(0.4)
              )
            ),
          ),
          */
          Positioned(
            left: 20,
            top: 20,
            child: Text(
              tag,
              style: TextStyle(
                fontSize: 25,
              ),
            ),
          )
        ],
      )),
    )))));
  }
}