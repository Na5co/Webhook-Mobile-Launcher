import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class ScheduledTimeWidget extends StatelessWidget {
  final DateTime? scheduledTime;

  const ScheduledTimeWidget({required this.scheduledTime});

  @override
  Widget build(BuildContext context) {
    final formattedScheduledTime = scheduledTime != null
        ? DateFormat.yMd().add_Hms().format(scheduledTime!)
        : 'No scheduled time';

    return Text('Scheduled Time: $formattedScheduledTime');
  }
}
