import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/ui/task_card.dart';
import 'package:progress_bar/data/Task.dart';
import 'package:progress_bar/ui/project_tags.dart';

class EmergencyList extends StatefulWidget{
  final int index; 
  EmergencyList(this.index); 
  _EmergencyList createState() => _EmergencyList(); 
}
class _EmergencyList extends State<EmergencyList>{
  DateTime date; 
  List<Widget> _getTaskCards(ViewModel model){
    List<Widget> a = [];
    EventList<Event> times = new EventList<Event>(); 
    int time = 0; 
    int tasks = 0;
    if (model.projects[widget.index].tasks != null){
    for (int i = 0; i < model.projects[widget.index].tasks.length; i++){
      DateTime now = DateTime.now(); 
      DateTime today = DateTime(now.year, now.month, now.day); 
      if (model.projects[widget.index].tasks[i].deadline != null&& (date == null ? true: model.projects[widget.index].tasks[i].deadline.difference(date).inDays == 0) &&!model.projects[widget.index].tasks[i].complete && model.projects[widget.index].tasks[i].deadline.isBefore(DateTime.now().add(Duration(days: 7)))){
        Task t = model.projects[widget.index].tasks[i]; 
        Color color; 
        if (t.deadline.difference(today).inDays < 0){
          color = Colors.red;
        }
        else if (t.deadline.isBefore(today.add(Duration(days: 3)))){
          color= Colors.orange; 
        }
        else color = Colors.green;
        a.add(TaskCard(model.projects[widget.index].tasks[i], widget.index, color: color,));
        tasks++; 
        if (model.projects[widget.index].tasks[i].duration != null) {
          time +=model.projects[widget.index].tasks[i].duration.inMinutes;
        }
      }
      if (model.projects[widget.index].tasks[i].deadline != null)
        times.add(model.projects[widget.index].tasks[i].deadline, Event(title:model.projects[widget.index].tasks[i].name));
    }
    }
    if (!a.isEmpty || date != null){
      a..add(SizedBox(height: 10,))..add(Card(color: (model.account.darkTheme) ? Colors.black: Colors.white, elevation: 3, child: 
        CalendarCarousel(
        weekFormat: true,
        isScrollable: false,
        weekDayFormat: WeekdayFormat.standaloneShort,    
        weekdayTextStyle: TextStyle(color: Colors.grey),
        showHeader: false,
        headerMargin: EdgeInsets.all(4),
        markedDatesMap: times,
        height: 80,
        todayBorderColor: model.projects[widget.index].toColor(),
        onDayPressed: (selectedDate , tasks){
          setState(() {
           (selectedDate.day == DateTime.now().day) ? date = null: date = selectedDate;  
          });
        },
        daysHaveCircularBorder: true,
        daysTextStyle: TextStyle(color: (model.account.darkTheme) ? Colors.white: Colors.black),
        todayTextStyle: TextStyle(color:(model.account.darkTheme) ? Colors.white: Colors.black),
        todayButtonColor: Colors.transparent,
        selectedDayButtonColor: Colors.transparent,
        selectedDayBorderColor: Colors.teal[200],
        selectedDayTextStyle: TextStyle(color: model.account.darkTheme ? Colors.white:Colors.black),
        
      )));
    }
    if (a.isNotEmpty && a.length > 2){
      a.insert(0, Theme(
        data: model.account.darkTheme ? ThemeData.dark() : ThemeData.light(),
        child:Card(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          height: 50,
          child:Center(child:Text(
          ((time == 0) ? '': time.toString() + ' minutes in ') + tasks.toString() + ' tasks during the next week.',
          style: TextStyle(
            fontSize: 18,
          ),
          
        ))),
        elevation: 3,
      )));
    }
    return a;
  }
    @override
    Widget build(BuildContext context) {
      return StoreConnector<AppState, ViewModel>(
        converter: (Store<AppState> store) => ViewModel.create(store),
        rebuildOnChange: true,
        builder: (BuildContext context, ViewModel model){
          return new SliverList(
            delegate: SliverChildListDelegate(
              _getTaskCards(model)
            ),
          );
        },
      );
    }
}