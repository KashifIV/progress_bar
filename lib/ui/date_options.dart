import 'package:flutter/material.dart';

class DateOptions extends StatelessWidget {
  final DateTime deadline;
  int routine; 
  final Function(DateTime value) onDeadlineChange;
  final Function(int value) onRoutineChange;

  void initState(){
  }
  DateOptions(
      {this.deadline,
      this.routine,
      this.onDeadlineChange,
      this.onRoutineChange});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
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
              SizedBox(width: 10,),
              Text(
                (deadline != null)
                    ? deadline.difference(DateTime.now()).inDays.toString() + 
                    ' Days \nremaning'
                    : 'Add a \nDeadline.',
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
