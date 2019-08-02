import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_bar/data/auth.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:progress_bar/ui/create_project.dart';
import 'package:progress_bar/ui/create_task.dart';
import 'package:redux/redux.dart';
import 'package:progress_bar/domain/actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/data/Task.dart';
import 'package:progress_bar/ui/task_list.dart';
import 'package:progress_bar/ui/progress_bar.dart';

class ProjectPage extends StatefulWidget {
  final int index;
  final String tag; 
  ProjectPage(this.index, {this.tag});
  _ProjectPage createState() => _ProjectPage();
}

class _ProjectPage extends State<ProjectPage> {
  String whiteListTag; 
  bool isSearching; 
  void initState(){
    isSearching = false; 
    if (widget.tag != null) whiteListTag = widget.tag; 
    super.initState(); 
  }
  Widget checkSelect(ViewModel model, WhiteList value, {String tag}) {
    if (model.whiteList == value) {
      if (value == WhiteList.tag && whiteListTag == tag){
       return Icon(Icons.radio_button_checked);
      }
      else if (value != WhiteList.tag)
        return Icon(Icons.radio_button_checked); 
    }
    return Icon(Icons.radio_button_unchecked);
  }

  final controller = TextEditingController();
  void _whiteListControl(BuildContext context, ViewModel model) {
    List<Widget> tags = []; 
    model.projects[widget.index].tags.forEach((tag){
      tags.add(ListTile(
        leading: checkSelect(model, WhiteList.tag, tag: tag),
        title: Text(tag),
        onTap: (){
          model.onUpdateWhiteList(WhiteList.tag); 
          whiteListTag = tag; 
          Navigator.pop(context); 
        },
      ));
    });
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return ListView(
            children: <Widget>[
              ListTile(
                leading: checkSelect(model, WhiteList.incomplete),
                title: Text('Incomplete'),
                onTap: () {
                  model.onUpdateWhiteList(WhiteList.incomplete);
                  whiteListTag = null; 
                  Navigator.pop(context);                 
                },
              ),
              ListTile(
                leading: checkSelect(model, WhiteList.complete),
                title: Text('Complete'),
                onTap: () {
                  model.onUpdateWhiteList(WhiteList.complete);
                  whiteListTag = null; 
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: checkSelect(model, WhiteList.all),
                title: Text('All'),
                onTap: () {
                  model.onUpdateWhiteList(WhiteList.all);
                  whiteListTag = null; 
                  Navigator.pop(context);
                },
              ), 
              ListTile(
                leading: checkSelect(model, WhiteList.routine_daily),
                title: Text('Daily Tasks'),
                onTap: (){
                  model.onUpdateWhiteList(WhiteList.routine_daily); 
                  whiteListTag = null; 
                  Navigator.pop(context); 
                },
              ),
              ListTile(
                leading: checkSelect(model, WhiteList.routine_weekly),
                title: Text('Weekly Tasks'),
                onTap: (){
                  model.onUpdateWhiteList(WhiteList.routine_weekly); 
                  whiteListTag = null; 
                  Navigator.pop(context); 
                },
              ),
              ListTile(
                leading: checkSelect(model, WhiteList.routine_monthly),
                title: Text('Monthly Tasks'),
                onTap: (){
                  model.onUpdateWhiteList(WhiteList.routine_monthly); 
                  whiteListTag = null; 
                  Navigator.pop(context); 
                },
              ),
            ]..addAll(tags),
          );
        });
  }



  Widget LoadPage(ViewModel model) {
    if (whiteListTag != null){
      model.onUpdateWhiteList(WhiteList.tag); 
    }
    if (model.projects[widget.index].tasks.isEmpty) {
      return new SliverFillRemaining(
          child: Center(child: Text('Create a New Task!')));
    }
    if (model.projects[widget.index].tasks == null) {
      return CircularProgressIndicator();
    } else
      return TaskList(widget.index, tag: whiteListTag,);
  }
  String _convertToReadableTime(DateTime time){
    List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    String suffix = 'th'; 
    if (time.day == 1  || time.day == 21 || time.day == 31)suffix = 'st'; 
    else if (time.day == 2 || time.day == 22) suffix = 'nd';
    else if (time.day == 3 || time.day == 23) suffix = 'rd';
    return months[time.month-1] + ' ' + time.day.toString() + suffix + ' ' + time.year.toString(); 
  }
  Widget _AppBar(ViewModel model) {
    return new PreferredSize( 
      preferredSize: Size.fromHeight(140),
      child:Hero(
      tag: model.projects[widget.index].id,
        child: SingleChildScrollView(
          child: Container(
            height: 160,
            //color: Colors.transparent,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Material(
                  color: Colors.transparent,
                  child: Container(
                    //height: 35,
                    child:Text(
                  model.projects[widget.index].name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: (model.projects[widget.index].name.length > 23) ? 25:30,
                    color: Colors.white,
                  ),
                )), 
                ),
                SizedBox(height: 13,),
                ProgressBar(
                  widget.index,
                ),
                Center(
                  child: (model.projects[widget.index].deadline != null)? 
                    Material(
                      color: Colors.transparent,
                    child: Text(_convertToReadableTime(model.projects[widget.index].deadline), style: TextStyle(fontSize: 20, color: Colors.white),)):
                    SizedBox(height: 23,),
                ),
                Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      child: Icon(Icons.menu, color: Colors.white,),
                      onPressed: () => _whiteListControl(context, model),
                    ),
                    FlatButton(
                      child: Icon(Icons.settings, color: Colors.white), 
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProject(project: model.projects[widget.index],)))
                      .then((onValue) => model.onUpdateProject(model.projects[widget.index])),
                    )
                  ],
                )), 
                //SizedBox(height: 10,),
              ],
            )))));
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
          backgroundColor: (model.account.darkTheme) ? Colors.black : Colors.white,
              body: RefreshIndicator(
                  onRefresh: () => _onRefresh(model),
                  child: Stack(children: <Widget>[
                    CustomScrollView(
                      slivers: <Widget>[
                        SliverAppBar(
                          expandedHeight: 205,
                          backgroundColor:
                              model.projects[widget.index].toColor(),
                              
                          flexibleSpace: new FlexibleSpaceBar(
                            centerTitle: true,
                            background:  Container(
                              decoration: new BoxDecoration(
                                gradient: new LinearGradient(
                                    colors: [
                                      Color.alphaBlend(model.projects[widget.index].toColor().withAlpha(210), Colors.black), 
                                      Colors.teal[600]
                                    ],
                                    begin: const FractionalOffset(0.0, 0.0),
                                    end: const FractionalOffset(0.9, 0.3),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                                color: model.projects[widget.index].toColor(),
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
                            ),
                          ),
                          bottom: _AppBar(model),
                        ),
                        LoadPage(model), 
                      ],
                    ),
                    CreateTask(widget.index)])),
                  
            ));
  }
}
