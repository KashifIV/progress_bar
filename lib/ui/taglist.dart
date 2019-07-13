import 'package:flutter/material.dart'; 
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/ui/progress_bar.dart';
import 'package:progress_bar/ui/project_tags.dart'; 
import 'package:redux/redux.dart';
import 'package:progress_bar/domain/viewmodel.dart';

class TagList extends StatelessWidget{
  final int index; 
  TagList(this.index);
  List<Widget> _getTagCards(ViewModel model){
    List<Widget> a = []; 
    if (model.projects[index].tags != null){
      model.projects[index].tags.forEach((tag){
        if (model.projects[index].getPercentComplete(tag) != 0 && model.projects[index].getPercentComplete(tag)!=1)
          a.add(ProjectTags(tag, model.projects[index])); 
      });
    }
    a.add(SizedBox(height: 20,));
    return a; 
  }
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      converter: (Store<AppState> store) => ViewModel.create(store),
      builder: (BuildContext context, ViewModel model) => SliverList(
        delegate: SliverChildListDelegate(
          _getTagCards(model)
        ),
      ),
    );
  }
}