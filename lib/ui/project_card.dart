import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/ui/progress_bar.dart';
import 'package:redux/redux.dart';
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/domain/actions.dart';
import 'package:progress_bar/ui/project_page.dart';
import 'package:progress_bar/data/Project.dart';

class ProjectCard extends StatelessWidget {
  final int index;
  ProjectCard(this.index);
  void _openProject(BuildContext context, ViewModel model) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProjectPage(index)));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
        converter: (Store<AppState> store) => ViewModel.create(store),
        builder: (BuildContext context, ViewModel model) => Hero(
          transitionOnUserGestures: true,
          tag:model.projects[index].name,
          child: Container(
            child: GestureDetector(
                onTap: () => _openProject(context, model),
                child: new Container(
                    height: 125,
                    padding: EdgeInsets.all(10.0),
                    decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                          colors: [
                            model.projects[index].toColor(),
                            Colors.teal[400]
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(0.9, 0.3),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                      color: model.projects[index].toColor(),
                      shape: BoxShape.rectangle,
                      borderRadius: new BorderRadius.circular(8.0),
                      boxShadow: <BoxShadow>[
                        new BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                          offset: new Offset(0.0, 10.0),
                        ),
                      ],
                    ),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Material (
                            color: Colors.transparent,
                            child: Text(
                            model.projects[index].name,
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              
                            ),
                          )),
                          SizedBox(height: 10,),
                          ProgressBar(index)
                        ],
                      ),
                    )))));
  }
}
