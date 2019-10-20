import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';

class DateOptions extends StatelessWidget {
  final DateTime deadline;
  int routine; 
  final Duration duration; 
  final Function(DateTime value) onDeadlineChange;
  final Function(int value) onRoutineChange;
  final Function (Duration time) onDurationChange; 
  bool dark; 

  void initState(){
    if (this.dark == null) dark = false; 
  }
  DateOptions(
      {this.deadline,
      this.routine,
      this.duration,
      this.onDeadlineChange,
      this.onDurationChange,
      this.onRoutineChange,
      this.dark,
      });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FlatButton(
          onPressed: () => showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2019),
                    lastDate: DateTime(2030),
                    builder: (BuildContext context, Widget child) {
                      return Theme(
                        data: (dark) ? ThemeData.dark(): ThemeData.light(),
                        child: child,
                      );
                    }).then((onValue) => onDeadlineChange(onValue)),
          child: Row(
            children: <Widget>[
              Icon(Icons.calendar_today, color: (dark) ? Colors.white: Colors.black,),
              SizedBox(width: 8,),
              Text(
                (deadline != null)
                    ? deadline.difference(DateTime.now()).inDays.toString() + 
                    ' Days \nremaning'
                    : 'Add a \nDate.',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  color: (dark) ? Colors.white: Colors.black
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
              Icon(Icons.timer, color: (dark) ? Colors.white: Colors.black,),
              SizedBox(width: 8,),
              Text(
                (duration != null)
                    ? duration.inMinutes.toString() 
                    +' mins to \nComplete'
                    : 'Add a \nDuration.',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: (dark) ? Colors.white: Colors.black,
                  fontSize: 14,
                ),
              )
            ],
          ),
        ), 
        /* 
        Container(
          child: Row(
            children: <Widget>[
              Icon(Icons.access_time, color: (dark) ? Colors.white: Colors.black,), 
              SizedBox(width: 10,), 
              DropdownButton(
                value: routine,
                hint: Text('Add a \nRoutine'),
                onChanged: (value) => onRoutineChange(value),
                
                items: <DropdownMenuItem>[
                  DropdownMenuItem(child: Text('None',style: TextStyle(color: (dark) ? Colors.grey: Colors.black),), value: null), 
                  DropdownMenuItem(child: Text('Daily',style: TextStyle(color: (dark) ? Colors.grey: Colors.black),),value: 0,), 
                  DropdownMenuItem(child: Text('Weekly',style: TextStyle(color: (dark) ? Colors.grey: Colors.black),),value: 1,),
                  DropdownMenuItem(child: Text('Monthly',style: TextStyle(color: (dark) ? Colors.grey: Colors.black),), value: 2)
                ],
              ),
            ],
          ),
        )
*/
      ],
    );
  }
}
