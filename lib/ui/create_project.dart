import 'package:flutter/material.dart';
import 'package:progress_bar/data/Project.dart';
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:progress_bar/ui/date_options.dart';
import 'package:redux/redux.dart';
import 'package:progress_bar/domain/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/data/auth.dart';
class CreateProject extends StatefulWidget{
  final Auth auth;
  final Project project; 
  CreateProject({this.auth, this.project});
  _CreateProject createState() => new _CreateProject();
}
class _CreateProject extends State<CreateProject>{
  Project proj;
  @override
  void initState() {
    super.initState();
    if (widget.project == null)
      proj = new Project('Untitled', 'description', Colors.pink.toString(), 'Project', users: [widget.auth.getUID()], dateCreated: DateTime.now());
    else proj = new Project(widget.project.name, widget.project.description, widget.project.color, widget.project.projType, id: widget.project.id, deadline: widget.project.deadline); 
  }
  void setName(String text){
    setState(() {
      proj.name = text;
    });
  }
  void setProjectDesc(String text){
    setState(() {
      proj.description = text;
    });
  }
  void setProjectType(String type) {
    setState(() {
      proj.projType = type;
    });
  }
  void setProjectColour(Color c){
    setState(() {
      proj.color = c.toString();
    });
  }
  @override
    Widget build(BuildContext context) {
      return StoreConnector<AppState, ViewModel>( 
      converter:(Store<AppState> store) => ViewModel.create(store),
      builder: (BuildContext context, ViewModel model) => WillPopScope(
        onWillPop: () async{
          if (widget.project != null)
            model.onUpdateProjectSettings(model.projects[widget.project.index]); 
          return true; 
        },
      child:Theme(data: (model.account.darkTheme) ? ThemeData.dark() : ThemeData.light(), child:Scaffold(
      backgroundColor: model.account.darkTheme ? Colors.black:Colors.white,
      body: new ListView(
          //mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 20.0),
                  color: proj.toColor(),
                  width: double.infinity,
                  child: new Text('Create Project',
                    textAlign: TextAlign.start,
                    textScaleFactor: 1.6,
                    style: new TextStyle(color: Colors.white)
                )
              ),
              new Center(
              child: new Container(
                width: double.infinity,
                color: proj.toColor(),
                alignment: AlignmentDirectional(-1.0, -1.0),
                constraints: BoxConstraints(
                maxHeight: 120.0,
                maxWidth: double.infinity
                ),
              child: Center(child: Text(proj.name,
              textScaleFactor: 3.0,
              style: new  TextStyle(color: Colors.white)))),
              ),
              new Container(
                padding: const EdgeInsets.all(30.0),
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                        padding: EdgeInsets.only(top: 30.0),
                        child: new TextField(
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            hintText: proj.name,
                            hintStyle: TextStyle(color: Colors.grey)
                          ),
                          onChanged: (text) {
                            setName(text);
                          },
                        )
                    ),
                    new Container(
                        padding: EdgeInsets.only(top: 20.0),
                        child: new TextField(
                          onChanged:(text) {setProjectDesc(text);},
                          decoration: InputDecoration(hintText: (proj.description == null) ? 'Description': proj.description),
                        )
                    ),
                    SizedBox(height: 10,),
                    
                    new FlatButton(
                      child: Row(children: <Widget>[
                        Icon(Icons.calendar_today), 
                        Text(
                          (proj.deadline == null) ? 'Add a deadline' : proj.deadline.toString().split(' ')[0]
                        )
                      ],),
                      onPressed: () => showDatePicker(
                        context: context, 
                        initialDate: DateTime.now(), 
                        firstDate: DateTime(2019), 
                        lastDate: DateTime(2030), 
                        builder: (BuildContext context, Widget child){
                          return Theme(
                            data: ThemeData.light(),
                            child: child,
                          );
                        }
                      ).then((onValue){
                        setState(() {
                          proj.deadline = onValue; 
                        });
                      }),
                    )
                    
                  ]
                )
              ),
              new Center(
                child: new Container(
                  padding: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  child: ColourOptions(
                    colourValues: [Colors.red, Colors.pink, Colors.purple, Colors.blue, Colors.green, Colors.orange],
                    onOptionSelect: (Color color){
                      setProjectColour(color);
                      },
                  )
                ),
              ),
              new Container(
                padding: EdgeInsets.only(top: 20),
                child: new FloatingActionButton(
                  child: new Icon(Icons.keyboard_arrow_right),
                  onPressed: (){
                    if (widget.project == null)
                      model.onCreateProject(proj,widget.auth);
                    else model.onUpdateProjectSettings(proj); 
                    Navigator.pop(context, true);
                  },
                ),
              ),
        ]
      ),
    ))));
    }
}
typedef ColourOptionCallback = void Function(Color color);
typedef ColourCallback = void Function(Color color);

class ColourOptions extends StatelessWidget{
  const ColourOptions({this.onOptionSelect, this.colourValues});
  final ColourOptionCallback onOptionSelect;
  final List<Color> colourValues;

  List<Widget> CreateRow(List<Color> colours){
    List<Widget> a = new List<Widget>();
    for (int i= 0; i < colours.length; i++){
      a.add(new ColourPicker(
        iconColour: colours[i],
        onColourSelect: (Color color){
          onOptionSelect(color);
        },
      ));
    }
    return a;
  }
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new  Row(
          children: CreateRow([colourValues[0], colourValues[1], colourValues[2]]),
        ),
        new Padding(padding: new EdgeInsets.all(10.0)),
        new  Row(
          children: CreateRow([colourValues[3], colourValues[4], colourValues[5]])
        ),
      ]
    );
  }
}
class ColourPicker extends StatelessWidget{
  const ColourPicker({this.onColourSelect, this.iconColour});
  final Color iconColour;
  final ColourCallback onColourSelect;
  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new FloatingActionButton(
          heroTag: iconColour.toString(),
          backgroundColor: iconColour,
          onPressed: (){
            onColourSelect(iconColour);
          }
      ),
    );
  }
}