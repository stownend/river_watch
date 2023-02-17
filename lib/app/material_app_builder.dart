import 'package:flutter/material.dart';

class MaterialAppBuilder extends StatelessWidget {
  const MaterialAppBuilder({super.key, required this.builder});
  final Widget Function(BuildContext) builder;

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }
}
