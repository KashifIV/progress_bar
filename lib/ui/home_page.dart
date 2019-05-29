import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/data/auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/ui/create_project.dart';
import 'package:progress_bar/ui/emergency_list.dart';
import 'package:progress_bar/ui/main_drawer.dart';
import 'package:progress_bar/ui/project_card.dart';
import 'package:progress_bar/ui/taglist.dart';
import 'package:progress_bar/ui/task_list.dart';
import 'package:redux/redux.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:progress_bar/ui/account_page.dart';
import 'package:progress_bar/ui/calendar_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.onSignedOut}) : super(key: key);
  final Auth auth;
  final VoidCallback onSignedOut;
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int projIndex = 0; 
  Widget _logo(ViewModel model, BuildContext context) {
    return Column(children: <Widget>[
      SizedBox(
        height: 20,
      ),
      Container(
          width: 400,
          height: 100,
          child: DecoratedBox(
            decoration: BoxDecoration(
                image:
                    DecorationImage(image: AssetImage('assets/logoLight.png'))),
          )),
          
    ]);
  }
  Widget _undUser(ViewModel model) {
    model.onFetchAccount(widget.auth.getUID()); 
    model.onGetProject(widget.auth); 
    if(model.projects != null  && model.projects.length>0)model.onGetProjectTask(model.projects[0]); 
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }

  Widget _newUser(ViewModel model) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Container(
            padding: const EdgeInsets.all(34.0),
            child: new Text('Progress Bar',
                textAlign: TextAlign.start,
                textScaleFactor: 2.0,
                style: new TextStyle(color: Colors.grey))),
        new Center(
            child: Text(
          'Tap the "+" icon to get started!',
        )),
        new IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => model.onGetProject(widget.auth)),
      ],
    );
  }

  Widget _pageHandler(BuildContext context, ViewModel model) {
    switch (model.pageType) {
      case PageType.VAL:
        return _mainPage(context, model);
      case PageType.UND:
        return _undUser(model);
      case PageType.NEW:
        return _newUser(model);
    }
  }

  Widget _mainPage(BuildContext context, ViewModel model) {
    final controller = PageController(viewportFraction: 0.95);
    return
    RefreshIndicator(
      onRefresh: (){

      },
      child: Column(
      children: <Widget>[
        SizedBox(
            height: MediaQuery.of(context).size.height - 280,
            width: 400,
            child:(projIndex != model.projects.length) ? CustomScrollView(
              slivers: <Widget>[EmergencyList(projIndex),TagList(projIndex),TaskList(projIndex, emergency: true,)],
            ): Center(child: Text('Create a Project!'),)),
        Center(
          child: _buildCarousel(context, model, controller),
        )
      ],
    ));
  }

  void onPageChanged(int value) {
    setState(() {
      projIndex = value;
    });
  }

  Widget _buildCarousel(
      BuildContext context, ViewModel model, PageController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 110,
          child: PageView.builder(
            itemCount: model.projects.length + 1,
            controller: controller,
            onPageChanged: onPageChanged,
            itemBuilder: (BuildContext context, int index) {
              if (index == model.projects.length) {
                return Container(child: GestureDetector(
                  onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateProject(widget.auth)))
                      .then((val) => model.onGetProject(widget.auth)),
                  child: Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width * 0.80,
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey
                      )
                    ),
                    child: Center(
                      child: Text(
                        'Create a New Project!',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                ));
              }
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                child:ProjectCard(index)
                );
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
        rebuildOnChange: true,
        builder: (BuildContext context, ViewModel model) => Scaffold(
          drawer: MainDrawer(model.account.name, auth: widget.auth, onSignedOut: widget.onSignedOut,),
              body: SafeArea(
                child: Column(
                  children: <Widget>[
                    _logo(model, context),
                    _pageHandler(context, model)
                  ],
                ),
              ),
            ));
  }
}
