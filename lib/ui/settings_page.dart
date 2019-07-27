import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/data/Account.dart';
import 'package:progress_bar/data/auth.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:redux/redux.dart';

class SettingsPage extends StatefulWidget {
  Auth auth;
  SettingsPage({this.auth});
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  Widget _title(String title, ViewModel model) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Text(
        title,
        
        softWrap: true,
        style: TextStyle(fontSize: 60, color: model.account.darkTheme ? Colors.white: Colors.black),
      ),
    );
  }

  Widget item(Icon icon, String title, List<String> options, Function(String, ViewModel) callback, ViewModel model,
      {String initialValue}) {
    List<DropdownMenuItem> dropDown = [];
    options.forEach((option) => dropDown.add(DropdownMenuItem(
          child: Text(option, style: TextStyle(color: model.account.darkTheme ? Colors.grey : Colors.black),),
          value: option,
        )));
    return ListTile(
      leading: icon,
      title: Text(title, style: TextStyle(color: model.account.darkTheme ? Colors.white : Colors.black),),
      trailing: DropdownButton(
        items: dropDown,
        value: initialValue,
        onChanged: (value) => callback(value, model),
        //value: (initialValue == null) ? options[0] : initialValue,
      ),
    );
  }

  void AccountUpdate(String value, ViewModel model) {
    Account account = model.account;
    account.progressType = value;
    model.onUpdateAccount(widget.auth, account);
  }
  void SortingUpdate(String value, ViewModel model){
    model.projects.forEach((project) => model.onUpdateProject(project)); 
    Account account = model.account; 
    account.sortingType = value; 
    model.onUpdateSorting(account); 
    model.onUpdateAccount(widget.auth,account); 
  }
  Widget about(ViewModel model){
    return Column(children: <Widget>[
      ListTile(
        leading: Icon(Icons.info, color: model.account.darkTheme ? Colors.white:Colors.black),
        title: Text('About', style: TextStyle(color: model.account.darkTheme ? Colors.white:Colors.black),),

      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Hello ' + ((model.account.name == null) ? 'user' : model.account.name) + 
          """
,\n \n My name is Kashif and I am the developer of Progress Bar! I developed this app to manage both my school work and my projects. This is something I have been working on throughout my second year and I hope it is something you wil find useful as well! 

If there are any of you wondering, no your data will not be sold. I have done my best to try to keep this app as secure as possible to my knowledge however I would advise you to keep sensitive data off of this platform. If you have any questions are would like to request any features please email me at 

progressbarhelp@gmail.com


          """,
          style: TextStyle(
            fontSize: 14,
            color: model.account.darkTheme ? Colors.white:Colors.black
          ),
        ),
      )
    ],);
  }
  Widget darkTheme(ViewModel model) {
    return ListTile(
      leading: Icon(Icons.brightness_medium,color: model.account.darkTheme ? Colors.white:Colors.black),
      title: Text('Dark Mode', style: TextStyle(color:model.account.darkTheme ? Colors.white:Colors.black),),
      trailing: Switch(
        value: model.account.darkTheme,
        onChanged: (value) {
          Account account = model.account;
          account.darkTheme = value;
          model.onUpdateAccount(widget.auth, account);
        },
      ),
    );
  }
  Widget swapActivation(ViewModel model){
    return ListTile(
      leading: Icon(Icons.swap_horizontal_circle, color:  model.account.darkTheme ? Colors.white:Colors.black,),
      title: Text('Change Sliding Side'),
    );
  }
  Widget _options(ViewModel model) {
    return Container(
      child: Column(
        children: <Widget>[
          item(
              Icon(Icons.adjust, color: model.account.darkTheme ? Colors.white:Colors.black,), 'Progress Type', Account.ProgressTypes, AccountUpdate, model,
              initialValue: model.account.progressType),
          item(Icon(Icons.sort,color: model.account.darkTheme ? Colors.white:Colors.black), 'Task Sorting', Account.SortingTypes, SortingUpdate, model,
              initialValue: model.account.sortingType),
          darkTheme(model)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
        rebuildOnChange: true,
        converter: (Store<AppState> store) => ViewModel.create(store),
        builder: (BuildContext context, ViewModel model) => Scaffold(
          backgroundColor: model.account.darkTheme ? Colors.black: Colors.white,
                body: SafeArea(
              child: CustomScrollView(slivers: <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate(<Widget>[]
                      ..add(_title('Settings',model))
                      ..add(_options(model))
                      ..add(about(model))))
              ]),
            )));
  }
}
