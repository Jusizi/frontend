// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';

class SwitchComponent extends StatefulWidget {
  bool value;

  Function onChanged;
  SwitchComponent({
    super.key,
    required this.onChanged,
    required this.value,
  });

  @override
  State<SwitchComponent> createState() => _SwitchComponentState();
}

class _SwitchComponentState extends State<SwitchComponent> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: widget.value,
      onChanged: (value) {
        widget.onChanged();
      },
    );
  }
}
