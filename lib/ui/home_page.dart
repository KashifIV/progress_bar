import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/data/auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/ui/project_card.dart';
import 'package:progress_bar/ui/task_list.dart';
import 'package:redux/redux.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:progress_bar/ui/account_page.dart';
import 'package:progress_bar/ui/calendar_page.dart';
class HomePage extends StatefulWidget{
  HomePage({Key key, this.auth, this.onSignedOut}): super(key:key); 
  final Auth auth; 
  final VoidCallback onSignedOut; 
  _HomePage createState() => _HomePage();
}
class _HomePage extends State<HomePage>{
  int projIndex = 0; 
     Widget _logo(ViewModel model, BuildContext context){
    return Column (
      children: <Widget>[
        SizedBox(height: 50,),
        Container(
          width: 400,
          height: 100,
          child: DecoratedBox(
            decoration: BoxDecoration(
              image:DecorationImage(
                image: AssetImage('assets/logoLight.png')
              )
            ),
        )), 
        ButtonBar(     
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(Icons.settings),
              //shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
              backgroundColor: Colors.red,
              heroTag: 'Settings',
              onPressed:() => null,
              elevation: 2.0,
            ),
            FloatingActionButton(
              child: Icon(Icons.account_circle),
              //shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
              backgroundColor: Colors.blue,
              heroTag: 'Account',
              onPressed:() => Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage(onSignedOut: widget.onSignedOut,)),),
              elevation: 2.0,
            ),
            FloatingActionButton(
              child: Icon(Icons.calendar_today),
              //shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
              backgroundColor: Colors.green,
              heroTag: 'Callendar',
              onPressed:() => Navigator.push(context, MaterialPageRoute(builder:  (context) => CalendarPage())),
              elevation: 2.0,
            ),
          ],
        )
      ]
    );
  }
  Widget _undUser(ViewModel model){
    model.onGetProject(widget.auth);
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }
  Widget _newUser(ViewModel model){
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Container(
            padding: const EdgeInsets.all(34.0),
            child: new Text('Progress Bar',
                textAlign: TextAlign.start,
                textScaleFactor: 2.0,
                style: new TextStyle(color: Colors.grey)
            )
        ),
        new Center(child: Text(
          'Tap the "+" icon to get started!',
        )),
        new IconButton(icon: Icon(Icons.refresh), onPressed: () => model.onGetProject(widget.auth)),
      ],
    );
  }
  Widget _pageHandler(BuildContext context, ViewModel model){
    switch(model.pageType){
      case PageType.VAL:
        return _mainPage(context, model);
      case PageType.UND:
        return _undUser(model);
      case PageType.NEW:
        return _newUser(model);
    }
  }
  Widget _mainPage(BuildContext context, ViewModel model){
    final controller = PageController(viewportFraction: 1.2); 
    return Column(
      children: <Widget>[
        SizedBox(
          height: 400,
          width: 400,
          child: CustomScrollView(
            slivers: <Widget>[
              TaskList(projIndex)
            ],
          )
        ),
        Center(
          child: _buildCarousel(context, model, controller),
        )
      ],
    );
  }
  void onPageChanged(int value){
    setState(() {
      projIndex = value; 
    });
  }
  Widget _buildCarousel(BuildContext context, ViewModel model, PageController controller){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 110,
          child: PageView.builder(
            itemCount: model.projects.length,
            controller: controller,
            onPageChanged: onPageChanged,
            itemBuilder: (BuildContext context, int index){
              return ProjectCard(index);
            },
          ),
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      converter: (Store<AppState> store) => ViewModel.create(store),
      builder: (BuildContext context, ViewModel model)=> Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              _logo(model, context),
              _pageHandler(context, model)
            ],
          ),
        ),
      )
    );
  }
}