import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/data/Task.dart';
import 'package:progress_bar/ui/date_options.dart';
import 'package:progress_bar/ui/task_tags.dart';
import 'package:redux/redux.dart';
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:progress_bar/domain/redux.dart';

class CreateTask extends StatefulWidget {
  final int index;
  CreateTask(this.index);
  _CreateTask createState() => _CreateTask();
}

class _CreateTask extends State<CreateTask> with TickerProviderStateMixin {
  final controller = TextEditingController();
  bool isExpanded;
  AnimationController rotationController;
  FocusNode _focus;
  DateTime deadline; 
  int routine; 
  Duration duration; 
  void initState() {
    isExpanded = false;
    _focus = new FocusNode();
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    super.initState();
  }

  void _createNewTaskNew(ViewModel model) {
    Task t = new Task(
        name: controller.text, complete: false, dateCreated: DateTime.now(), duration: duration, deadline: deadline, routine: routine);
    model.onAddTask(model.projects[widget.index], t);
    controller.text = "";
  
    setState(() {
      deadline = null; 
    routine = null; 
    duration = null; 
    });
  }

  void dispose() {
    rotationController.dispose();
    super.dispose();
  }
  Widget _expandedOptions(ViewModel model){
    if (isExpanded){
      return Padding(
        padding: EdgeInsets.only(right: 0),
        child: DateOptions(
        dark: model.account.darkTheme,
        deadline: deadline,
        duration: duration,
        routine: routine,
        onDeadlineChange: (value){
          if (routine == null || routine < 1){
            setState(() {
               deadline = value; 
            });
           
          }
          else{
            setState(() {
              deadline = value; 
            });
            
            if (routine == 1 && deadline.difference(DateTime.now()).inDays > 7){
              deadline = deadline.add(Duration(days: 7)); 
            } else if (routine == 2 &&
              deadline
                      .difference(DateTime.now().add(Duration(days: 31)))
                      .inDays <
                  31){
                    setState(() {
                       deadline = DateTime(DateTime.now().year,
                      (DateTime.now().month + 1) % 12, DateTime.now().day);
                    });
                   
                  }
          }
        },
        onRoutineChange: (value){
          setState(() {
            routine = value; 
          });
          
          if (value == 1 && deadline.difference((DateTime.now())).inDays > 7){
            setState(() {
              deadline = DateTime.now().add(Duration(days: 7)); 
            });
            
          }else if (value == 2 &&
            deadline.difference(DateTime.now()).inDays > 31) {
              setState(() {
                deadline = DateTime(DateTime.now().year,
              (DateTime.now().month + 1) % 12, DateTime.now().day);
              });
        }
        },
        onDurationChange: (value) => setState( () => duration= value,)
      )); 
    }
    return SizedBox(); 
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
        converter: (Store<AppState> store) => ViewModel.create(store),
        rebuildOnChange: true,
        builder: (BuildContext context, ViewModel model) => Positioned(
            bottom: 2,
            left: 7,
            right: 7,
            child: Container(
              
                padding: EdgeInsets.fromLTRB(2, 0, 10, 0),
                decoration: BoxDecoration(
                    borderRadius: new BorderRadius.circular(20.0),
                    color: (model.account.darkTheme) ? Colors.black: Colors.white,
                    border: Border.all(
                      color: model.projects[widget.index].toColor(),
                      width: 2.6,
                    )),
                child:Column(
                  children: <Widget>
                  [ 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                  Container(
                     padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                    width: MediaQuery.of(context).size.width - 110,
                    child: TextField(
                      style: TextStyle(color: (model.account.darkTheme) ? Colors.white: Colors.black),
                      onSubmitted: (value) => _createNewTaskNew(model),
                      controller: controller,
                      focusNode: _focus,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Task Name',
                        hintStyle: TextStyle(color: Colors.grey)
                      ),
                    ),
                  ),
                  FloatingActionButton(
                      backgroundColor: model.projects[widget.index].toColor(),
                      child: RotationTransition(
                          turns: Tween(begin: 0.0, end: -0.25)
                              .animate(rotationController),
                          child: Icon(Icons.arrow_left)),
                      elevation: 0,
                      mini: true,
                      onPressed: () {
                        setState(() {
                          isExpanded = !isExpanded;
                          if (isExpanded) {
                            rotationController.forward();
                          } else {
                            rotationController.reverse();
                          }
                        });
                      }), 
                  
                ]),
                SizedBox(height: 3,),
                _expandedOptions(model),
              ])
            )));
  }
}
