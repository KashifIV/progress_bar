import 'package:flutter/material.dart';

class Account{
  static const ProgressTypes = ['Task','Deadline', 'Time'];
  static const SortingTypes = ['Date Created', 'Deadline', 'Duration'];
  String id; 
  String profileImageURL; 
  String name; 
  String email; 
  bool darkTheme; 
  Image profileImage; 
  String progressType, sortingType; 
  List<String> joinedProjects = []; 
  Account({this.id, this.profileImageURL, this.name, this.email, this.joinedProjects, this.sortingType, this.progressType, this.darkTheme}); 
  
  Map<String, dynamic> mapTo(){
    var dataMap = new Map<String, dynamic>(); 
    dataMap['name'] = this.name; 
    //dataMap['profileImageURL'] = this.profileImageURL; 
    dataMap['email'] = this.email; 
    dataMap['joinedProjects'] = this.joinedProjects; 
    dataMap['progressType']  = this.progressType; 
    dataMap['darkTheme'] = this.darkTheme;
    dataMap['sortingType'] = this.sortingType; 
    return dataMap; 
  }
  factory Account.fromMap(String id, Map<String, dynamic> map){
    return Account(
      id: id, 
      profileImageURL: map['profileImageURL'], 
      name: map['name'], 
      email: map['email'], 
      darkTheme: (map.containsKey('darkTheme')) ?  map['darkTheme'] : false,
      joinedProjects: (map.containsKey('joinedProjects'))? map['joinedProjects'].cast<String>() : [],
      progressType: (map.containsKey('progressType')) ? map['progressType'] : 'Task', 
      sortingType: (map.containsKey('sortingType')) ? map['sortingType'] : SortingTypes[0],
    ); 
  }
}