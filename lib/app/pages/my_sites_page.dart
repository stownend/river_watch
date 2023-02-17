import 'package:flutter/material.dart';

import '../home/my_scaffold.dart';

class MySitesPage extends StatelessWidget {
  const MySitesPage({super.key});

  @override
  Widget build(BuildContext context) {

    return MyScaffold(
      navName: "My Sites",
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "My Sites...",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}