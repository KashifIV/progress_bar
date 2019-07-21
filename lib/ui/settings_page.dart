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
  Widget _title(String title) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Text(
        title,
        softWrap: true,
        style: TextStyle(fontSize: 60),
      ),
    );
  }

  Widget item(Icon icon, String title, List<String> options, Function(String, ViewModel) callback, ViewModel model,
      {String initialValue}) {
    List<DropdownMenuItem> dropDown = [];
    options.forEach((option) => dropDown.add(DropdownMenuItem(
          child: Text(option),
          value: option,
        )));
    return ListTile(
      leading: icon,
      title: Text(title),
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
    model.onUpdateSorting(value); 
    model.projects.forEach((project) => model.onUpdateProject(project)); 
    Account account = model.account; 
    account.sortingType = value; 
    model.onUpdateAccount(widget.auth,account); 
  }

  Widget darkTheme(ViewModel model) {
    return ListTile(
      leading: Icon(Icons.brightness_medium),
      title: Text('Dark Mode'),
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

  Widget _options(ViewModel model) {
    return Container(
      child: Column(
        children: <Widget>[
          item(
              Icon(Icons.adjust), 'Progress Type', Account.ProgressTypes, AccountUpdate, model,
              initialValue: model.account.progressType),
          item(Icon(Icons.sort), 'Task Sorting', Account.SortingTypes, SortingUpdate, model,
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
                body: SafeArea(
              child: CustomScrollView(slivers: <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate(<Widget>[]
                      ..add(_title('Settings'))
                      ..add(_options(model))))
              ]),
            )));
  }
}
