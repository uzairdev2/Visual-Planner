// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

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
  final TextEditingController _taskName = TextEditingController();
  final TextEditingController _taskDescription = TextEditingController();
  final TextEditingController _taskDeadline = TextEditingController();
  DateTime? _selectedDate;
  bool isChecked = false;

  String? selectedMember;
  List<String> _selectedUsers = [];

  @override
  Widget build(BuildContext context) {
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
              DropDownMultiSelect<String>(
                // Explicitly specify the generic type T as String
                onChanged: (List<String> selectedValues) {
                  setState(() {
                    _selectedUsers =
                        selectedValues; // Update the _selectedUsers list directly
                  });
                },
                options: widget.member
                    .map((dynamic member) => member.toString())
                    .toList(),
                selectedValues: _selectedUsers,
                whenEmpty: 'Please select a member',
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
                      // ignore: equal_keys_in_map
                      "userid": userid,
                      "taskStatusColor": "red",
                      "taskStatusColor2": "yellow",
                    });
                    Get.back();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                    // ignore: use_build_context_synchronously
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
