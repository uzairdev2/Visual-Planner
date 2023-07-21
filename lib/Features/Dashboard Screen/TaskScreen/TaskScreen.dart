import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Splash Screen/splash_screen.dart';
import '../InvaitionScreen/invitionScreen.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class TaskScreen extends StatefulWidget {
  TaskScreen({required this.data, required this.member, super.key});
  dynamic data;
  List member;

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  // ignore: prefer_final_fields
  List _selectedUsers = [];

  bool _isSelected(String name) {
    if (_selectedUsers.contains(name)) {
      return true;
    } else {
      return false;
    }
  }

  final TextEditingController _taskName = TextEditingController();
  final TextEditingController _taskDescription = TextEditingController();
  final TextEditingController _taskDeadline = TextEditingController();
  DateTime? _selectedDate;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    String selectedMember = widget.member[
        0]; // Set the initial selected member to the first member in the list

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CommonAppBar(
            ScreenName: "Create a Task",
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              const Text("Select Team Member"),
              const SizedBox(
                height: 10,
              ),
              DropdownButton<String>(
                value: selectedMember,
                hint: Text('Please select a user'), // Add a hint text
                onChanged: (String? newValue) {
                  setState(() {
                    selectedMember = newValue!;
                    // Call a separate function to handle updating selected users
                    _isSelected(selectedMember);
                  });
                },

                onTap: () {
                  setState(() {});
                },
                items: (widget.member
                        .map<String>((dynamic member) => member.toString()))
                    .map<DropdownMenuItem<String>>((String member) {
                  return DropdownMenuItem<String>(
                    value: member,
                    onTap: () {
                      setState(() {});
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.amber[100],
                      ),
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isChecked = !isChecked;
                                if (isChecked) {
                                  // Add the member to the selected users list
                                  _selectedUsers.add(member);
                                } else {
                                  // Remove the member from the selected users list
                                  _selectedUsers.remove(member);
                                }
                              });
                            },
                            icon: Icon(isChecked
                                ? Icons.check_box
                                : Icons.check_box_outline_blank),
                            color: Colors.blue,
                          ),
                          Text(member),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              fixheight2,
              TextField(
                controller: _taskName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Task Name',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _taskDescription,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Task Description',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _taskDeadline,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => selectDate(context),
                  ),
                  labelText: 'Task Deadline',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_taskDeadline.text == "" ||
                      _taskDescription.text == "" ||
                      _taskName.text == "") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please Fill All Fields"),
                      ),
                    );
                  } else {
                    Get.defaultDialog(
                      title: "Adding Task",
                      content: const CircularProgressIndicator(),
                    );
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
                      "taskStatusColor2": "yellow",
                    });
                    Get.back();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Task Added Successfully"),
                      ),
                    );
                  }
                },
                child: const Text('Add Task'),
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
