import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../services/app_settings_service.dart';
import '../../models/browse_list.dart';
import '../../services/browse_service.dart';

import '../../ioc.dart';
import '../home/my_scaffold.dart';
import '../../services/logging_service.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({super.key});

  @override
  BrowsePageState createState() => BrowsePageState();
}

class BrowsePageState extends State<BrowsePage> {
  late Future<BrowseList?> _regions = Future<BrowseList?>.value(null);

  final _appSettingsService = getIt.get<AppSettingsService>();
  final _loggingService = getIt.get<LoggingService>();
  final _browseService = getIt.get<BrowseService>();
  
  late Logger _logger;
  
  @override
  void initState() {
    super.initState();
  
      _logger = _loggingService.getLogger(this);

      Future.delayed(Duration.zero, () {

        List<String> parentList = [];

        setState(() {
          var args = ModalRoute.of(context)!.settings.arguments;

          String parents = args == null ? "" : args as String;
          parentList = parents == "" ? [] : parents.split('|');
        });
        try {
          _regions = _browseService.getBrowseList(parentList);  
        } catch (ex, st) 
        {
          _logger.e("HTTP Error", ex, st);
        }
      });
  }


  @override
  Widget build(BuildContext context) {

    return MyScaffold(
      navName: "Browse",
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            FutureBuilder<BrowseList?>(
              future: _regions,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(snapshot.data!.scope, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.names.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.pushNamed(context, _appSettingsService.getRouteByIndex(_appSettingsService.getRouteIndexByUiName("Browse")).routeName, arguments: snapshot.data!.names[index]);
                              },
                              title: Text(snapshot.data!.names[index])
                            )
                          );
                        }
                      )
                    ],
                  ); 
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    CircularProgressIndicator()
                  ],
                ); 
              },
            ),
            ],
          ),
        ),
      ),
    );
  }
}