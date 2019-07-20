import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/data/Account.dart';
import 'package:progress_bar/data/auth.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:redux/redux.dart';

class SettingsPage extends StatefulWidget{
  Auth auth; 
  SettingsPage({this.auth}); 
  _SettingsPage createState() => _SettingsPage(); 
}
class _SettingsPage extends State<SettingsPage>{
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
  Widget item(Icon icon, String title, List<String> options, ViewModel model, {String initialValue}){
    List<DropdownMenuItem> dropDown= []; 
    options.forEach((option) => dropDown.add(DropdownMenuItem(child: Text(option), value: option,)));
    return ListTile(
      leading: icon,
      title: Text(title),
      trailing: DropdownButton(
        items: dropDown,
        value: model.account.progressType,
        onChanged: (value){
          Account account = model.account; 
          account.progressType = value; 
          model.onUpdateAccount(widget.auth, account); 
        },
        //value: (initialValue == null) ? options[0] : initialValue,
      ),
    );
  }
  Widget _options(ViewModel model){
    return Container(
      child: Column(
        children: <Widget>[
          item(Icon(Icons.adjust), 'Progress Type', ['Task','Deadline', 'Time'], model, initialValue: model.account.progressType), 
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      rebuildOnChange: true,
      converter: (Store<AppState> store) => ViewModel.create(store),
      builder: (BuildContext context, ViewModel model) =>Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: <Widget>[
              SliverList(
              delegate: SliverChildListDelegate( <Widget>[]
              ..add(_title('Settings'))
              ..add(_options(model))
            ))]),
          )
      ));
  }
}