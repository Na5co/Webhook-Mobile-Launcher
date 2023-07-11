import 'package:flutter/material.dart';

class SimpleSwitchWidget extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const SimpleSwitchWidget({
    Key? key,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  _SimpleSwitchWidgetState createState() => _SimpleSwitchWidgetState();
}

class _SimpleSwitchWidgetState extends State<SimpleSwitchWidget> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _value,
      onChanged: (newValue) {
        print('sward');
        setState(() {
          _value = newValue;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(newValue);
        }
      },
    );
  }
}
