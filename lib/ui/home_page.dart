import 'package:flutter/material.dart';
import 'package:progress_bar/data/auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/ui/calendar_page.dart';
import 'package:progress_bar/ui/account_page.dart';
import 'package:progress_bar/ui/project_card.dart';
import 'package:progress_bar/ui/create_project.dart';

class HomePage extends StatelessWidget{
  HomePage({Key key, this.auth, this.onSignedOut}) : super(key: key);
  final Auth auth;
  final VoidCallback onSignedOut;
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
              onPressed:() => Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage(onSignedOut: onSignedOut,)),),
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
  Widget PageHandler(ViewModel model){
    switch(model.pageType){
      case PageType.VAL:
        return null;
      case PageType.UND:
        return UndUser(model);
      case PageType.NEW:
        return NewUser(model);
    }
  }
  Widget UndUser(ViewModel model){
    model.onGetProject(auth);
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }
  Widget NewUser(ViewModel model){
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
        new IconButton(icon: Icon(Icons.refresh), onPressed: () => model.onGetProject(auth)),
      ],
    );
  }
  Widget _FloatingActionButtonTemplate(BuildContext context, ViewModel model){
    return new FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProject(auth)))
              .then((val)=> model.onGetProject(auth));
        },
        heroTag: 'Add',
        tooltip: 'Add a New Project',
        child: new Icon(Icons.add),
    );
  }
  List<Widget> _getProjectCards(BuildContext context, ViewModel model){
    List<Widget> a = [];
    for (int i = 0; i < model.projects.length; i++){
      if (model.projects[i].name != null){
        a.add(ProjectCard(i));
      }
    }
    return a;
  }
  Future<bool> _onRefresh(ViewModel model) async {
    await model.onGetProject(auth);
    if (model.pageType == PageType.VAL)
    {
      return true;
    }
  }
  @override
    Widget build(BuildContext context) {
      return StoreConnector<AppState, ViewModel>(
        converter: (Store<AppState> store) => ViewModel.create(store),
        builder: (BuildContext context, ViewModel model){
          if (model.pageType != PageType.VAL){
            return new Scaffold(body: SafeArea(child:PageHandler(model)), floatingActionButton: _FloatingActionButtonTemplate(context, model),);
          }
          else{
            return SafeArea(            
              child: Scaffold(    
                body: RefreshIndicator(

                  onRefresh: () => _onRefresh(model),
                  child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      expandedHeight: 250,
                      backgroundColor: Colors.white12,
                      flexibleSpace: new FlexibleSpaceBar(
                        background: _logo(model, context),
                      ),
                    ),
                    new SliverList(
                      delegate: SliverChildListDelegate(                      
                        _getProjectCards(context, model)
                      ),
                    )
                  ],
                )),
                floatingActionButton: _FloatingActionButtonTemplate(context, model),
            ));
          }
        },
      );
    }
}