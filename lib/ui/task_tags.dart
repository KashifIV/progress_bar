import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/data/Log.dart';
import 'package:progress_bar/data/app_color.dart' as appcolor; 
import 'package:redux/redux.dart'; 
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:progress_bar/data/Task.dart';
import 'package:progress_bar/domain/redux.dart';

class TaskTags extends StatefulWidget{
  final int projIndex;
  final Task task;  
  TaskTags(this.projIndex, this.task); 
  _TaskTags createState() => _TaskTags(); 
}
class _TaskTags extends State<TaskTags>{
  bool isExpanded = false; 
  Task task; 
  void initState(){
    task = widget.task; 
  }
  Widget _createGraidentChip(String tag, ViewModel model){
    return Hero(child: GestureDetector(
      onTap: (){
        Task task = widget.task; 
          if (task.tags == null){
            task.tags = [tag]; 
          }
          else if (task.tags.contains(tag)){
            task.tags.remove(tag);
          }
          else {
            task.tags.add(tag); 
          }
          if (task.logs == null ) task.logs = []; 
          model.onUpdateTask(model.account,model.projects[widget.projIndex], task); 
      },
      child: Container(
        
        child: Text(
          tag,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), 
         color: appcolor.tagColors[model.projects[widget.projIndex].tags.indexOf(tag)%appcolor.tagColors.length],

        )
      ),
    ), tag: tag,);
  }
  Widget _createChip(String tag, ViewModel model){
    return ActionChip(
      label: Text(
          tag, 
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        onPressed: (){
          Task task = widget.task; 
          if (task.tags == null){
            task.tags = [tag]; 
          }
          else if (task.tags.contains(tag)){
            task.tags.remove(tag);
          }
          else {
            task.tags.add(tag); 
          }
          model.onUpdateTask(model.account,model.projects[widget.projIndex], task); 
        },
        backgroundColor: Colors.yellow,      
    );
  }
  Widget _createNewTag(ViewModel model){
    final newTagController = TextEditingController(); 
    return Container(
      width: 120,
      padding: EdgeInsets.only(left: 4, right: 4,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), 
        color: (model.account.darkTheme) ? Colors.black: Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 2,
        )
      ),
      child: Center(child: TextField(
        onSubmitted: (value) {
          if (task.tags == null)
            task.tags = []; 
          task.tags.add(value);
          model.onUpdateTask(model.account,model.projects[widget.projIndex],task);
          model.onUpdateProject(model.projects[widget.projIndex]);
        },
        style: TextStyle( color: (model.account.darkTheme) ? Colors.white: Colors.black,),
        
        controller: newTagController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(6),
          hintText: 'Add a Tag +',
          hintStyle: TextStyle( color: (model.account.darkTheme) ? Colors.grey: Colors.grey,),
          border: InputBorder.none
        ),
      ),
    ));
  }
  Widget _taskTags(List<String> tags, ViewModel model){
    if  (tags == null)tags = [];
    List<Widget> tagChips = []; 
    tags.forEach((tag)=> tagChips.add(_createGraidentChip(tag, model)));
    tagChips.add(_createNewTag(model)); 
    return Container(
      child: Wrap(
        children: tagChips,
        runSpacing:20,
        spacing: 20.0, 
      ),
    );
  }
  Widget _projectTags(List<String> tags, List<String> used, ViewModel model){
    List<String> options = (used != null) ? tags.where((tag) => !used.contains(tag)).toList(): tags;
    List<Widget> tagChips = []; 
    options.forEach((tag) => tagChips.add(_createGraidentChip(tag, model))); 
    return Theme( 
      data: (model.account.darkTheme) ? ThemeData.dark() : ThemeData.light(),
      child: ExpansionPanelList(
      
      expansionCallback: (int index, bool expanded){
        setState(() {
         isExpanded = !isExpanded;  
        });
      },
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) =>
            Container(
              //color: (model.account.darkTheme) ? Colors.black: Colors.white,
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Row(
                children: <Widget>[
                  Text('Tags',
                    style: TextStyle(
                      fontSize: 18,
                      //color: (model.account.darkTheme) ? Colors.white: Colors.black,
                    ),
                  ),
                ]
              ),
            ),
            isExpanded: isExpanded,
          body: Container(
            width: MediaQuery.of(context).size.width,
          color:(model.account.darkTheme) ? Colors.black: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Wrap(
            children: tagChips,
            runSpacing: 10,
            spacing: 20.0,
          )
    ))])); 
  }
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      converter: (Store<AppState> store) => ViewModel.create(store),
      builder: (BuildContext context, ViewModel model)=> Container(
        child: Column(
          children: <Widget>[
            _taskTags(task.tags, model),
            SizedBox(height: 30,),
            _projectTags(model.projects[widget.projIndex].tags, 
            task.tags,
            model)
          ],
        )
      ),
    );
  }
}