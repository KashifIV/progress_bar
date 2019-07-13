import 'package:flutter/material.dart';
import 'package:progress_bar/data/Project.dart';

class ProgressOverview extends StatelessWidget{
  final Project project; 
  ProgressOverview(this.project); 
  double height = 80; 
   Widget _line(){
      return Container(height: height*0.7, width: 2, color: Colors.white54);
    }
    Widget _infoBox(int number, String subtext){
      return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[         
          Center(
            child: Text(
              number.toString(),
              textAlign: TextAlign.center,
              
              style: TextStyle(
                color: Colors.white, 
                fontSize: 25,
              ),
            ),
          ),
          Text(subtext,style: TextStyle(color: Colors.white54, ), textAlign: TextAlign.center,)
        ],),
      );
    }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        SizedBox(height: 20,), 
        Container(
          width: 400,
          height: height,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: project.toColor().withOpacity(0.7),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Material(color: Colors.transparent, child:IconButton(icon: Icon(Icons.menu, color: Colors.white,),onPressed: () => Scaffold.of(context).openDrawer())),
              _line(), 
              _infoBox(project.tasksComplete, 'Completed'),
              _line(),
              _infoBox(project.tasksToDo, 'To Do'),
              _line(),
              (project.deadline == null)? _infoBox(DateTime.now().difference(project.dateCreated).inDays, 'Days'): _infoBox(project.deadline.difference(DateTime.now()).inDays, 'Days Left'),
          ],),

        ),
        SizedBox(height: 20,)
      ],
    );
  }
}
