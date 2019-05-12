import 'package:flutter/material.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:redux/redux.dart';
import 'package:progress_bar/domain/actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/data/Task.dart';
import 'package:progress_bar/ui/task_list.dart';
import 'package:progress_bar/ui/progress_bar.dart';

class ProjectPage extends StatefulWidget {
  final int index;
  ProjectPage(this.index);
  _ProjectPage createState() => _ProjectPage();
}

class _ProjectPage extends State<ProjectPage> {
  Widget checkSelect(ViewModel model, WhiteList value) {
    if (model.whiteList == value) return Icon(Icons.radio_button_checked);
    return Icon(Icons.radio_button_unchecked);
  }

  final controller = TextEditingController();
  void _whiteListControl(BuildContext context, ViewModel model) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Column(
            children: <Widget>[
              ListTile(
                leading: checkSelect(model, WhiteList.incomplete),
                title: Text('Incomplete'),
                onTap: () {
                  model.onUpdateWhiteList(WhiteList.incomplete);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: checkSelect(model, WhiteList.complete),
                title: Text('Complete'),
                onTap: () {
                  model.onUpdateWhiteList(WhiteList.complete);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: checkSelect(model, WhiteList.all),
                title: Text('All'),
                onTap: () {
                  model.onUpdateWhiteList(WhiteList.all);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void _createNewTaskNew(ViewModel model) {
    Task t = new Task(
        name: controller.text, complete: false, dateCreated: DateTime.now());
    model.onAddTask(model.projects[widget.index], t);
    controller.text = ""; 
  }

  void _createNewTask(BuildContext context, ViewModel model) {
    Task t = new Task(
        name: 'Untitled', complete: false, dateCreated: DateTime.now());
    final controller = TextEditingController();
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return ListView(children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.all(20.0),
                    child: TextField(
                      autofocus: true,
                      controller: controller,
                      autocorrect: true,
                      decoration: InputDecoration(hintText: 'Name: '),
                    )),
                FloatingActionButton(
                  heroTag: 'stage',
                  elevation: 3.0,
                  mini: true,
                  child: new Icon(Icons.note_add),
                  backgroundColor: Colors.blue,
                  onPressed: () {},
                ),
                FloatingActionButton(
                  heroTag: 'phase',
                  elevation: 3.0,
                  mini: true,
                  child: new Icon(Icons.add_to_queue),
                  onPressed: () {},
                ),
                FloatingActionButton(
                  heroTag: 'Add',
                  elevation: 3.0,
                  isExtended: true,
                  mini: true,
                  child: new Icon(Icons.add),
                  backgroundColor: model.projects[widget.index].toColor(),
                  onPressed: () {
                    t.name = controller.text;
                    model.onAddTask(model.projects[widget.index], t);
                  },
                )
              ],
            )
          ]);
        });
  }

  Widget LoadPage(ViewModel model) {
    if (model.projects[widget.index].tasks.isEmpty) {
      return new SliverFillRemaining(
          child: Center(child: Text('Create a New Task!')));
    }
    if (model.projects[widget.index].tasks == null) {
      return CircularProgressIndicator();
    } else
      return TaskList(widget.index);
  }

  Widget _AppBar(ViewModel model) {
    return new Container(
        child: Column(
      children: <Widget>[
        SizedBox(
          height: 100,
        ),
        Text(
          model.projects[widget.index].name,
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ProgressBar(widget.index),
      ],
    ));
  }

  Future<bool> _onRefresh(ViewModel model) async {
    await model.onGetProjectTask(model.projects[widget.index]);
    if (model.projects[widget.index].state == PageType.VAL) {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
        converter: (Store<AppState> store) => ViewModel.create(store),
        rebuildOnChange: true,
        builder: (BuildContext context, ViewModel model) => Scaffold(
              body: RefreshIndicator(
                  onRefresh: () => _onRefresh(model),
                  child: Stack(children: <Widget>[
                    CustomScrollView(
                      slivers: <Widget>[
                        SliverAppBar(
                          expandedHeight: 200,
                          backgroundColor:
                              model.projects[widget.index].toColor(),
                          flexibleSpace: new FlexibleSpaceBar(
                            centerTitle: true,
                            background: _AppBar(model),
                          ),
                        ),
                        LoadPage(model)
                      ],
                    ),
                    Positioned(
                        bottom: 0,
                        left: 7,
                        right: 7,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          decoration: BoxDecoration(
                            borderRadius: new BorderRadius.circular(20.0),
                            color: Colors.white,
                            border: Border.all(
                              color: model.projects[widget.index].toColor(), 
                              width: 2.6,
                            )
                          ),
                          child: TextField(
                            onSubmitted: (value) => _createNewTaskNew(model),
                            controller: controller,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Task Name',
                            ),
                          ),
                        ))
                  ])),
              bottomNavigationBar: new BottomAppBar(
                shape: CircularNotchedRectangle(),
                notchMargin: 4.0,
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () => _whiteListControl(context, model),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ));
  }
}
