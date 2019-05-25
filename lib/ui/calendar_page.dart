import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/domain/viewmodel.dart';
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
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
        converter: (Store<AppState> store) => ViewModel.create(store),
        builder: (BuildContext context, ViewModel model) => Scaffold(
      body: SafeArea(
        child:Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: CalendarCarousel(
          markedDatesMap: _getDates(model),
        )
      )),
    ));
  }
}