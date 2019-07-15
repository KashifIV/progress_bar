import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:progress_bar/data/Account.dart';
import 'package:progress_bar/data/create_link.dart';
import 'package:progress_bar/data/Project.dart';
import 'package:progress_bar/data/auth.dart';
import 'package:progress_bar/ui/project_card.dart';
import 'package:progress_bar/ui/share_project.dart';
import 'package:redux/redux.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:share/share.dart';
import 'package:progress_bar/domain/viewmodel.dart';

class AccountPage extends StatefulWidget {
  final VoidCallback onSignedOut;
  final Auth auth;
  AccountPage({this.auth, this.onSignedOut});
  _AccountPage createState() => _AccountPage();
}

class _AccountPage extends State<AccountPage> {
  bool isEditing ; 
  final userControl = TextEditingController();
  void initState(){
    isEditing = false; 
  }
  Widget _dialog(ViewModel model, BuildContext context, Project project) {
    return AlertDialog(
      title: Text('Delete ' + project.name + '?'),
      content: Text('Are you sure you want to delete this project?'),
      actions: <Widget>[
        FlatButton(
            child: Text('Cancel'), onPressed: () => Navigator.pop(context)),
        FlatButton(
          child: Text('Delete Project'),
          onPressed: () {
            if (model.account.joinedProjects.contains(project.id)){
              model.account.joinedProjects = []..addAll(model.account.joinedProjects.where((proj) => proj != project.id));
              model.onUpdateAccount(widget.auth, model.account); 
              model.onRemoveProject(project, true);
            }
            else model.onRemoveProject(project, false);
            Navigator.pop(context);
          },
        )
      ],
    );
  }
  Widget _shareProjectDialog(BuildContext context, ViewModel model, Project project){
    return AlertDialog(
      title: Text('How would you like to Share your Project?'),
      content: Text('Clone: Give them a Copy. \nCollaborate: Work Together.'),
      actions: <Widget>[
        FlatButton(child: Text('Clone'), onPressed: () => CloneProjectLink(project).then((value) => Share.share(value.toString())),), 
        FlatButton(child: Text('Collab'), onPressed: (){
          Navigator.pop(context); 
          Navigator.push(context, MaterialPageRoute(builder: (context) => ShareProject(project)));
          }
          ),
        ],
    );
  }
  List<Widget> _getProjects(ViewModel model, BuildContext context) {
    List<Widget> a = [];
    model.projects.forEach((project) {
      a.add(Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Slidable(
            key: new Key(project.id),
            child: ProjectCard(project.index),
            delegate: SlidableBehindDelegate(),
            actionExtentRatio: 0.25,
            actions: <Widget>[
              IconSlideAction(
                icon: Icons.share,
                color: Colors.blue,
                onTap: () => showDialog(
                  context: context, 
                  builder: (context) => _shareProjectDialog(context, model, project)
                )
              )
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Delete Project',
                icon: Icons.delete_forever,
                color: Colors.red,
                onTap: () => showDialog(
                      context: context,
                      builder: (context) => _dialog(model, context, project),
                    ),
              ),
              IconSlideAction(
                color: Colors.grey,
                icon: Icons.visibility,
                caption: 'Hide Project',
              )
            ],
          )));
      a.add(SizedBox(height: 10,));
    });
    return a;
  }

  Widget _userNameEdit(ViewModel model) {
    if (!isEditing) {
      return Text(
        (model.account.name == null) ? 'Username' : model.account.name,
        style: TextStyle(
          color: Colors.black,
          fontSize: 32,
        ),
      );
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: userControl,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
        converter: (Store<AppState> store) => ViewModel.create(store),
        rebuildOnChange: true,
        builder: (BuildContext context, ViewModel model) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              bottomOpacity: 0,
              actions: <Widget>[
                FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  onPressed: (){
                    if (isEditing){
                      Account account = model.account; 
                      account.name = (userControl.text.isNotEmpty)? userControl.text : 'Username';
                      model.onUpdateAccount(widget.auth, account);
                    }
                    setState(() {
                     isEditing = !isEditing;  
                    });                    
                  },
                  child: Icon(
                    (isEditing) ?Icons.save:Icons.edit,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            body: SafeArea(
                child: Center(
                    child: Container(
                        child: ListView(
                            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.blue,
              ),
              Center(
                child: (isEditing)? _userNameEdit(model): Text(
                  (model.account.name == null)
                      ? 'Username'
                      : model.account.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                  ),
                ),
              ),
              Center(
                  child: Text(
                (model.account.email == null) ? 'Email' : model.account.email,
                style: TextStyle(color: Colors.black, fontSize: 20),
              )),
              SizedBox(
                height: 20,
              ),
            ]
                              ..addAll(_getProjects(model, context))
                              ..add(FlatButton(
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      color: Colors.blue,
                                      child: Text(
                                        'Sign Out',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      )),
                                  onPressed: () {
                                    model.onUpdatePage(PageType.UND); 
                                    widget.onSignedOut();
                                    Navigator.pop(context);
                                  }))))))));
  }
}
