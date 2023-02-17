import 'package:flutter/material.dart';

import '../home/my_scaffold.dart';

class BrowsePage extends StatelessWidget {
  const BrowsePage({super.key});

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as String;

    return MyScaffold(
      navName: "Browse",
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Browse...$args",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}