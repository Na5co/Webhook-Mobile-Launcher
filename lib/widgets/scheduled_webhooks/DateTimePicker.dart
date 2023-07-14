import 'package:flutter/material.dart';

class DateTimePicker {
  static Future<DateTime?> pickDateTime(BuildContext context) async {
    final pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.purple,
              surface: Colors.grey.shade800,
            ),
          ),
          child: child ?? Container(),
        );
      },
    );

    final pickedTime = pickedDateTime != null
        ? await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData.dark().copyWith(
                  colorScheme: ThemeData.dark().colorScheme.copyWith(
                        primary: Colors.purple,
                      ),
                ),
                child: child ?? Container(),
              );
            },
          )
        : null;

    return pickedDateTime != null && pickedTime != null
        ? DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          )
        : null; // Return null if no valid date and time were selected
  }
}
