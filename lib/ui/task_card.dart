import 'package:flutter/material.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:redux/redux.dart';
import 'package:progress_bar/domain/actions.dart';
import 'package:progress_bar/ui/task_page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/data/Task.dart';
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:flutter/animation.dart';
class TaskCard extends StatefulWidget{
  final Task task;
  final int index;
  TaskCard(this.task,this.index);
  _TaskCard createState() => _TaskCard();
}

class _TaskCard extends State<TaskCard> with SingleTickerProviderStateMixin { 
  Animation<double> animation;
  AnimationController controller;
  Transform pos;
  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(seconds: 1), vsync: this);
    animation = Tween(begin: 0.0, end: 500.0).animate(controller) ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
  }
  dispose() {
    controller.dispose();
    super.dispose();
  }
  Widget CheckComplete(){
    if (widget.task.complete){
      return new Icon(Icons.check);
    }
    return new Icon(Icons.remove);
  }
  @override
   Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>( 
      converter:(Store<AppState> store) => ViewModel.create(store),
      builder: (BuildContext context, ViewModel model) =>
      new GestureDetector( 
            onHorizontalDragUpdate: (drag){
              if (drag.delta.dx > 5){
                //controller.forward();
              }
            },
            onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>TaskPage(widget.index,model.projects[widget.index].tasks.indexOf(widget.task), task:widget.task)));
            },
            onHorizontalDragEnd: (drag){
              if (drag.velocity.pixelsPerSecond.dx > 100){
                widget.task.complete = true;

                model.onUpdateTask(model.projects[widget.index], widget.task);
              }
              else if (drag.velocity.pixelsPerSecond.dx < -100){
                widget.task.complete = false;
                model.onUpdateTask(model.projects[widget.index], widget.task);
              }
              else{
                //controller.reverse();
              }
            },
      child: Transform.translate(
        offset: Offset(animation.value,0),
        child: Container(
          height: 75,
          //width: MediaQuery.of(context).size.width*0.75,
          margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
          padding: EdgeInsets.all(5.0),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            border: Border.all(
              color: Colors.grey,
              width: 2.0,
            ),
            borderRadius: new BorderRadius.circular(12.0),
              boxShadow: <BoxShadow>[
                 new BoxShadow(
                   color: Colors.black12,
                   blurRadius: 2.0,
                   offset: new Offset(0.0, 1.0),
                 ),
             ],
          ),
          child: CustomPaint(

            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Expanded( child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: new Text(
                    widget.task.name,
                    textAlign: TextAlign.start,
                    textScaleFactor: 1.1,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  )
                )),
                Expanded(
                  flex: 0,
                  child:CheckComplete()
                  ),
              ],           
            ),
        )))
    ));
   }
}