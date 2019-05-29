import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:progress_bar/data/Project.dart';
import 'package:progress_bar/ui/project_page.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/ui/progress_bar.dart'; 
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
              model.onUpdateTask(project, task); 
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
      builder: (BuildContext context, ViewModel model) =>Slidable(
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
      child: Container(
      
      height: 90,
      //margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), 
        border: Border.all(
          color: Colors.grey.withAlpha(40),
          width: 2.0, 
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 10,
            child: ProgressBar(project.index, tag: tag,),
          ), 
          Positioned(
            right: 10,
            bottom: 10,
            child: Text(
              project.getRatio(tag)
            ),
          ),
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
      ),
    ))));
  }
}