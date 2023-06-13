import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:visual_planner/Core/models/commonData.dart';

import '../../Splash Screen/splash_screen.dart';
import '../InvaitionScreen/invaitionScreen.dart';

class TaskScreen extends StatefulWidget {
  TaskScreen({required this.data, required this.member, super.key});
  dynamic data;
  List member;

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  List _selectedUsers = [];

  bool _isSelected(String name) {
    if (_selectedUsers.contains(name)) {
      return true;
    } else {
      return false;
    }
  }

  TextEditingController _taskName = TextEditingController();
  TextEditingController _taskDescription = TextEditingController();
  TextEditingController _taskDeadline = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CommonAppBar(
            ScreenName: "Task CreateScreen",
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Text("Select Team Member"),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 60,
                // width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.member.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.amber[100],
                      ),
                      width: 300,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: _isSelected(widget.member[index]),
                              onChanged: (value) {
                                if (value == true) {
                                  setState(() {
                                    _selectedUsers.add(widget.member[index]);
                                    log("herei s the selected user $_selectedUsers ${_selectedUsers.length}");
                                  });
                                } else {
                                  setState(() {
                                    _selectedUsers.remove(widget.member[index]);
                                    log("herei s the selected user $_selectedUsers ${_selectedUsers.length}");
                                  });
                                }
                              },
                            ),
                            Text(widget.member[index]),
                          ]),
                    );
                  },
                ),
              ),
              fixheight2,
              TextField(
                controller: _taskName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Task Name',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _taskDescription,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Task Description',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _taskDeadline,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => selectDate(context),
                  ),
                  labelText: 'Task Deadline',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_taskDeadline.text == "" ||
                      _taskDescription.text == "" ||
                      _taskName.text == "") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please Fill All Fields"),
                      ),
                    );
                  } else {
                    // for (int i = 0; i < _selectedUsers.length; i++){

                    await FirebaseFirestore.instance
                        .collection("Tasks")
                        .doc(DateTime.now().toString())
                        .set({
                      "taskName": _taskName.text,
                      "userid": userid,
                      "taskDescription": _taskDescription.text,
                      "taskMember": _selectedUsers,
                      "taskStatus": "Todo",
                      "taskSprint": widget.data["sprintName"],
                      "taskProject": widget.data["projectName"],
                      "taskProjectId": widget.data["projectId"],
                      "taskId": DateTime.now().toString(),
                      "taskProjectManager": widget.data["createdByName"],
                      "dueto":
                          "${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}",
                      "userid": userid,
                      "taskStatusColor": "red",
                    });
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Task Added Successfully"),
                    ),
                  );
                  Navigator.pop(context);
                  // }
                },
                child: Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _taskDeadline.text = _selectedDate.toString().split(' ')[0];
      });
    }
  }
}
