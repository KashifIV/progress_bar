import 'package:flutter/material.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:redux/redux.dart';
import 'package:progress_bar/domain/actions.dart';
import 'package:progress_bar/ui/task_page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/data/Task.dart';
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/animation.dart';
import 'package:progress_bar/data/app_color.dart' as appcolor;
class TaskCard extends StatefulWidget{
  final Task task;
  final int index;
  final Color color; 
  TaskCard(this.task,this.index, {this.color});
  _TaskCard createState() => _TaskCard();
}
class _TaskCard extends State<TaskCard>{
  Widget GetPrimarySlideAction(ViewModel model) {
    if (widget.task.complete == false){
      return new IconSlideAction(
          caption: 'Done',
          icon: Icons.check,
          color: Colors.green,
          onTap: (){
            widget.task.complete = true;
            model.onUpdateTask(model.projects[widget.index], widget.task);
          },
        );
    }
    else if (widget.task.complete == true){
      return new IconSlideAction(
        caption: 'Unfinished',
        icon: Icons.undo,
        color: Colors.blue,
        onTap: (){
          widget.task.complete = false;
          model.onUpdateTask(model.projects[widget.index], widget.task);
        },
      );
    }
  }
  SlideToDismissDelegate adjustDelegate(ViewModel model){
    if (model.whiteList == WhiteList.all) return null;
    return SlideToDismissDrawerDelegate(
        dismissThresholds: <SlideActionType, double>{SlideActionType.secondary: 1.0},
        onDismissed: (action){
          if (action == SlideActionType.primary){
            widget.task.complete = !widget.task.complete;
            model.onUpdateTask(model.projects[widget.index], widget.task);
          }
        }
      );
  }
  Widget dialog(ViewModel model, BuildContext context){
    final controller = TextEditingController();
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          child: TextField(
            controller: controller,
          ),
        ),
        FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: (){
            //model.onUpdateProject(model.projects[widget.index]);
            model.onUpdateTask(model.projects[widget.index], widget.task);
            Navigator.pop(context);
          },
        )
      ],
    );
  }
  Widget _buildTagPill(ViewModel model , String tag){
    return Container(
      height: 10,
      width: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), 
        color: appcolor.tagColors[model.projects[widget.index].tags.indexOf(tag)%appcolor.tagColors.length],
      ),
    );
  }
  List<Widget> _buildPillList(ViewModel model){
    List<Widget> a = []; 
    if (widget.task.tags != null){
      widget.task.tags.forEach((tag){
        a.add(_buildTagPill(model, tag)); 
        a.add(SizedBox(width: 10,)); 
      });
      return a; 
    }
    else return [SizedBox(width: 10,)]; 

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StoreConnector<AppState, ViewModel>( 
      converter:(Store<AppState> store) => ViewModel.create(store),
      builder: (BuildContext context, ViewModel model) =>Slidable(
      key: new Key(widget.task.id),
      delegate: SlidableBehindDelegate(),  
      slideToDismissDelegate: adjustDelegate(model),
      actionExtentRatio: 0.25,
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TaskPage(widget.index,model.projects[widget.index].tasks.indexOf(widget.task), task: widget.task,))),
        child: new Container(
        color: Colors.white,
        child: ListTile(
          title: Text(widget.task.name,
            style: TextStyle(
              fontSize: 20,
              color: (widget.color != null) ?widget.color: Colors.black,
            ),
          ),
          trailing: Column(
            children: <Widget> [
              Text(
            (widget.color == Colors.red)? 'Deadline: ' + (widget.task.deadline.difference(DateTime.now()).inDays).toString() + ' Days':'',
            style: TextStyle(color: widget.color),
              ), 
              SizedBox(height: 10,),
              Wrap(
                children: _buildPillList(model),
              )
            ]
          ),
          
          subtitle: Text(widget.task.notes == null ? "" : widget.task.notes,
            style: TextStyle(
              fontSize: 15
            ),
          ),
        ), 
      )),     
      actions: <Widget>[
        GetPrimarySlideAction(model),
      ],
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: 'Delete',
          icon: Icons.delete,
          color: Colors.red,
          onTap: () => model.onDeleteTask(model.projects[widget.index],widget.task),
        ),
        new IconSlideAction(
          caption: 'Settings',
          icon: Icons.settings,
          color: Colors.grey,
          onTap: (){
            showDialog(context: context, builder: (context)=> Dialog(child: dialog(model, context),));
          },
        ),
      ],
    ));
  }
}
