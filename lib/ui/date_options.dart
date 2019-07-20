import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
class DateOptions extends StatelessWidget {
  final DateTime deadline;
  int routine; 
  final Duration duration; 
  final Function(DateTime value) onDeadlineChange;
  final Function(int value) onRoutineChange;
  final Function (Duration time) onDurationChange; 

  void initState(){
  }
  DateOptions(
      {this.deadline,
      this.routine,
      this.duration,
      this.onDeadlineChange,
      this.onDurationChange,
      this.onRoutineChange});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal:3),
      child:Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
          onPressed: () => showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2019),
                    lastDate: DateTime(2030),
                    builder: (BuildContext context, Widget child) {
                      return Theme(
                        data: ThemeData.light(),
                        child: child,
                      );
                    }).then((onValue) => onDeadlineChange(onValue)),
          child: Row(
            children: <Widget>[
              Icon(Icons.calendar_today),
              SizedBox(width: 8,),
              Text(
                (deadline != null)
                    ? deadline.difference(DateTime.now()).inDays.toString() + 
                    ' Days \nremaning'
                    : 'Add a \nDate.',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),
        FlatButton(
          onPressed: () => showDurationPicker(
            context: context, 
            initialTime: Duration(minutes: 1),
          ).then((onValue) => onDurationChange(onValue)),
          child: Row(
            children: <Widget>[
              Icon(Icons.timer),
              SizedBox(width: 8,),
              Text(
                (duration != null)
                    ? duration.inMinutes.toString() 
                    +' mins to \nComplete'
                    : 'Add a \nDuration.',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),  
        Container(
          child: Row(
            children: <Widget>[
              Icon(Icons.access_time), 
              SizedBox(width: 10,), 
              DropdownButton(
                value: routine,
                hint: Text('Add a \nRoutine'),
                onChanged: (value) => onRoutineChange(value),
                items: <DropdownMenuItem>[
                  DropdownMenuItem(child: Text('None'), value: null), 
                  DropdownMenuItem(child: Text('Daily'),value: 0,), 
                  DropdownMenuItem(child: Text('Weekly'),value: 1,),
                  DropdownMenuItem(child: Text('Monthly'), value: 2)
                ],
              ),
            ],
          ),
        )

      ],
    ));
  }
}
