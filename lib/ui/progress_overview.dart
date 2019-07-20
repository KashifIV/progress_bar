import 'package:flutter/material.dart';
import 'package:progress_bar/data/Project.dart';
import 'package:progress_bar/data/auth.dart';
import 'package:animator/animator.dart';
import 'package:progress_bar/ui/account_page.dart';
import 'package:progress_bar/ui/calendar_page.dart';
import 'package:progress_bar/ui/settings_page.dart';
class ProgressOverview extends StatefulWidget{
  final Project project; 
  final Auth auth; 
  final VoidCallback onSignedOut;
  ProgressOverview(this.project, this.auth, this.onSignedOut); 
  _ProgressOverview createState() => _ProgressOverview(); 
}
class _ProgressOverview extends State<ProgressOverview>{
  double currentState = 0;
  double nextState = 0;  
  double height = 80; 
  void initState(){
    if (widget.project == null) {
      nextState = 1; 
      currentState = 1; 
    }
    else {
      nextState = 0; 
      currentState = 0; 
    }
  }
   Widget _line(){
      return Container(height: height*0.7, width: 2, color: Colors.white54);
    }
    Widget _infoBox(int number, String subtext, IconData menuItem, String menuSubtext, Function callback){
      return GestureDetector(
        onTap: (){
          if (nextState == 1) callback(); 
        },
        child: Container(
        padding: EdgeInsets.all(10),
        child: AnimatedCrossFade(
          firstChild: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[         
          Center(
            child:  Text(
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
        secondChild: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[         
          Center(
            child: Icon(menuItem, color: Colors.white,)),
          Text(menuSubtext,style: TextStyle(color: Colors.white54, ), textAlign: TextAlign.center,)
        ],),
        duration: const Duration(seconds: 1),
        crossFadeState: nextState == 0 ?  CrossFadeState.showFirst : CrossFadeState.showSecond,
      )));
    }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        SizedBox(height: 20,), 
        Animator(
          endAnimationListener: (AnimatorBloc bloc) => currentState = nextState,
          resetAnimationOnRebuild: true,
          //duration: Duration(seconds: 1),
          tween: Tween<double>(begin: currentState, end: nextState),
          builder: (anim) => Container(
          width: 400,
          height: height,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color:(widget.project != null)? widget.project.toColor().withOpacity(0.7) : Colors.grey.withOpacity(0.7),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Material(
                color: Colors.transparent, 
                child:IconButton(
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    semanticLabel: 'Menu',
                    color:  Colors.white,
                    progress: anim,
                  ),
                  onPressed: (){
                    setState(() {
                     nextState = (nextState == 0) ? 1 : 0; 
                    });
                  },
                )
              ),
              _line(), 
              _infoBox(
                (widget.project == null) ? 0 :widget.project.tasksComplete, 
                'Completed', 
                Icons.account_circle, 
                'Account', () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountPage(auth: widget.auth, onSignedOut: widget.onSignedOut,)))),
              _line(),
              _infoBox(
                (widget.project == null) ? 0 :widget.project.tasksToDo,
                 'To Do',
                 Icons.calendar_today, 
                 'Calendar', 
                 () =>  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CalendarPage()))
                 ),
              _line(),
              (widget.project == null) ? _infoBox(0, 'Days', Icons.settings, 'Settings', () =>  Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => SettingsPage(auth: widget.auth,))
              )) :
              (widget.project.deadline == null)? 
              _infoBox(DateTime.now().difference(widget.project.dateCreated).inDays, 'Days', Icons.settings, 'Settings', () => Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => SettingsPage(auth: widget.auth,))
              )): 
              _infoBox(widget.project.deadline.difference(DateTime.now()).inDays, 'Days Left', Icons.settings, 'Settings', () =>  Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => SettingsPage(auth: widget.auth,))
              )),
          ],),

        )),
        SizedBox(height: 20,)
      ],
    );
  }
}
