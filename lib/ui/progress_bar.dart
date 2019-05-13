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
  ProgressBar(this.index, {this.width, this.tag}); 
  _ProgressBar createState() => _ProgressBar();

}
class _ProgressBar extends State<ProgressBar>{
  double originalPosition = 0;
  double currentPercent = 0; 
  double screenWidth; 
  @override
  void initState(){
    screenWidth = (widget.width == null) ? MediaQuery.of(context).size.width*0.8 : widget.width;
  }
  double _getBarWidth(BuildContext context, ViewModel model, Animation<dynamic> anim){
    currentPercent = model.projects[widget.index].getPercentComplete(widget.tag); 
    return screenWidth*(1- anim.value);
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
          width: MediaQuery.of(context).size.width*0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue
          ),
          child: Animator( 
            tween: Tween<double>(begin: originalPosition, end: model.projects[widget.index].getPercentComplete(widget.tag),),
            builder:(anim) => Container(
            margin: EdgeInsets.fromLTRB(2, 2, _getBarWidth(context,model, anim) , 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.yellow,              
            ),
          ),
          )
        )
      );
    }
}