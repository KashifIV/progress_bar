import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_bar/data/Log.dart';
import 'package:redux/redux.dart'; 
import 'package:progress_bar/domain/viewmodel.dart';
import 'package:progress_bar/data/Task.dart';
import 'package:progress_bar/domain/redux.dart';

class TaskTags extends StatefulWidget{
  final int projIndex, taskIndex; 
  TaskTags(this.projIndex, this.taskIndex); 
  _TaskTags createState() => _TaskTags(); 
}
class _TaskTags extends State<TaskTags>{
  bool isExpanded = false; 

  Widget _createGraidentChip(String tag, ViewModel model){
    return Hero(child: GestureDetector(
      onTap: (){
        Task task = model.projects[widget.projIndex].tasks[widget.taskIndex]; 
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
          model.onUpdateTask(model.projects[widget.projIndex], task); 
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
         gradient: new LinearGradient(
                          colors: [
                            Colors.purple,
                            Colors.blue[700]
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(0.9, 0.3),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.mirror),

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
          Task task = model.projects[widget.projIndex].tasks[widget.taskIndex]; 
          if (task.tags == null){
            task.tags = [tag]; 
          }
          else if (task.tags.contains(tag)){
            task.tags.remove(tag);
          }
          else {
            task.tags.add(tag); 
          }
          model.onUpdateTask(model.projects[widget.projIndex], task); 
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
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 2,
        )
      ),
      child: Center(child: TextField(
        onSubmitted: (value) {
          if (model.projects[widget.projIndex].tasks[widget.taskIndex].tags == null)
            model.projects[widget.projIndex].tasks[widget.taskIndex].tags = []; 
          model.projects[widget.projIndex].tasks[widget.taskIndex].tags.add(value); 
          model.projects[widget.projIndex].tags.add(value);
          model.onUpdateTask(model.projects[widget.projIndex], model.projects[widget.projIndex].tasks[widget.taskIndex]);
          model.onUpdateProject(model.projects[widget.projIndex]);
        },
        controller: newTagController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(6),
          hintText: 'Add a Tag +',
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
        spacing: 20.0, 
      ),
    );
  }
  Widget _projectTags(List<String> tags, List<String> used, ViewModel model){
    List<String> options = (used != null) ? tags.where((tag) => !used.contains(tag)).toList(): tags;
    List<Widget> tagChips = []; 
    options.forEach((tag) => tagChips.add(_createGraidentChip(tag, model))); 
    return ExpansionPanelList(
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
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Row(
                children: <Widget>[
                  Text('Tags',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ]
              ),
            ),
            isExpanded: isExpanded,
          body: Container(
            width: MediaQuery.of(context).size.width,
          color:Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Wrap(
            children: tagChips,
            spacing: 20.0,
          )
    ))]); 
  }
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      converter: (Store<AppState> store) => ViewModel.create(store),
      builder: (BuildContext context, ViewModel model)=> Container(
        child: Column(
          children: <Widget>[
            _taskTags(model.projects[widget.projIndex].tasks[widget.taskIndex].tags, model),
            SizedBox(height: 30,),
            _projectTags(model.projects[widget.projIndex].tags, 
            model.projects[widget.projIndex].tasks[widget.taskIndex].tags,
            model)
          ],
        )
      ),
    );
  }
}