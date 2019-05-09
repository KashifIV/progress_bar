import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class CalendarPage extends StatefulWidget{
  _CalendarPage createState() => _CalendarPage(); 
}
class _CalendarPage extends State<CalendarPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: CalendarCarousel(

        )
      )),
    );
  }
}