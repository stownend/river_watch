import 'package:flutter/material.dart';

import '../../common_models/api_status.dart';

class AppError extends StatelessWidget {
  const AppError({super.key, required this.appError});

  final Failure appError;
  
  @override
  Widget build(BuildContext context) {

    return Center(
      child: Card(
        color: Colors.red[200],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.error),
              title: const Text('Error'),
              subtitle: Text(appError.errorResponse.toString()),
            )
          ]
        ),
      )
    );
  }
}