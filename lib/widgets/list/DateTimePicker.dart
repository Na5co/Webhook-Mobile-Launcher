import 'package:flutter/material.dart';

class DateTimePicker {
  static Future<DateTime?> pickDateTime(BuildContext context) async {
    DateTime? selectedDateTime;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.purple, // Set the desired purple color
              surface:
                  Colors.grey.shade800, // Set the desired darker grey color
            ),
          ),
          child: child ?? Container(),
        );
      },
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ThemeData.dark().colorScheme.copyWith(
                    primary: Colors.purple, // Set the desired purple color
                  ),
            ),
            child: child ?? Container(),
          );
        },
      );

      if (pickedTime != null) {
        selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }

    return selectedDateTime;
  }
}
