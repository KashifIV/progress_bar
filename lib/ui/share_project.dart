import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/data/LinkBuilder.dart';
import 'package:progress_bar/data/Project.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:redux/redux.dart';
import 'package:share/share.dart';

class ShareProject extends StatefulWidget {
  final Project project;
  ShareProject(this.project);
  _ShareProject createState() => _ShareProject();
}

class _ShareProject extends State<ShareProject> {
  bool expanded;
  List<String> emails;
  final controller = TextEditingController();
  void initState() {
    expanded = false;
    if (widget.project.users != null && widget.project.users.length > 0){
      emails = []..addAll(widget.project.emails.where((e) => e != null && e.contains('@')));
      emails.forEach((email) => addChip(email)); 
    }else emails =[]; 
  }

  List<Widget> getEmailChips() {
    return emails.map((value) => EmailChip(value, onDelete)).toList();
  }

  void onDelete(String email) {
    if (emails.contains(email)) {
      setState(() {
        emails.remove(email);
      });
    }
  }

  void addChip(String email) {
    if (emails.contains(email)) return;
    setState(() {
      emails.add(email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
        converter: (Store<AppState> store) => ViewModel.create(store),
        rebuildOnChange: true,
        builder: (BuildContext context, ViewModel model) => Theme( data: (model.account.darkTheme)? ThemeData.dark() : ThemeData.light(), child: Scaffold(
      appBar: AppBar(
        title: Text('Share your Project'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Text(
              'Add the Emails of people you want to share this project with.',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            padding: EdgeInsets.all(20),
          ),
          Container(
              height: 200,
              padding: EdgeInsets.all(20),
              child: Wrap(
                children: getEmailChips(),
              )),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: <Widget>[
                Flexible(
                    child: TextField(
                  onSubmitted: (value){
                    if (value != null && value.isNotEmpty && value.contains('@') && value.split('@').length < 3){
                    addChip(value);
                    controller.text ="";
                    }
                    else {
                      controller.text =""; 
                      showDialog(context: context, builder: (context) => AlertDialog(title: Text('Please enter a valid email address.'), actions: <Widget>[FlatButton(child: Text('Continue'), onPressed: () => Navigator.pop(context),)],),);
                    }
                  },
                  controller: controller,
                )),
                IconButton(
                  icon: Icon(Icons.add),
                  color: widget.project.toColor(),
                  splashColor: widget.project.toColor(),
                  onPressed: (){
                    if (controller.text != null && controller.text.contains('@') && controller.text.split('@').length < 3){
                      addChip(controller.text);
                      controller.text ="";
                    }
                    else {
                      controller.text =""; 
                      showDialog(context: context, builder: (context) => AlertDialog(title: Text('Please enter a valid email address.'), actions: <Widget>[FlatButton(child: Text('Continue'), onPressed: () => Navigator.pop(context),)],),);
                    }
                  }
                )
              ],
            ),
          ),
          Center(
            child: FlatButton(
              child: Text(
                'Share!',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => CollabProjectLink(widget.project, emails, model).then((value) => Share.share(value.toString())),
              color: widget.project.toColor(),
            ),
          ), 
        ],
      ),
    )));
  }
}

class EmailChip extends StatelessWidget {
  String email;
  Function(String) callback;
  EmailChip(this.email, this.callback);
  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(
        email.substring(0, email.indexOf('@')),
      ),
      onPressed: () => callback(email),
      avatar: CircleAvatar(
        child: Text(
          email.substring(0, 2).toUpperCase(),
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
