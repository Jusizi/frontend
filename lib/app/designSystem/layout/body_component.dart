import 'package:flutter/material.dart';

class Bodycomponent extends StatelessWidget {
  final Widget bodyWidget;
  const Bodycomponent({
    super.key,
    required this.bodyWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/icons/1.png',
              ),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Container(
          color: Colors.white.withValues(alpha: .8),
        ),
        bodyWidget,
      ],
    );
  }
}
