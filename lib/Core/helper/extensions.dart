import 'package:flutter/material.dart';
import 'package:visual_planner/Core/helper/taskType.dart';

extension TaskTypeExtension on TaskType {
  Color getColor() {
    switch (this) {
      case TaskType.done:
        return Colors.lightBlue;

      case TaskType.inProgress:
        return Colors.amber[700]!;
      // TODO: Handle this case.
      default:
        return Colors.redAccent;
    }
  }

  String toStringValues() {
    switch (this) {
      case TaskType.done:
        return "Done";
      case TaskType.inProgress:
        return "In Progress";
      default:
        return "Todo";
    }
  }
}
