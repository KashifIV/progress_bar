import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:progress_bar/ui/task_list.dart';
import 'package:redux/redux.dart';

class CalendarPage extends StatefulWidget{
  _CalendarPage createState() => _CalendarPage(); 
}
EventList<String> _getDates(ViewModel model){
  EventList<String> times = new EventList<String>(); 
  model.projects.forEach((project) {
      project.tasks.forEach((task){
        if (task.deadline != null) times.add(task.deadline, task.name);
      });
  });
  return times;

}
class _CalendarPage extends State<CalendarPage>{
  DateTime selectedDay; 
  void initState(){
    selectedDay = DateTime.now(); 
  }
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
        converter: (Store<AppState> store) => ViewModel.create(store),
        builder: (BuildContext context, ViewModel model) => Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
        Container(
          height: 450,
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: CalendarCarousel(
          selectedDateTime: selectedDay,
          markedDatesMap: _getDates(model),
          onDayPressed: (date, values){
            setState(() {
              selectedDay = date;  
            });
          },
        )
      ), 
      SizedBox(
        height: MediaQuery.of(context).size.height - 500,
        width: MediaQuery.of(context).size.width,
        child:CustomScrollView(
          slivers: <Widget>[
            TaskList(-1, dayOf: selectedDay,),
          ],
        )
      )
          ]
      )
    ))
    );}
}