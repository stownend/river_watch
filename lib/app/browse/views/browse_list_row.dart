import 'package:flutter/material.dart';

import '../../../common_models/view_argument.dart';
import '../../../common_services/app_settings_service.dart';
import '../../../common_services/logging_service.dart';
import '../../../ioc.dart';
import '../models/browse_list.dart';
import '../repositories/browse_service.dart';

// ignore: must_be_immutable
class BrowseListRow extends StatelessWidget {
  BrowseListRow({super.key, required this.browseList, required this.initialParents});

  //final BrowseViewModel browseViewModel;
  final String initialParents;
  final BrowseList browseList;

  final _browseService = getIt.get<BrowseService>();

  final _appSettingsService = getIt.get<AppSettingsService>();
  final _loggingService = getIt.get<LoggingService>();

  late BuildContext _ctx;

  @override
  Widget build(BuildContext context) {

    // ignore: unused_local_variable
    var logger = _loggingService.getLogger(this);
    _ctx = context;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(browseList.scope, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: browseList.names.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  onTap: () async {
                    //await Future.delayed(const Duration(seconds: 5));
                    
                    List<String> parents = initialParents == "" ? [] : initialParents.split('|');

                    if (parents.length == 4) {
                      Navigator.pushNamed(
                        context, 
                        "/station", 
                        arguments: ViewArgument(argString: "", argInt: browseList.ids[index], navNameOverride: "Browse"));

                    } else {

                      var newParents = "$initialParents${initialParents != "" ? "|" : ""}${browseList.names[index]}";

                      await _browseService.readStationsInRiver(newParents);
                      
                      Navigator.pushNamed(
                        getContext(), 
                        _appSettingsService.getRouteByIndex(_appSettingsService.getRouteIndexByUiName("Browse")).routeName, 
                        arguments: newParents
                      );
                    }                   

                  },
                  title: Text(browseList.names[index])
                )
              );
            }
          )
        )
      ],
    );

  }

  getContext () {
    return _ctx;
  }


}