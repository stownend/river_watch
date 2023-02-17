import 'package:flutter/material.dart';

import 'my_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return MyScaffold(
      navName: "Home",
      body: Column(
        children: [
          Text("Home Page", style: Theme.of(context).textTheme.headlineMedium)
        ],
      )
    );

  }
}

