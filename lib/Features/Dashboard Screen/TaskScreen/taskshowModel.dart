import 'package:cloud_firestore/cloud_firestore.dart';

class taskModel {
  String? taskDeadline;
  String? taskDescription;
  String? description;
  String? taskId;
  List<dynamic>? taskMember;
  String? taskName;
  String? taskProject;
  String? taskProjectId;
  String? taskSprint;
  String? taskStatus;
  String? taskProjectManager;
  String? userid;
  String? dueto;
  String? taskStatusColor;

  taskModel({
    this.taskDeadline,
    this.taskDescription,
    this.description,
    this.taskId,
    this.taskMember,
    this.taskName,
    this.taskProject,
    this.taskProjectId,
    this.taskSprint,
    this.taskStatus,
    this.taskProjectManager,
    this.userid,
    this.dueto,
    this.taskStatusColor,
  });

  taskModel.fromJson(json) {
    taskDeadline = json['taskDeadline'];
    taskDescription = json['taskDescription'];
    description = json['description'];
    taskId = json['taskId'];
    taskMember = json['taskMember'];
    taskName = json['taskName'];
    taskProject = json['taskProject'];
    taskProjectId = json['taskProjectId'];
    taskSprint = json['taskSprint'];
    taskStatus = json['taskStatus'];
    taskProjectManager = json['taskProjectManager'];
    userid = json['userid'];
    dueto = json['dueto'];
    taskStatusColor = json['taskStatusColor'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['taskDeadline'] = taskDeadline;
    data['taskDescription'] = taskDescription;
    data['description'] = description;
    data['taskId'] = taskId;
    data['taskMember'] = taskMember;
    data['taskName'] = taskName;
    data['taskProject'] = taskProject;
    data['taskProjectId'] = taskProjectId;
    data['taskSprint'] = taskSprint;
    data['taskStatus'] = taskStatus;
    data['taskProjectManager'] = taskProjectManager;
    data['userid'] = userid;
    data['dueto'] = dueto;
    data['taskStatusColor'] = taskStatusColor;
    return data;
  }
}
