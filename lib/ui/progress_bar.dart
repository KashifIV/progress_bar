import 'package:flutter/material.dart';
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:progress_bar/domain/redux.dart';
class ProgressBar extends StatelessWidget{
  final int index;
  ProgressBar(this.index);

  @override
    Widget build(BuildContext context) {
      return StoreConnector<AppState, ViewModel>(
        converter:(Store<AppState> store) => ViewModel.create(store),
        builder: (BuildContext context, ViewModel model) =>
        Container(
          height: 20,
          width: MediaQuery.of(context).size.width*0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue
          ),
          child: new Container(
            //height: 18,
            //width: MediaQuery.of(context).size.width*0.8*model.projects[index].getPercentComplete(),
            margin: EdgeInsets.fromLTRB(2, 2, MediaQuery.of(context).size.width*0.8 - MediaQuery.of(context).size.width*0.8*(model.projects[index].getPercentComplete()), 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.yellow,              
            ),
          ),
        )
      );
    }
}