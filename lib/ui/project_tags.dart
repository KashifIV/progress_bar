import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/ui/progress_bar.dart'; 
import 'package:redux/redux.dart';
import 'package:progress_bar/domain/viewmodel.dart';

class ProjectTags extends StatelessWidget{
  final String tag; 
  final int index; 
  ProjectTags(this.tag, this.index); 
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>( 
      converter: (Store<AppState> store) => ViewModel.create(store),
      builder: (BuildContext context, ViewModel model) => Container(
      height: 150,
      //margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), 
        border: Border.all(
          color: Colors.black,
          width: 2.0, 
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: ProgressBar(index, tag: tag,),
          )
        ],
      ),
    ));
  }
}