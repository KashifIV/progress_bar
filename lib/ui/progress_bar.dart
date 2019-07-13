import 'package:flutter/material.dart';
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:animator/animator.dart';
class ProgressBar extends StatefulWidget{
  final int index; 
  final double width; 
  final String tag; 
  final Color color; 
  final bool withPercent; 
  ProgressBar(this.index, {this.width, this.tag, this.color, this.withPercent = false}); 
  _ProgressBar createState() => _ProgressBar();

}
class _ProgressBar extends State<ProgressBar>{
  double originalPosition = 0;
  double currentPercent = 0; 
  double screenWidth;
  double _getBarWidth(BuildContext context, ViewModel model, Animation<dynamic> anim){
    if (screenWidth == null){
      screenWidth = (widget.width == null) ? MediaQuery.of(context).size.width*0.8 : widget.width;
    }
    currentPercent = _getPercent(model); 
    return screenWidth*(1- anim.value);
  }
  double _getPercent(ViewModel model){
    double value; 
    if (model.account.progressType == "Task")
      value = model.projects[widget.index].getPercentComplete(widget.tag); 
    else if (model.account.progressType == "Deadline" && model.projects[widget.index].deadline != null){
      value = DateTime.now().difference(model.projects[widget.index].dateCreated).inHours /model.projects[widget.index].deadline.difference(model.projects[widget.index].dateCreated).inHours;
    } else{
       List<double> ans = model.projects[widget.index].totalvsFinishedTime(); 
       if (ans[0] == 0)
        value = 0; 
      else 
       value = ans[1]/ans[0]; 
    } 
    return value.abs(); 

  }
  @override
    Widget build(BuildContext context) {
      return StoreConnector<AppState, ViewModel>(
        converter:(Store<AppState> store) => ViewModel.create(store),
        onWillChange: (ViewModel model) {
          setState(() {
           originalPosition = currentPercent;  
          });
        },
        builder: (BuildContext context, ViewModel model) =>
        Container(
          height: 20,
          margin: EdgeInsets.fromLTRB(2, 2, 2 , 2),
          width: MediaQuery.of(context).size.width*0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black.withAlpha(20) 
          ),
          child: Animator( 
            tween: Tween<double>(begin: originalPosition, end: _getPercent(model),),
            builder:(anim) => Container(
            margin: EdgeInsets.fromLTRB(2, 2, _getBarWidth(context,model, anim) , 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.yellow,
              gradient: LinearGradient(
                colors: [
                  model.projects[widget.index].toColor(),
                  (widget.color == null ) ?Colors.teal[200] : widget.color, 
                ],
                begin: Alignment.centerLeft,
                end: Alignment(anim.value, 0),
                tileMode: TileMode.clamp
              )              
            ),
          ),
          )
        )
      );
    }
}