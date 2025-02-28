import 'package:flutter/cupertino.dart';

import '../../models/drive_model.dart';

// ignore: must_be_immutable
class DriveComponent extends StatefulWidget {
  late DriveModel driveModel;
  DriveComponent({
    super.key,
    required this.driveModel,
  });

  @override
  State<DriveComponent> createState() => _DriveComponentState();
}

class _DriveComponentState extends State<DriveComponent> {
  @override
  Widget build(BuildContext context) {
    return const Text('DriveComponent');
  }
}
